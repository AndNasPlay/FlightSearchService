//
//  CoreDataHelper.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 28.07.2021.
//

#import "CoreDataHelper.h"

@interface CoreDataHelper ()

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation CoreDataHelper

+ (instancetype)sharedInstance {
	static CoreDataHelper *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[CoreDataHelper alloc] init];
		[instance setup];
	});
	return instance;
}

- (void)setup {
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FavoriteTicket" withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

	NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];

	NSPersistentStore* store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];

	if (!store) {
		abort();
	}

	_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	_managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (void)save {
	NSError *error;
	[self.managedObjectContext save: &error];
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
	}
}

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
	request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", [[ticket valueForKey:@"price"] integerValue], ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, [[ticket valueForKey:@"flightNumber"] integerValue]];
	return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (FavoriteMapPriceTicket *)favoriteMapWithPrice:(FavoriteMapPriceTicket *)price {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPriceTicket"];
	NSLog(@"price == %ld", (long)price.price);
	NSLog(@"from == %@", price.from);
	NSLog(@"to == %@", price.to);
	NSLog(@"departure == %@", price.departure);
	request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND from == %@ AND to == %@ AND departure == %@", (long)price.price, price.from, price.to, price.departure];
	return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket {
	return [self favoriteFromTicket:ticket] != nil;
}

- (BOOL)isFavoriteMapWithPrice:(FavoriteMapPriceTicket *)price {
	return [self favoriteMapWithPrice:price] != nil;
}

- (void)addToFavorite:(Ticket *)ticket {
	FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:_managedObjectContext];
	favorite.price = ticket.price.intValue;
	favorite.airline = ticket.airline;
	favorite.departure = ticket.departure;
	favorite.expires = ticket.expires;
	favorite.flightNumber = ticket.flightNumber.intValue;
	favorite.returnDate = ticket.returnDate;
	favorite.from = ticket.from;
	favorite.to = ticket.to;
	favorite.created = [NSDate date];
	NSLog(@"Сохраняем в coredata - %@, %@, %@, %hd, %@, %lld, %@, %@", favorite.airline, favorite.departure, favorite.expires, favorite.flightNumber, favorite.from, favorite.price, favorite.returnDate, favorite.to);

	[self save];
}

- (void)removeFromFavorite:(Ticket *)ticket {
	FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
	if (favorite) {
		[_managedObjectContext deleteObject:favorite];
		[self save];
	}
}

- (void)addToFavoriteMapWithPrice:(FavoriteMapPriceTicket *)price {
	FavoriteMapPriceTicket *mapPriceFavorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteMapPriceTicket" inManagedObjectContext:_managedObjectContext];
	mapPriceFavorite.price = price.price;
	mapPriceFavorite.departure = price.departure;
	mapPriceFavorite.from = price.from;
	mapPriceFavorite.to = price.to;
//	mapPriceFavorite.airline = @"test";
	mapPriceFavorite.created = [NSDate date];

	[self save];
}

- (void)removeFromFavoriteMapWithPrice:(MapWithPrice *)price {
	FavoriteMapPriceTicket *mapPrice = [self favoriteMapWithPrice:price];
	if (mapPrice) {
		[_managedObjectContext deleteObject:mapPrice];
		[self save];
	}
}

- (NSArray *)favorites {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
	return [_managedObjectContext executeFetchRequest:request error:nil];
}

- (NSArray *)favoritesMapWithPrices {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPriceTicket"];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"departure" ascending:NO]];
	return [_managedObjectContext executeFetchRequest:request error:nil];
}

@end

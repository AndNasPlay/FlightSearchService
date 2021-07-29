//
//  CoreDataHelper.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 28.07.2021.
//

#import "CoreDataHelper.h"
#import "FlightSearchService-Swift.h"

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

	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];

	self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: self.managedObjectModel];

	NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask] lastObject];

	NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];

	NSPersistentStore *store = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];

	if (!store) {
		abort();
	}

	self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
}

- (void)save {
	NSError *error;
	[self.managedObjectContext save: &error];
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
	}
}

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
	NSFetchRequest *reqest = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTecket"];
	reqest.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND departure == %@ AND expires == %@ AND flightNumer == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
	return [[self.managedObjectContext executeFetchRequest:reqest error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket {
	return [self favoriteFromTicket:ticket] != nil;
}

- (void)addToFavorite:(Ticket *)ticket {

	FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:self.managedObjectContext];
	favorite.price = ticket.price.intValue;
	favorite.airline = ticket.airline;
	favorite.departure = ticket.departure;
	favorite.expires = ticket.expires;
	favorite.flightNumber = ticket.flightNumber.intValue;
	favorite.from = ticket.from;
	favorite.to = ticket.to;
	favorite.returnDate = ticket.returnDate;
	favorite.created = [NSDate date];

	[self save];
}

- (void)removeFromFavorite:(Ticket *)ticket {
	FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
	if (favorite) {
		[self.managedObjectContext deleteObject:favorite];
		[self save];
	}
}

- (NSArray *)favorites {
	NSFetchRequest *reqest = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
	reqest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
	return [self.managedObjectContext executeFetchRequest:reqest error:nil];
}


@end

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



@end

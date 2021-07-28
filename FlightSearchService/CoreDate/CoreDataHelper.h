//
//  CoreDataHelper.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 28.07.2021.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"
#import <CoreData/CoreData.h>
#import "DataManager.h"


@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray *)favorites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;

@end


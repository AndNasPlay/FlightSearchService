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
#import "MapWithPrice.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "FavoriteMapPriceTicket+CoreDataClass.h"


@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

	- (BOOL)isFavorite:(Ticket *)ticket;
	- (BOOL)isFavoriteMapWithPrice:(FavoriteMapPriceTicket *)price;
	- (NSArray *)favorites;
	- (NSArray *)favoritesMapWithPrices;
	- (void)addToFavorite:(Ticket *)ticket;
	- (void)removeFromFavorite:(Ticket *)ticket;
	- (void)addToFavoriteMapWithPrice:(FavoriteMapPriceTicket *)price;
	- (void)removeFromFavoriteMapWithPrice:(FavoriteMapPriceTicket *)price;

@end


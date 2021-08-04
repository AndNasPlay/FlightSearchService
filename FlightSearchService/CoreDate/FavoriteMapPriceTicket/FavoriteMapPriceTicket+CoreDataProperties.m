//
//  FavoriteMapPriceTicket+CoreDataProperties.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 04.08.2021.
//
//

#import "FavoriteMapPriceTicket+CoreDataProperties.h"

@implementation FavoriteMapPriceTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPriceTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPriceTicket"];
}

@dynamic created;
@dynamic to;
@dynamic from;
@dynamic price;
@dynamic flightNumber;
@dynamic departure;
@dynamic numberOfChanges;
@dynamic airline;

@end

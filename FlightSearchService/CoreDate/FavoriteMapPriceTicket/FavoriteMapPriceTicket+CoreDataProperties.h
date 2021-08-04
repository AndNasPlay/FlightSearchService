//
//  FavoriteMapPriceTicket+CoreDataProperties.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 04.08.2021.
//
//

#import "FavoriteMapPriceTicket+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteMapPriceTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPriceTicket *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSString *to;
@property (nullable, nonatomic, copy) NSString *from;
@property (nonatomic) int64_t price;
@property (nonatomic) int16_t flightNumber;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nonatomic) int16_t numberOfChanges;
@property (nullable, nonatomic, copy) NSString *airline;

@end

NS_ASSUME_NONNULL_END

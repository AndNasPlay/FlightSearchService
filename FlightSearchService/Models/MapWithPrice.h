//
//  MapWithPrice.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 25.07.2021.
//

#import <Foundation/Foundation.h>
#import "City.h"


@interface MapWithPrice : NSObject

	@property (nonatomic, strong) City *destination;
	@property (nonatomic, strong) City *origin;
	@property (nonatomic, strong) NSDate *departure;
	@property (nonatomic, strong) NSDate *returnDate;
	@property (nonatomic) NSInteger numberOfchanges;
	@property (nonatomic) NSInteger price;
	@property (nonatomic) NSInteger distance;
	@property (nonatomic) BOOL actual;

- (instancetype)initWithDicrionary: (NSDictionary *)dictionary withOrigin: (City *)origin;

@end


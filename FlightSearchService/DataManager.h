//
//  DataManager.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import <Foundation/Foundation.h>
#import "County.h"
#import "City.h"
#import "Airport.h"

#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

typedef enum DataSourceType {
	DataSourceTypeCountry,
	DataSourceTypeCity,
	DataSourceTypeAirport
} DataSourceType;


@interface DataManager : NSObject

+ (instancetype)sharedInstance;
- (void)loadData;

@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *airports;

@end


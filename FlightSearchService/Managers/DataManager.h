//
//  DataManager.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import <Foundation/Foundation.h>
#import "Country.h"
#import "City.h"
#import "Airport.h"

#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

typedef enum DataSourceType {
	DataSourceTypeCountry,
	DataSourceTypeCity,
	DataSourceTypeAirport
} DataSourceType;

typedef struct SearchRequest {
	__unsafe_unretained NSString *origin;
	__unsafe_unretained NSString *destination;
	__unsafe_unretained NSDate *departDate;
	__unsafe_unretained NSDate *returnDate;
} SearchRequest;

@interface DataManager : NSObject

+ (instancetype)sharedInstance;
- (void)loadData;
- (City *)cityForIata:(NSString *)iata;
- (City *)cityForLocation:(CLLocation *)location;

@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *airports;

@end


//
//  Airport.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import "Airport.h"

@implementation Airport

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		_timezone = [dictionary valueForKey:@"timezone"];
		_translations =  [dictionary valueForKey:@"translations"];
		_name = [dictionary valueForKey:@"name"];
		_countryCode = [dictionary valueForKey:@"countryCode"];
		_cityCode = [dictionary valueForKey:@"cityCode"];
		_code = [dictionary valueForKey:@"code"];
		_flightable = [dictionary valueForKey:@"flightable"];

		NSDictionary *coordinates = [dictionary valueForKey:@"coordinate"];
		if (coordinates && ![coordinates isEqual:[NSNull null]]) {
			NSNumber *lon = [coordinates valueForKey:@"lon"];
			NSNumber *lat = [coordinates valueForKey:@"lat"];
			if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]) {
				_coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
			}
		}
	}
	return  self;
}

@end

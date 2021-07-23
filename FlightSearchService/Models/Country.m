//
//  Country.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import "Country.h"

@implementation Country

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		_currency = [dictionary valueForKey:@"currency"];
		_translations = [dictionary valueForKey:@"name_translations"];
		_name = [dictionary valueForKey:@"name"];
		_code = [dictionary valueForKey:@"code"];
	}
	return self;
}

@end

//
//  County.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import "County.h"

@implementation County

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		_currency = [dictionary valueForKey:@"currency"];
		_translations = [dictionary valueForKey:@"translations"];
		_name = [dictionary valueForKey:@"name"];
		_code = [dictionary valueForKey:@"code"];
	}
	return  self;
}

@end

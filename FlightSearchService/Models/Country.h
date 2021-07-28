//
//  Country.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

	@property (nonatomic, strong) NSString *name;
	@property (nonatomic, strong) NSString *currency;
	@property (nonatomic, strong) NSDictionary *translations;
	@property (nonatomic, strong) NSString *code;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

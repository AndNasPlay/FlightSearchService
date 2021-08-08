//
//  ApiManager.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 23.07.2021.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApiManager : NSObject

	+ (instancetype) sharedInstance;
	- (void)cityForCurrentIP:(void (^)(City *city))completion;
	- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;
	- (void)mapPricesFor:(City *)origin withCompletion:(void (^)(NSArray *prices))completion;

@end

NS_ASSUME_NONNULL_END

//
//  ApiManager.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 23.07.2021.
//

#import "ApiManager.h"
#import "Ticket.h"
#import "MapWithPrice.h"

#define API_TOKEN @"TOKEN"
#define API_URL_IP_ADDRESS @"https://api.ipify.org/?format=json"
#define API_URL_CHEAP @"https://api.travelpayouts.com/v1/prices/direct"
#define API_URL_CITY_FROM_IP @"https://www.travelpayouts.com/whereami?ip="
#define API_URL_MAP_PRICE @"https://map.aviasales.ru/prices.json?origin_iata="

@implementation ApiManager

//Singleton ApiManager

+ (instancetype)sharedInstance {
	static ApiManager *instance; 
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[ApiManager alloc] init];
	});
	return instance;
}

//Getting city from ip address

- (void)cityForCurrentIP:(void (^)(City * _Nonnull))completion {
	[self IPAdressWithCompletion:^(NSString *ipAdress) {
		[self load:[NSString stringWithFormat:@"%@%@", API_URL_CITY_FROM_IP, ipAdress] withCompletion:^(id _Nullable result) {
			NSDictionary *json = result;
			NSString *iata = [json valueForKey:@"iata"];
			if (iata) {
				City *city = [[DataManager sharedInstance] cityForIata: iata];
				if (city) {
					dispatch_async(dispatch_get_main_queue(), ^{
						completion(city);
					});
				}
			}
		}];
	}];
}

//Getting ip address

- (void)IPAdressWithCompletion:(void (^)(NSString *ipAdress))completion {
	[self load:API_URL_IP_ADDRESS withCompletion:^(id _Nullable result) {
		NSDictionary *json = result;
		completion([json valueForKey:@"ip"]);
	}];
}

- (void)load:(NSString *)urlString withCompletion:(void (^)(id _Nullable result))completion {
	[[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
		completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
	}] resume];
}

//Getting Ticket

- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion {
	NSString *urlString = [NSString stringWithFormat:@"%@?%@&token=%@", API_URL_CHEAP, SearchRequestQuery(request), API_TOKEN];
	[self load:urlString withCompletion:^(id _Nullable result) {
		NSDictionary *response = result;
		if (response) {
			NSDictionary *json = [[response valueForKey:@"data"] valueForKey:request.destination];
			NSMutableArray *array = [NSMutableArray new];
			for (NSString *key in json) {
				NSDictionary *value = [json valueForKey:key];
				Ticket *ticket = [[Ticket alloc] initWithDictionary:value];
				ticket.from = request.origin;
				ticket.to = request.destination;
				ticket.returnDate = request.returnDate;
				ticket.departure = request.departDate;
				[array addObject:ticket];
			}
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(array);
			});
		}
	}];
}

NSString *SearchRequestQuery(SearchRequest request) {
	NSString *result = [NSString stringWithFormat:@"origin=%@&destination=%@", request.origin, request.destination];
	if (request.departDate) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd";
		result = [NSString stringWithFormat:@"%@&depart_date=%@", result, [dateFormatter stringFromDate:request.departDate ]];
	}
	return result;
}

- (void)mapPricesFor:(City *)origin withCompletion:(void (^)(NSArray *prices))completion {
	static BOOL isLoading;
	if (isLoading) {
		return;
	}
	isLoading = YES;
	[self load:[NSString stringWithFormat:@"%@%@", API_URL_MAP_PRICE, origin.code] withCompletion:^(id _Nullable result) {
		NSArray *array = result;
		NSMutableArray *prices = [NSMutableArray new];
		if (array) {
			for (NSDictionary *mapPricesDictionary in array) {
				MapWithPrice *mapPrice = [[MapWithPrice alloc] initWithDicrionary:mapPricesDictionary withOrigin:origin];
				[prices addObject:mapPrice];
			}
			isLoading = NO;
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(prices);
			});
		}
	}];
}


@end

//
//  LocationService.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 25.07.2021.
//

#import "LocationService.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>


@interface LocationService() <CLLocationManagerDelegate>

	@property(nonatomic, strong) CLLocationManager *locationManager;
	@property(nonatomic, strong) CLLocation *currentLocation;

@end

@implementation LocationService

- (instancetype)init {
	self = [super init];
	if (self) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		[self.locationManager requestAlwaysAuthorization];
	}
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
		[self.locationManager startUpdatingLocation];
	} else if (status != kCLAuthorizationStatusNotDetermined) {
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Mistake" message:@"Unable to determine the current city" preferredStyle:UIAlertControllerStyleAlert];
		[alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil]];
		[[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:alertController animated:YES completion:nil];
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	if (!self.currentLocation) {
		self.currentLocation = [locations firstObject];
		[self.locationManager stopUpdatingLocation];
		[[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateLocation object:self.currentLocation];
	}
}
@end

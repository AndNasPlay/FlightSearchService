//
//  MapViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 25.07.2021.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "ApiManager.h"
#import <MapKit/MapKit.h>
#import "DataManager.h"
#import "MapWithPrice.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Map Prices";

	self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	self.mapView.showsUserLocation = YES;
	[self.view addSubview:self.mapView];

	[[DataManager sharedInstance] loadData];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataSucccessfully) name:kDataManagerLoadDataDidComplete object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateLocation object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadDataSucccessfully {
	self.locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
	CLLocation *currentLocation = notification.object;
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
	[self.mapView setRegion:region animated:YES];
	if (currentLocation) {
		self.origin = [[DataManager sharedInstance] cityForLocation: currentLocation];
		if (self.origin) {
			[[ApiManager sharedInstance] mapPricesFor:self.origin withCompletion:^(NSArray *prices) {
				self.prices = prices;
			}];
		}
	}
}

- (void)setPrices:(NSArray *)prices {
	_prices = prices;
	[_mapView removeAnnotations: _mapView.annotations];

	for (MapWithPrice *price in prices) {
		dispatch_async(dispatch_get_main_queue(), ^{
			MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
			annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
			annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
			annotation.coordinate = price.destination.coordinate;

			[self->_mapView addAnnotation: annotation];
		});
	}
}


@end

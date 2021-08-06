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
#import "CoreDataHelper.h"

@interface MapViewController () <MKMapViewDelegate>

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
	[self.view addSubview:_mapView];
	[_mapView setDelegate: self];

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
			annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.price];
			annotation.coordinate = price.destination.coordinate;

			[self->_mapView addAnnotation:annotation];
		});
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	static NSString *identifier = @"MarkerIdentifier";
	MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	if (!annotationView) {
		annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
		annotationView.canShowCallout = YES;
		annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
		annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		annotationView.rightCalloutAccessoryView.tintColor = UIColor.clearColor;
		annotationView.glyphImage = [UIImage imageNamed:@"MapMarker"];
	}
	annotationView.annotation = annotation;
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	NSUInteger index = [mapView.annotations indexOfObject:view.annotation];
	CLLocationCoordinate2D  testCoord = [[mapView.annotations objectAtIndex:index] coordinate];
	NSUInteger count = 0;
	for (MapWithPrice *price in _prices) {
		if ((round(1000*testCoord.latitude)/1000) == (round(1000*price.destination.coordinate.latitude)/1000)) {
			count = [_prices indexOfObject:price];
			break;
		}
	}
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"actions_with_tickets", "") message:NSLocalizedString(@"actions_with_tickets_describe", "") preferredStyle:UIAlertControllerStyleActionSheet];

	UIAlertAction *favoriteAction;

	if ([[CoreDataHelper sharedInstance] isFavoriteMapWithPrice: [_prices objectAtIndex:count]]) {
		favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"remove_from_favorite", "") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

			[[CoreDataHelper sharedInstance] removeFromFavoriteMapWithPrice:[self->_prices objectAtIndex:count]];
		}];
	} else {
		favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"add_to_favorite", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

			[[CoreDataHelper sharedInstance] addToFavoriteMapWithPrice: [self->_prices objectAtIndex:count]];
		}];
	}

	UIAlertAction *cancelAction = [UIAlertAction
								   actionWithTitle:NSLocalizedString(@"close", "")
								   style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:favoriteAction];
	[alertController addAction:cancelAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

@end

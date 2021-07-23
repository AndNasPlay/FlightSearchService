//
//  MainViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import "MainViewController.h"
#import "PlaceViewController.h"
#import "DataManager.h"

@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;

@end

@implementation MainViewController 

- (void)viewDidLoad {
	[super viewDidLoad];
	[[DataManager sharedInstance] loadData];

	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationController.navigationBar.prefersLargeTitles = YES;
	self.title = @"Search";

	self.departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.departureButton setTitle:@"From" forState:UIControlStateNormal];
	self.departureButton.tintColor = [UIColor blackColor];
	self.departureButton.frame = CGRectMake(30.0, 140.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
	self.departureButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
	[self.departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.departureButton];

	self.arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.arrivalButton setTitle:@"Where" forState:UIControlStateNormal];
	self.arrivalButton.tintColor = [UIColor blackColor];
	self.arrivalButton.frame = CGRectMake(30.0, CGRectGetMaxY(self.departureButton.frame) + 20.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
	self.arrivalButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
	[self.arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.arrivalButton];
}

- (void)placeButtonDidTap:(UIButton *)sender {
	PlaceViewController *newViewController;
	if ([sender isEqual:self.departureButton]) {
		newViewController = [[PlaceViewController alloc] initWithType:PlaceTypeDeparture];
	} else {
		newViewController = [[PlaceViewController alloc] initWithType:PlaceTypeArrival];
	}
	newViewController.delegate = self;
	[self.navigationController pushViewController:newViewController animated:YES];
}

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
	[self setPlace:place withDataType:dataType andPlaceType:placeType forButton: (placeType == PlaceTypeDeparture) ? _departureButton : _arrivalButton];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button {

	NSString *title;
	NSString *iata;

	if (dataType == DataSourceTypeCity) {
		City *city = (City *)place;
		title = city.name;
		iata = city.code;
	} else if (dataType == DataSourceTypeAirport) {
		Airport *airport = (Airport *)place;
		title = airport.name;
		iata = airport.cityCode;
	}
	
	if (placeType == PlaceTypeDeparture) {
		_searchRequest.origin = iata;
	} else {
		_searchRequest.destination = iata;
	}

	[button setTitle:title forState:UIControlStateNormal];
}

@end

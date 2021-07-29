//
//  MainViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import "MainViewController.h"
#import "PlaceViewController.h"
#import "DataManager.h"
#import "ApiManager.h"
#import "TicketsTableViewController.h"

@interface MainViewController () <PlaceViewControllerDelegate>

	@property (nonatomic, strong) UIButton *departureButton;
	@property (nonatomic, strong) UIButton *arrivalButton;
	@property (nonatomic) SearchRequest searchRequest;
	@property (nonatomic, strong) UIView *placeContainerView;
	@property (nonatomic, strong) UIButton *searchButton;
	@property (nonatomic, strong) UIImageView *backgroundImage;
	@property (nonatomic, strong) UIImageView *logoImage;

@end

@implementation MainViewController 

- (void)viewDidLoad {
	[super viewDidLoad];
	[[DataManager sharedInstance] loadData];
	[self createSubViews];
	self.navigationController.navigationBar.hidden = YES;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)dataLoadedSuccessfully {
	[[ApiManager sharedInstance] cityForCurrentIP:^(City *city) {
		[self setPlace:city withDataType:DataSourceTypeCity andPlaceType: PlaceTypeDeparture forButton:self->_departureButton];
	}];
}

- (void)createSubViews {
	self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
	self.backgroundImage.image = [UIImage imageNamed:@"bigBG"];
	[self.view addSubview:self.backgroundImage];

	self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 80, [UIScreen mainScreen].bounds.size.width - 120, 80)];
	self.logoImage.image = [UIImage imageNamed:@"logo"];
	[self.view addSubview:self.logoImage];

	self.placeContainerView = [[UIView alloc] initWithFrame: CGRectMake(20.0, 200.0, [UIScreen mainScreen].bounds.size.width - 40.0, 170.0)];
	self.placeContainerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
	self.placeContainerView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
	self.placeContainerView.layer.shadowOffset = CGSizeZero;
	self.placeContainerView.layer.shadowRadius = 20.0;
	self.placeContainerView.layer.shadowOpacity = 1.0;
	self.placeContainerView.layer.cornerRadius = 6.0;
	[self.view addSubview:self.placeContainerView];

	self.departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.departureButton setTitle:@"From" forState:UIControlStateNormal];
	self.departureButton.tintColor = [UIColor blackColor];
	self.departureButton.frame = CGRectMake(10.0, 20.0, self.placeContainerView.frame.size.width - 20.0, 60.0);
	self.departureButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
	[self.departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	[self.placeContainerView addSubview:self.departureButton];

	self.arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.arrivalButton setTitle:@"Where" forState:UIControlStateNormal];
	self.arrivalButton.tintColor = [UIColor blackColor];
	self.arrivalButton.frame = CGRectMake(10.0, CGRectGetMaxY(self.departureButton.frame) + 10.0, self.placeContainerView.frame.size.width - 20.0, 60.0);
	self.arrivalButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
	[self.arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	[self.placeContainerView addSubview:self.arrivalButton];

	self.searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
	self.searchButton.tintColor = [UIColor whiteColor];
	self.searchButton.frame = CGRectMake(30.0, CGRectGetMaxY(self.placeContainerView.frame) + 30.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
	self.searchButton.backgroundColor = [UIColor colorNamed:@"buttonColor"];
//	self.searchButton.layer.cornerRadius = 8.0;
	self.searchButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
	[self.searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.searchButton];
}

- (void)searchButtonDidTap:(UIButton *)sender {
	[[ApiManager sharedInstance] ticketsWithRequest:self.searchRequest withCompletion:^(NSArray *tickets) {
		if (tickets.count > 0) {
			TicketsTableViewController *ticketsVC = [[TicketsTableViewController alloc] initWithTickets:tickets];
			[self.navigationController showViewController:ticketsVC sender:self];
		} else {
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"No tickets" preferredStyle:UIAlertControllerStyleAlert];
			[alertController addAction:[UIAlertAction actionWithTitle:@"close" style:UIAlertActionStyleDefault handler:nil]];
			[self presentViewController:alertController animated:YES completion:nil];
		}
	}];
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
		NSString *departDateString = @"2021-11";
		NSString *returnDateString = @"2021-12";
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM";
		NSDate *departDate = [dateFormatter dateFromString:departDateString];
		NSDate *returnDate = [dateFormatter dateFromString:returnDateString];
		_searchRequest.departDate = departDate;
		_searchRequest.returnDate = returnDate;
		_searchRequest.origin = iata;
	} else {
		NSString *departDateString = @"2021-11";
		NSString *returnDateString = @"2021-12";
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM";
		NSDate *departDate = [dateFormatter dateFromString:departDateString];
		NSDate *returnDate = [dateFormatter dateFromString:returnDateString];
		_searchRequest.departDate = departDate;
		_searchRequest.returnDate = returnDate;
		_searchRequest.destination = iata;
	}
	[button setTitle:title forState:UIControlStateNormal];
}

@end

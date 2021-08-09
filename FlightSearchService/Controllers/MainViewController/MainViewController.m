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
#import <UIKit/UIKit.h>
#import "ProgressView.h"
#import "FirstViewController.h"

@interface MainViewController () <PlaceViewControllerDelegate>

	@property (nonatomic, strong) UIButton *departureButton;
	@property (nonatomic, strong) UIButton *arrivalButton;
	@property (nonatomic) SearchRequest searchRequest;
	@property (nonatomic, strong) UIView *placeContainerView;
	@property (nonatomic, strong) UIButton *searchButton;
	@property (nonatomic, strong) UIImageView *backgroundImage;
	@property (nonatomic, strong) UIImageView *logoImage;
	@property (nonatomic, strong) UIDatePicker *datePicker;
	@property (nonatomic, strong) UITextField *datePickerTextField;

@end

@implementation MainViewController 

- (void)viewDidLoad {
	[super viewDidLoad];
	[[DataManager sharedInstance] loadData];
	[self createSubViews];
	self.navigationController.navigationBar.hidden = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self presentFirstViewControllerIfNeeded];
}

-(void)presentFirstViewControllerIfNeeded {
	BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"first_start"];
	if (!isFirstStart) {
		FirstViewController *firstViewController = [[FirstViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
		[self presentViewController:firstViewController animated:YES completion:nil];
	}
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
	double constantHeight = 0;
	self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
	self.backgroundImage.image = [UIImage imageNamed:@"bigBG"];
	[self.view addSubview:self.backgroundImage];
	if ([UIScreen mainScreen].bounds.size.width > 350.0) {
		constantHeight = 80.0;
		self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(60.0, constantHeight, [UIScreen mainScreen].bounds.size.width - 120.0, 80.0)];
		self.logoImage.image = [UIImage imageNamed:@"logo"];
		[self.view addSubview:self.logoImage];
	} else {
		constantHeight = 60.0;
		self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 4, constantHeight, [UIScreen mainScreen].bounds.size.width / 2, 60.0)];
		self.logoImage.image = [UIImage imageNamed:@"logo"];
		[self.view addSubview:self.logoImage];
	}

	self.placeContainerView = [[UIView alloc] initWithFrame: CGRectMake(20.0, self.logoImage.frame.size.height + constantHeight + 40.0, [UIScreen mainScreen].bounds.size.width - 40.0, 230.0)];
	self.placeContainerView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
	self.placeContainerView.layer.shadowColor = [[UIColor.blackColor colorWithAlphaComponent:0.1] CGColor];
	self.placeContainerView.layer.shadowOffset = CGSizeZero;
	self.placeContainerView.layer.shadowRadius = 20.0;
	self.placeContainerView.layer.shadowOpacity = 1.0;
	self.placeContainerView.layer.cornerRadius = 6.0;
	[self.view addSubview:self.placeContainerView];

	self.departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.departureButton setTitle:@"From" forState:UIControlStateNormal];
	self.departureButton.tintColor = UIColor.blackColor;
	self.departureButton.frame = CGRectMake(10.0, 20.0, self.placeContainerView.frame.size.width - 20.0, 60.0);
	self.departureButton.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.2];
	[self.departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	[self.placeContainerView addSubview:self.departureButton];

	self.arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.arrivalButton setTitle:@"Where" forState:UIControlStateNormal];
	self.arrivalButton.tintColor = UIColor.blackColor;
	self.arrivalButton.frame = CGRectMake(10.0, CGRectGetMaxY(self.departureButton.frame) + 10.0, self.placeContainerView.frame.size.width - 20.0, 60.0);
	self.arrivalButton.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.2];
	[self.arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	[self.placeContainerView addSubview:self.arrivalButton];

	self.datePickerTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, CGRectGetMaxY(self.arrivalButton.frame) + 10.0, self.placeContainerView.frame.size.width - 20.0, 60.0)];
	self.datePickerTextField.text = @"Дата вылета";
	self.datePickerTextField.textAlignment = NSTextAlignmentCenter;
	self.datePickerTextField.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.2];
	self.datePickerTextField.tintColor = UIColor.clearColor;
	[self.placeContainerView addSubview:self.datePickerTextField];

	self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
	[self.datePicker setDatePickerMode:UIDatePickerModeDate];
	[self.datePicker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
	[self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
	self.datePickerTextField.inputView = self.datePicker;

	self.searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
	self.searchButton.tintColor = UIColor.whiteColor;
	self.searchButton.frame = CGRectMake(30.0, CGRectGetMaxY(self.placeContainerView.frame) + 30.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
	self.searchButton.backgroundColor = [UIColor colorNamed:@"buttonColor"];
	self.searchButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
	[self.searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.searchButton];
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"dd-MM-yyyy";
	self.datePickerTextField.text = [dateFormatter stringFromDate:datePicker.date];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.view endEditing:YES];
}

- (void)searchButtonDidTap:(UIButton *)sender {
	_searchRequest.departDate = self.datePicker.date;
	[self.view endEditing:YES];
	if ([self.departureButton.titleLabel.text isEqual: @"From"]) {
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Введите пункт отправления" preferredStyle:UIAlertControllerStyleAlert];
		[alertController addAction:[UIAlertAction actionWithTitle:@"close" style:UIAlertActionStyleDefault handler:nil]];
		[self presentViewController:alertController animated:YES completion:nil];
	} else if ([self.arrivalButton.titleLabel.text isEqual:@"Where"]) {
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Выедите пункт назначения" preferredStyle:UIAlertControllerStyleAlert];
		[alertController addAction:[UIAlertAction actionWithTitle:@"close" style:UIAlertActionStyleDefault handler:nil]];
		[self presentViewController:alertController animated:YES completion:nil];
	} else if ([self dateComparision:_datePicker.date andDate2:[NSDate date]]) {
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Укажите актуальную дату поездки" preferredStyle:UIAlertControllerStyleAlert];
		[alertController addAction:[UIAlertAction actionWithTitle:@"close" style:UIAlertActionStyleDefault handler:nil]];
		[self presentViewController:alertController animated:YES completion:nil];
	} else {
		[[ProgressView sharedInstance] show:^{
			[[ApiManager sharedInstance] ticketsWithRequest:self->_searchRequest withCompletion:^(NSArray *tickets) {
				[[ProgressView sharedInstance] dismiss:^{
					if (tickets.count > 0) {
						TicketsTableViewController *ticketsVC = [[TicketsTableViewController alloc] initWithTickets:tickets];
						[self.navigationController showViewController:ticketsVC sender:self];
					} else {
						UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"No tickets" preferredStyle:UIAlertControllerStyleAlert];
						[alertController addAction:[UIAlertAction actionWithTitle:@"close" style:UIAlertActionStyleDefault handler:nil]];
						[self presentViewController:alertController animated:YES completion:nil];
					}
				}];
			}];
		}];
	}
}

- (BOOL)dateComparision:(NSDate*)date1 andDate2:(NSDate*)date2 {
	NSCalendar* calendar = [NSCalendar currentCalendar];
	unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
	NSDateComponents* comp1 = [calendar components: unitFlags fromDate: date1];
	NSDateComponents* nowDate = [calendar components: unitFlags fromDate: date2];

	if (comp1.year < nowDate.year) {
		return YES;
	} else if (comp1.year > nowDate.year) {
		return NO;
	} else if (comp1.month < nowDate.month) {
		return YES;
	} else if (comp1.month > nowDate.month) {
		return NO;
	} else if (comp1.day > nowDate.day) {
		return NO;
	} else if (comp1.day < nowDate.day) {
		return YES;
	} else if (comp1.day == nowDate.day) {
		return NO;
	} else {
		return YES;
	}
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

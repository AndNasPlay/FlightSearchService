//
//  TicketsViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import "PlaceViewController.h"

#define ReuseIdentifire @"cellIdentifire"

@interface PlaceViewController ()

@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) NSArray *currentArray;

@end

@implementation PlaceViewController

- (instancetype)initWithType:(PlaceType)type {
	self = [super init];
	if (self) {
		self.placeType = type;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];

	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.view addSubview:self.tableView];

	self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Cities", @"Airports"]];
	[self.segmentControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
	self.segmentControl.tintColor = [UIColor blackColor];
	self.navigationItem.titleView = self.segmentControl;
	self.segmentControl.selectedSegmentIndex = 0;
	[self changeSource];
	
	if (self.placeType == PlaceTypeDeparture) {
		self.title = @"From";
	} else {
		self.title = @"Where";
	}
}

- (void)changeSource {
	switch (self.segmentControl.selectedSegmentIndex) {
		case 0:
			self.currentArray = [[DataManager sharedInstance] cities];
			break;
		case 1:
			self.currentArray = [[DataManager sharedInstance] airports];
			break;
		default:
			break;
	}
	[self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifire];
	if (!cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifire];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	if (self.segmentControl.selectedSegmentIndex == 0) {
		City *city = [self.currentArray objectAtIndex:indexPath.row];
		cell.textLabel.text = city.name;
		cell.detailTextLabel.text = city.code;
	} else if (self.segmentControl.selectedSegmentIndex == 1) {
		Airport *airport = [self.currentArray objectAtIndex:indexPath.row];
		cell.textLabel.text = airport.name;
		cell.detailTextLabel.text = airport.code;
	}
	return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.currentArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DataSourceType dataType = ((int) self.segmentControl.selectedSegmentIndex) +1;
	[self.delegate selectPlace:[self.currentArray objectAtIndex:indexPath.row] withType:self.placeType andDataType:dataType];
	[self.navigationController popViewControllerAnimated:YES];
}

@end

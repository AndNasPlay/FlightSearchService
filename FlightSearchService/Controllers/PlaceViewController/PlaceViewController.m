//
//  TicketsViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import "PlaceViewController.h"

#define ReuseIdentifire @"cellIdentifire"

@interface PlaceViewController () <UISearchResultsUpdating>

@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) NSArray *currentArray;
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong) UISearchController *searchController;

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

	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.obscuresBackgroundDuringPresentation = NO;
	self.searchController.searchResultsUpdater = self;
	self.searchArray = [NSArray new];

	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.tableHeaderView = self.searchController.searchBar;
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
		City *city = (self.searchController.isActive && [self.searchArray count] >0) ? [self.searchArray objectAtIndex:indexPath.row] : [self.currentArray objectAtIndex:indexPath.row];
		cell.textLabel.text = city.name;
		cell.detailTextLabel.text = city.code;
	} else if (self.segmentControl.selectedSegmentIndex == 1) {
		Airport *airport = (self.searchController.isActive && [self.searchArray count] > 0) ? [self.searchArray objectAtIndex:indexPath.row] : [self.currentArray objectAtIndex:indexPath.row];
		cell.textLabel.text = airport.name;
		cell.detailTextLabel.text = airport.code;
	}
	return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.searchController.isActive && [self.searchArray count] > 0) {
		return [self.searchArray count];
	}
	return [self.currentArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DataSourceType dataType = ((int) self.segmentControl.selectedSegmentIndex) +1;
	if (self.searchController.isActive && [self.searchArray count] > 0) {
		[self.delegate selectPlace:[self.searchArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
		self.searchController.active = NO;
	} else {
		[self.delegate selectPlace:[self.currentArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
	if (searchController.searchBar.text) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchController.searchBar.text];
		self.searchArray = [self.currentArray filteredArrayUsingPredicate:predicate];
		[self.tableView reloadData];
	}
}

@end

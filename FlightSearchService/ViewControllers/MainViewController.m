//
//  MainViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import "MainViewController.h"
#import "PlaceViewController.h"
#import "DataManager.h"
#import "TicketsTableViewCell.h"

@interface MainViewController ()

@property (strong, nonnull) UITableView *ticketsTableView;
@property (strong) NSString *cellIdentifier;
@property (strong, nonnull) NSMutableArray *elem;

@end

@implementation MainViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.cellIdentifier = @"CellIdentifier";
	self.elem = [NSMutableArray arrayWithObjects:@1,@2,@3,@4,@5, nil];
	self.ticketsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.ticketsTableView.dataSource = self;
	[self.view addSubview:self.ticketsTableView];
	[[DataManager sharedInstance] loadData];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)loadDataComplete {
	self.view.backgroundColor = [UIColor greenColor];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)openAnotherViewController {
	PlaceViewController *newViewController = [[PlaceViewController alloc] init];
	[self.navigationController showViewController:newViewController sender:self];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	TicketsTableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
	if (!newCell) {
		newCell = [[TicketsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
	}
	newCell.leftLable.text = [NSString stringWithFormat:@"left %@", self.elem[indexPath.row]];
	newCell.rightLable.text = [NSString stringWithFormat:@"right %@", self.elem[indexPath.row]];
	return newCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return  self.elem.count;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.elem removeObjectAtIndex:indexPath.row];
	[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


@end

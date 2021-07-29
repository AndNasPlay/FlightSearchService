//
//  TicketsTableViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 24.07.2021.
//

#import "TicketsTableViewController.h"
#import "TicketsTableViewCell.h"
#import "CoreDataHelper.h"

#define TicketsCellReuseIdentifier @"TicketsCellReuseIdentifier"

@interface TicketsTableViewController ()

@property(nonatomic, strong) NSArray *ticketsArray;

@end

@implementation TicketsTableViewController {
	BOOL isFavorite;
}


- (instancetype)initWithTickets:(NSArray *)tickets {
	self = [super init];
	if (self) {
		self.ticketsArray = tickets;
		self.navigationController.navigationBar.prefersLargeTitles = YES;
		self.title = @"Tickets";
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.tableView registerClass:[TicketsTableViewCell class] forCellReuseIdentifier:TicketsCellReuseIdentifier];
	}
	return self;
}

- (instancetype)initFavoriteTicketsController {
	self = [super init];
	if (self) {
		isFavorite = YES;
		self.ticketsArray = [NSArray new];
		self.title = @"Избранное";
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.tableView registerClass:[TicketsTableViewCell class] forCellReuseIdentifier:TicketsCellReuseIdentifier];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (isFavorite) {
		self.navigationController.navigationBar.prefersLargeTitles = YES;
		self.ticketsArray = [[CoreDataHelper sharedInstance] favorites];
		[self.tableView reloadData];
	}

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.ticketsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TicketsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketsCellReuseIdentifier forIndexPath:indexPath];
	if (isFavorite) {
		cell.favoriteTicket = [self.ticketsArray objectAtIndex:indexPath.row];
	} else {
		cell.ticket = [self.ticketsArray objectAtIndex:indexPath.row];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (isFavorite) return;

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с билетом" message:@"Что сделать с билетом?" preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *favoriteAction;
	if ([[CoreDataHelper sharedInstance] isFavorite:[self.ticketsArray objectAtIndex:indexPath.row]]) {
		favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
			[[CoreDataHelper sharedInstance] removeFromFavorite:[self.ticketsArray objectAtIndex:indexPath.row]];
		}];
	} else {
		favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[[CoreDataHelper sharedInstance] addToFavorite:[self.ticketsArray objectAtIndex:indexPath.row]];
		}];
	}
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:favoriteAction];
	[alertController addAction:cancelAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

@end

//
//  TicketsTableViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 24.07.2021.
//

#import "TicketsTableViewController.h"
#import "TicketsTableViewCell.h"

#define TicketsCellReuseIdentifier @"TicketsCellReuseIdentifier"

@interface TicketsTableViewController ()

@property(nonatomic, strong) NSArray *ticketsArray;

@end

@implementation TicketsTableViewController

- (instancetype)initWithTickets:(NSArray *)tickets {
	self = [super init];
	if (self) {
		self.ticketsArray = tickets;
		self.title = @"Tickets";
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.tableView registerClass:[TicketsTableViewCell class] forCellReuseIdentifier:TicketsCellReuseIdentifier];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ticketsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketsCellReuseIdentifier forIndexPath:indexPath];
	cell.ticket = [self.ticketsArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 140.0;
}

@end

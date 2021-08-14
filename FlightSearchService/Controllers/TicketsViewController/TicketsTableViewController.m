//
//  TicketsTableViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 24.07.2021.
//

#import "TicketsTableViewController.h"
#import "TicketsTableViewCell.h"
#import "CoreDataHelper.h"
#import "Ticket.h"
#import "NotificationCenter.h"
#import <UIKit/UIKit.h>

#define TicketsCellReuseIdentifier @"TicketsCellReuseIdentifier"

@interface TicketsTableViewController ()

	@property (nonatomic, strong) NSArray *ticketsArray;
	@property (nonatomic, strong) UISegmentedControl *segmentControl;
	@property (nonatomic, strong) UIDatePicker *datePicker;
	@property (nonatomic, strong) UITextField *dateTextField;

@end

@implementation TicketsTableViewController {
	BOOL isFavorite;
	TicketsTableViewCell *notificationCell;
}


- (instancetype)initWithTickets:(NSArray *)tickets {
	self = [super init];
	if (self) {
		self.ticketsArray = tickets;
		self.navigationController.navigationBar.prefersLargeTitles = YES;
		self.title = NSLocalizedString(@"ticketsTitle", "");
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.tableView registerClass:[TicketsTableViewCell class] forCellReuseIdentifier:TicketsCellReuseIdentifier];

		self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
		self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
		self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
		self.datePicker.minimumDate = [NSDate date];

		self.dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
		self.dateTextField.hidden = YES;
		self.dateTextField.inputView = self.datePicker;

		UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
		[keyboardToolbar sizeToFit];
		UIBarButtonItem *flexBarBatton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *doneBarBatton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(doneButtonDidTap:)];
		keyboardToolbar.items = @[flexBarBatton, doneBarBatton];

		self.dateTextField.inputAccessoryView = keyboardToolbar;
		[self.view addSubview:self.dateTextField];
	}
	return self;
}

- (instancetype)initFavoriteTicketsController {
	self = [super init];
	if (self) {
		isFavorite = YES;
		self.ticketsArray = [NSArray new];
		self.title = NSLocalizedString(@"favoriteTicketsTitle", "");
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.tableView registerClass:[TicketsTableViewCell class] forCellReuseIdentifier:TicketsCellReuseIdentifier];
		_segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Searched", @"From map"]];
		[_segmentControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
		_segmentControl.tintColor = UIColor.blackColor;
		self.navigationItem.titleView = _segmentControl;
		_segmentControl.selectedSegmentIndex = 0;
		[self changeSource];
	}
	return self;
}

- (void)changeSource {
	switch (_segmentControl.selectedSegmentIndex) {
		case 0:
			_ticketsArray = [[CoreDataHelper sharedInstance] favorites];
			[self.tableView reloadData];
			break;
		case 1:
			_ticketsArray = [[CoreDataHelper sharedInstance] favoritesMapWithPrices];
			[self.tableView reloadData];
			break;
		default:
			break;
	}
	[self.tableView reloadData];
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

- (void)doneButtonDidTap:(UIBarButtonItem *)sender {
	if (_datePicker.date && notificationCell) {
		NSString *message = [NSString stringWithFormat:@"%@ - %@ за %@ руб.", notificationCell.ticket.from, notificationCell.ticket.to, notificationCell.ticket.price];
		NSURL *imageURL;

		Notification notification = NotificationMake(NSLocalizedString(@"ticketReminder", ""), message, _datePicker.date, imageURL);
		[[NotificationCenter sharedInstance] sendNotification:notification];

		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"success", "") message:[NSString stringWithFormat:@"%@ - %@", NSLocalizedString(@"ticketReminder", ""), _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"close", "") style:UIAlertActionStyleCancel handler:nil];

		[alertController addAction:cancelAction];
		[self presentViewController:alertController animated:YES completion:nil];
	}
	_datePicker.date = [NSDate date];
	notificationCell = nil;
	[self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _ticketsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TicketsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketsCellReuseIdentifier forIndexPath:indexPath];
	if (isFavorite) {
		switch (_segmentControl.selectedSegmentIndex) {
			case 0:
				cell.favoriteTicket = [_ticketsArray objectAtIndex:indexPath.row];
				break;
			case 1:
				cell.favoriteMapPriceTicket = [_ticketsArray objectAtIndex:indexPath.row];
				break;
			default:
				break;
		}
	} else {
		cell.ticket = [_ticketsArray objectAtIndex:indexPath.row];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (isFavorite) return;

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"actionsWithTicket", "") message:NSLocalizedString(@"actionsWithTicketDescribe", "") preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *favoriteAction;
	if ([[CoreDataHelper sharedInstance] isFavorite: [self.ticketsArray objectAtIndex:indexPath.row]]) {
		favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"femoveFromFavorite", "") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
			[[CoreDataHelper sharedInstance] removeFromFavorite:[self.ticketsArray objectAtIndex:indexPath.row]];
		}];
	} else {
		favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"addToFavorite", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[[CoreDataHelper sharedInstance] addToFavorite:[self.ticketsArray objectAtIndex:indexPath.row]];
		}];
	}

	UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"remindMe", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[[CoreDataHelper sharedInstance] addToFavorite:[self.ticketsArray objectAtIndex:indexPath.row]];
		self->notificationCell = [tableView cellForRowAtIndexPath:indexPath];
		[self->_dateTextField becomeFirstResponder];
	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"close", "") style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:favoriteAction];
	[alertController addAction:notificationAction];
	[alertController addAction:cancelAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.title isEqual:@"Tickets" "Билеты"]) {
		return NO;
	} else {
		return YES;
	}
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		switch (_segmentControl.selectedSegmentIndex) {
			case 0:
				[[CoreDataHelper sharedInstance] removeFromFavorite:[self->_ticketsArray objectAtIndex:indexPath.row]];
				self.ticketsArray = [[CoreDataHelper sharedInstance] favorites];
				[tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
				[self.tableView reloadData];
				break;
			case 1:
				[[CoreDataHelper sharedInstance] removeFromFavoriteMapWithPriceFromTable:[self->_ticketsArray objectAtIndex:indexPath.row]];
				_ticketsArray = [[CoreDataHelper sharedInstance] favoritesMapWithPrices];
				[tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
				[self.tableView reloadData];
				break;
			default:
				break;
		}
		[self.tableView reloadData];
	}
	[self.tableView reloadData];
}

@end

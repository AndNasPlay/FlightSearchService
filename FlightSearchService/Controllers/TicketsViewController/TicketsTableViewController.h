//
//  TicketsTableViewController.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 24.07.2021.
//

#import <UIKit/UIKit.h>


@interface TicketsTableViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;

@end

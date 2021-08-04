//
//  TicketsTableViewController.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 24.07.2021.
//

#import <UIKit/UIKit.h>

typedef enum FavoriteTicketType {
	FavoriteTicketFromMap,
	FavoriteTicketFromSearch
} FavoriteTicketType;

@interface TicketsTableViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;
- (instancetype)initFavoriteTicketsControllerFromMap;

@end

//
//  TicketsTableViewCell.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 22.07.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "ApiManager.h"
#import "Ticket.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "FavoriteMapPriceTicket+CoreDataClass.h"


@interface TicketsTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;
@property (nonatomic, strong) FavoriteMapPriceTicket *favoriteMapPriceTicket;

@end


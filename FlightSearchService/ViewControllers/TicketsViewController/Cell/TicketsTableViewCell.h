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


@interface TicketsTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *tiket;

@end


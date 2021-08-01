//
//  MainViewController.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import <UIKit/UIKit.h>
#import "PlaceViewController.h"

@interface MainViewController : UIViewController <PlaceViewControllerDelegate>

- (BOOL)dateComparision:(NSDate*)date1 andDate2:(NSDate*)date2;


@end


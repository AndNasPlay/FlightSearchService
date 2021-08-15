//
//  PlaceViewController.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

typedef enum PlaceType {
	PlaceTypeArrival,
	PlaceTypeDeparture
} PlaceType;

@protocol PlaceViewControllerDelegate <NSObject>

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;

@end

@interface PlaceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

	@property (nonatomic, strong) id<PlaceViewControllerDelegate>delegate;
- (instancetype)initWithType:(PlaceType)type;

@end


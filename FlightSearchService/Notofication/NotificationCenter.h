//
//  NotificationCenter.h
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 10.08.2021.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>


typedef struct Notification {
	__unsafe_unretained NSString* _Nullable title;
	__unsafe_unretained NSString* _Nullable body;
	__unsafe_unretained NSDate* _Nullable date;
	__unsafe_unretained NSURL* _Nullable imageURL;
} Notification;

@interface NotificationCenter : NSObject

+ (instancetype _Nullable)sharedInstance;
- (void)registerService;
- (void)sendNotification:(Notification)notification;

Notification NotificationMake(NSString* _Nullable title, NSString* _Nullable body, NSDate* _Nullable date, NSURL* _Nullable imageURL);

@end


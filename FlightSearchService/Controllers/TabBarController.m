//
//  TabBarController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 26.07.2021.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "TicketsTableViewController.h"
#import <UIKit/UIKit.h>

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		self.viewControllers = [self createViewControllers];
		self.tabBar.tintColor = UIColor.blackColor;
		self.tabBar.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.2];
	}
	return self;
}

- (NSArray<UIViewController *> *)createViewControllers {
	NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray new];

	MainViewController *mainViewController = [[MainViewController alloc] init];
	mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:[UIImage systemImageNamed:@"magnifyingglass"] selectedImage:[UIImage imageNamed:@"search_selected"]];
	UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	[viewControllers addObject:mainNavigationController];

	MapViewController *mapViewController = [[MapViewController alloc] init];
	mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map Prices" image:[UIImage systemImageNamed:@"map"] selectedImage:[UIImage imageNamed:@"map_selected"]];
	UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
	[viewControllers addObject:mapNavigationController];

	TicketsTableViewController *ticketsViewController = [[TicketsTableViewController alloc] initFavoriteTicketsController];
	ticketsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorite Tickets" image:[UIImage systemImageNamed:@"star"] selectedImage:[UIImage imageNamed:@"star_fill"]];
	UINavigationController *ticketsNavigationController = [[UINavigationController alloc] initWithRootViewController:ticketsViewController];
	[viewControllers addObject:ticketsNavigationController];

	return viewControllers;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

@end

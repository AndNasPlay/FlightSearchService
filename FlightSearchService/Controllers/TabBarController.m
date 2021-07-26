//
//  TabBarController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 26.07.2021.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		self.viewControllers = [self createViewControllers];
		self.tabBar.tintColor = [UIColor blackColor];
	}
	return self;
}

- (NSArray<UIViewController *> *)createViewControllers {
	NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray new];

	MainViewController *mainViewController = [[MainViewController alloc] init];
	mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:[UIImage systemImageNamed:@"search"] selectedImage:[UIImage imageNamed:@"search_selected"]];
	UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	[viewControllers addObject:mainNavigationController];

	MapViewController *mapViewController = [[MapViewController alloc] init];
	mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"map"] selectedImage:[UIImage imageNamed:@"map_selected"]];
	UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
	[viewControllers addObject:mapNavigationController];

	return viewControllers;
}

- (void)viewDidLoad {
	[super viewDidLoad];

}

@end

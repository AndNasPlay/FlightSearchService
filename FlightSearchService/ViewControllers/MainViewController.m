//
//  MainViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 21.07.2021.
//

#import "MainViewController.h"
#import "TicketsViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor redColor];
	[[DataManager sharedInstance] loadData];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)loadDataComplete {
	self.view.backgroundColor = [UIColor greenColor];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

//- (void)viewDidAppear:(BOOL)animated {
//	[super viewDidAppear:animated];
//	[self openAnotherViewController];
//}

- (void)openAnotherViewController {
	TicketsViewController *newViewController = [[TicketsViewController alloc] init];
	[self.navigationController showViewController:newViewController sender:self];
}


@end

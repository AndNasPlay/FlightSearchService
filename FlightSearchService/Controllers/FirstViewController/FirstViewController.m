//
//  FirstViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 09.08.2021.
//

#import "FirstViewController.h"
#import "ContentViewController.h"

#define CONTENT_COUNT 3

@interface FirstViewController ()

	@property (nonatomic, strong) UIButton *nextButton;
	@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation FirstViewController {
	struct firstContentData {
		__unsafe_unretained NSString *title;
		__unsafe_unretained NSString *contentText;
		__unsafe_unretained NSString *imageName;
		__unsafe_unretained NSString *bgImageName;
	} contentData[CONTENT_COUNT];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.backgroundColor = UIColor.whiteColor;
	[self createContentDataArray];

	self.dataSource = self;
	self.delegate = self;
	ContentViewController *startViewController = [self viewControllerAtIndex:0];
	[self setViewControllers:@[startViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

	self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 150.0, self.view.bounds.size.width, 50.0)];
	self.pageControl.numberOfPages = CONTENT_COUNT;
	self.pageControl.currentPage = 0;
	self.pageControl.pageIndicatorTintColor = UIColor.darkGrayColor;
	self.pageControl.currentPageIndicatorTintColor = UIColor.blackColor;
	[self.view addSubview:self.pageControl];

	self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.nextButton.frame = CGRectMake(self.view.bounds.size.width - 100.0, self.view.bounds.size.height - 150.0, 100.0, 50.0);
	[self.nextButton setTintColor:UIColor.blackColor];
	[self.nextButton addTarget:self action:@selector(nextButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	[self updateButtonWithIndex:0];
	[self.view addSubview:self.nextButton];

}

- (void)createContentDataArray {
	NSArray *titles = [NSArray arrayWithObjects:@"О приложении", @"Карта цен", @"Избранное", nil];
	NSArray *contents = [NSArray arrayWithObjects:@"Приложение для поиска авиабилетов", @"Просматривайте карту цен", @"Сохраняйте выбранные билеты в избранное", nil];
	for (int i = 0; i < 3; i++) {
		contentData[i].title = [titles objectAtIndex:i];
		contentData[i].contentText = [contents objectAtIndex:i];
		contentData[i].imageName = [NSString stringWithFormat:@"first_%d", i + 1];
		contentData[i].bgImageName = [NSString stringWithFormat:@"bgImage_%d", i + 1];
	}
}

- (ContentViewController *)viewControllerAtIndex:(int)index {
	if (index < 0 || index >= CONTENT_COUNT) {
		return nil;
	}
	ContentViewController *contentViewController = [[ContentViewController alloc] init];
	contentViewController.title = contentData[index].title;
	contentViewController.contentText = contentData[index].contentText;
	contentViewController.image =  [UIImage imageNamed: contentData[index].imageName];
	UIImage *img = [UIImage imageNamed:contentData[index].bgImageName];
	contentViewController.view.layer.contents = CFBridgingRelease(img.CGImage);
	contentViewController.index = index;
	return contentViewController;
}

- (void)updateButtonWithIndex:(int)index {
	switch (index) {
		case 0:
		case 1:
			[_nextButton setTitle:@"ДАЛЕЕ" forState:UIControlStateNormal];
			_nextButton.tag = 0;
			break;
		case 2:
			[_nextButton setTitle:@"ГОТОВО" forState:UIControlStateNormal];
			_nextButton.tag = 1;
			break;
		default:
			break;
	}
}

- (void)nextButtonDidTap:(UIButton *)sender {
	int index = ((ContentViewController *)[self.viewControllers firstObject]).index;
	if (sender.tag) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_start"];
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		__weak typeof(self) weakSelf = self;
		[self setViewControllers:@[[self viewControllerAtIndex:index+1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
			weakSelf.pageControl.currentPage = index+1;
			[weakSelf updateButtonWithIndex:index+1];
		}];
	}
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	int index = ((ContentViewController *)viewController).index;
	index--;
	return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	int index = ((ContentViewController *)viewController).index;
	index++;
	return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
	if (completed) {
		int index = ((ContentViewController *)[pageViewController.viewControllers firstObject]).index;
		_pageControl.currentPage = index;
		[self updateButtonWithIndex:index];
	}
}

@end

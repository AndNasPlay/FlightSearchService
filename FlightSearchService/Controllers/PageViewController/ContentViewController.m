//
//  ContentViewController.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 09.08.2021.
//

#import "ContentViewController.h"

@interface ContentViewController ()

	@property (nonatomic, strong) UIImageView *imageView;
	@property (nonatomic, strong) UILabel *titleLable;
	@property (nonatomic, strong) UILabel *contantLable;


@end

@implementation ContentViewController

- (instancetype)init {

	self = [super init];
	if (self) {
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100.0, [UIScreen mainScreen].bounds.size.height / 2 - 100.0, 200.0, 200.0)];
		self.imageView.contentMode = UIViewContentModeScaleAspectFill;
		self.imageView.layer.cornerRadius = 8.0;
		self.imageView.clipsToBounds = YES;
		[self.view addSubview:self.imageView];

		self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100.0, CGRectGetMinY(self.imageView.frame) - 61.0, 200.0, 21.0)];
		self.titleLable.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightHeavy];
		self.titleLable.numberOfLines = 0;
		self.titleLable.textAlignment = NSTextAlignmentCenter;
		[self.view addSubview:self.titleLable];

		self.contantLable = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100.0, CGRectGetMaxY(self.imageView.frame) + 20.0, 200.0, 21.0)];
		self.contantLable.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
		self.contantLable.numberOfLines = 0;
		self.contantLable.textAlignment = NSTextAlignmentCenter;
		[self.view addSubview:self.contantLable];
	}
	return self;
}

- (void)setTitle:(NSString *)title {
	self.titleLable.text = title;
	float height = heightForText(title, self.titleLable.font, 200.0);
	self.titleLable.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100.0, CGRectGetMinY(self.imageView.frame) - 40.0 - height, 200.0, height);
}

- (void)setImage:(UIImage *)image {
	self.image = image;
	self.imageView.image = image;
	self.imageView.backgroundColor = UIColor.purpleColor;
}

float heightForText(NSString *text, UIFont *font, float width) {
	if (text && [text isKindOfClass:[NSString class]]) {
		CGSize size = CGSizeMake(width, FLT_MAX);
		CGRect needLable = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
		return ceilf(needLable.size.height);
	}
	return 0.0;
}


@end

//
//  TicketsTableViewCell.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 22.07.2021.
//

#import "TicketsTableViewCell.h"

@implementation TicketsTableViewCell


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.leftLable = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width / 2, 44.0)];
		self.leftLable.textAlignment = NSTextAlignmentCenter;
		[self.contentView addSubview:self.leftLable];

		self.rightLable = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 0.0, [UIScreen mainScreen].bounds.size.width / 2, 44.0)];
		self.rightLable.textAlignment = NSTextAlignmentCenter;
		[self.contentView addSubview:self.rightLable];
	}
	return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

//
//  TicketsTableViewCell.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 22.07.2021.
//

#import "TicketsTableViewCell.h"
#import "Ticket.h"

@interface TicketsTableViewCell()

@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) UILabel *priceLable;
@property (nonatomic, strong) UILabel *placesLable;
@property (nonatomic, strong) UILabel *dateLable;

@end

@implementation TicketsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
		self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
		self.contentView.layer.shadowRadius = 10.0;
		self.contentView.layer.shadowOpacity = 1.0;
		self.contentView.layer.cornerRadius = 6.0;
		self.contentView.backgroundColor = [UIColor whiteColor];

		self.priceLable = [[UILabel alloc] initWithFrame:self.bounds];
		self.priceLable.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
		[self.contentView addSubview:self.priceLable];

		self.airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
		self.airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:self.airlineLogoView];

		self.placesLable = [[UILabel alloc] initWithFrame:self.bounds];
		self.placesLable.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
		self.placesLable.textColor = [UIColor grayColor];
		[self.contentView addSubview:self.placesLable];

		self.dateLable = [[UILabel alloc] initWithFrame:self.bounds];
		self.dateLable.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
		[self.contentView addSubview:self.dateLable];

	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	self.contentView.frame = CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
	self.priceLable.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 100.0, 40.0);
	self.airlineLogoView.frame = CGRectMake(CGRectGetMaxX(self.priceLable.frame) + 10.0, 10.0, 80.0, 80.0);
	self.placesLable.frame = CGRectMake(10.0, CGRectGetMaxY(self.priceLable.frame) + 16.0, 100.0, 20.0);
	self.dateLable.frame = CGRectMake(10.0, CGRectGetMaxY(self.placesLable.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (void)setTicket:(Ticket *)ticket {
	_ticket = ticket;

	self.priceLable.text = [NSString stringWithFormat:@"%@ руб.", ticket.price];
	self.placesLable.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
	self.dateLable.text = [dateFormatter stringFromDate:ticket.departure];
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:ticket.airline]];
//	[self.airlineLogoView setImage:[UIImage imageWithData:data]];
//	self.airlineLogoView.image = [UIImage imageWithData:data];
	self.airlineLogoView.image = [UIImage imageNamed:@"Ducati"];
}

@end

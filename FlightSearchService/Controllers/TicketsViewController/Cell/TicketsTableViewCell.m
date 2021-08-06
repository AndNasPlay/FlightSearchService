//
//  TicketsTableViewCell.m
//  FlightSearchService
//
//  Created by Андрей Щекатунов on 22.07.2021.
//

#import "TicketsTableViewCell.h"
#import "Ticket.h"
#import <SDWebImage/SDWebImage.h>

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
		self.contentView.layer.shadowColor = [[UIColor.blackColor colorWithAlphaComponent:0.2] CGColor];
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
		self.placesLable.textColor = UIColor.grayColor;
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
	self.airlineLogoView.frame = CGRectMake(self.contentView.frame.size.width - 140.0, (self.contentView.frame.size.height / 2) - 60.0, 120.0, 120.0);
	self.placesLable.frame = CGRectMake(10.0, CGRectGetMaxY(self.priceLable.frame) + 16.0, 150.0, 20.0);
	self.dateLable.frame = CGRectMake(10.0, CGRectGetMaxY(self.placesLable.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (void)setTicket:(Ticket *)ticket {
	_ticket = ticket;

	self.priceLable.text = [NSString stringWithFormat:@"%@ руб.", ticket.price];
	self.placesLable.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
	NSLog(@"Сохраняем в массив тикет - %@, %@, %@, %@, %@, %@, %@, %@", ticket.airline, ticket.departure, ticket.expires, ticket.flightNumber, ticket.from, ticket.price, ticket.returnDate, ticket.to);
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"dd MMMM yyyy";
	self.dateLable.text = [dateFormatter stringFromDate:ticket.departure];
	[self.airlineLogoView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://pics.avs.io/120/120/%@.png", ticket.airline.uppercaseString]] placeholderImage:[UIImage imageNamed:@"Ducati.png"]];
}

- (void)setFavoriteTicket:(FavoriteTicket *)favoriteTicket {
	_favoriteTicket = favoriteTicket;

	self.priceLable.text = [NSString stringWithFormat:@"%lld руб.", favoriteTicket.price];
	self.placesLable.text = [NSString stringWithFormat:@"%@ - %@", favoriteTicket.from, favoriteTicket.to];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
	self.dateLable.text = [dateFormatter stringFromDate:favoriteTicket.departure];
	[self.airlineLogoView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://pics.avs.io/120/120/%@.png", favoriteTicket.airline.uppercaseString]] placeholderImage:[UIImage imageNamed:@"Ducati.png"]];
}

- (void)setFavoriteMapPriceTicket:(FavoriteMapPriceTicket *)favoriteMapPrice {
	_favoriteMapPriceTicket = favoriteMapPrice;

	_priceLable.text = [NSString stringWithFormat:@"%lld руб.",_favoriteMapPriceTicket.price];
	_placesLable.text = [NSString stringWithFormat:@"%@ - %@",_favoriteMapPriceTicket.from, _favoriteMapPriceTicket.to];

	[self.airlineLogoView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://pics.avs.io/120/120/%@.png", _favoriteMapPriceTicket.airline]] placeholderImage:[UIImage imageNamed:@"Ducati.png"]];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
	_dateLable.text = [dateFormatter stringFromDate:_favoriteMapPriceTicket.departure];
}

@end

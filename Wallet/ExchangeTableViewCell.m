//
//  ExchangeTableViewCell.m
//  Wallet
//
//  Created by cuiyuxuan on 2021/6/9.
//

#import "ExchangeTableViewCell.h"

@interface ExchangeTableViewCell()

@property (nonatomic,  strong) UIImageView *iconView;
@property (nonatomic,  strong) UILabel *label;

@end

@implementation ExchangeTableViewCell

- (void)didInitializeWithStyle:(UITableViewCellStyle)style {
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
//    self.iconView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.iconView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 150, 40)];
    self.label.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.label];
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    
    self.iconView.image = icon;
}

- (void)setExchangeTitle:(NSString *)exchangeTitle {
    _exchangeTitle = exchangeTitle;
    
    self.label.text = exchangeTitle;
}

@end

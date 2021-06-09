//
//  ExchangeTableViewCell.h
//  Wallet
//
//  Created by cuiyuxuan on 2021/6/9.
//

#import "QMUITableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeTableViewCell : QMUITableViewCell

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *exchangeTitle;

@end

NS_ASSUME_NONNULL_END

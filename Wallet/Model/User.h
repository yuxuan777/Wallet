//
//  User.h
//  Wallet
//
//  Created by cuiyuxuan on 2021/6/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign)CGFloat drmb;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *wallet;


+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END

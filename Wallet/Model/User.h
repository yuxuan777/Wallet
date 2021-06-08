//
//  User.h
//  Wallet
//
//  Created by cuiyuxuan on 2021/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *token;


+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END

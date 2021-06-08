//
//  User.m
//  Wallet
//
//  Created by cuiyuxuan on 2021/6/8.
//

#import "User.h"

@interface User()

@end

@implementation User

static id _instance;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end

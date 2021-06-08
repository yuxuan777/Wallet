//
//  UIViewController+CurrentVC.m
//  numeral-ios
//
//  Created by cuiyuxuan on 2019/12/16.
//  Copyright © 2019 Ping An Bank. All rights reserved.
//

#import "UIViewController+CurrentVC.h"

@implementation UIViewController (CurrentVC)

+ (UIViewController *)currentVC {
    if (![[UIApplication sharedApplication].windows.lastObject isKindOfClass:[UIWindow class]]) {
        NSAssert(0, @"未获取到当前控制器");
        return nil;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentVCFrom:rootViewController];
}

#pragma mark - Private

//递归
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nc = ((UITabBarController *)vc).selectedViewController;
        return [self getCurrentVCFrom:nc];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self getCurrentVCFrom:((UINavigationController *)vc).presentedViewController];
        }
        return [self getCurrentVCFrom:((UINavigationController *)vc).topViewController];
    }
    else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentedViewController) {
            return [self getCurrentVCFrom:vc.presentedViewController];
        }
        else {
            return vc;
        }
    }
    else {
        NSAssert(0, @"未获取到当前控制器");
        return nil;
    }
}

@end

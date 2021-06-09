//
//  AppDelegate.m
//  Wallet
//
//  Created by cuiyuxuan on 2021/6/7.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginVC.h"
#import <QMUIKit/QMUIKit.h>
#import "WalletViewController.h"
#import "TransferViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    

//    ViewController *vc = [[ViewController alloc] init];
    
    TransferViewController *vc = [[TransferViewController alloc] init];
    vc.availableDRMB = @"111";
    vc.address = @"xxxxxadwadaw";
    
    self.window.rootViewController = vc;

    [self.window makeKeyAndVisible];
    
    return YES;
}



@end

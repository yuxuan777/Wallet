//
//  AppDelegate.m
//  Wallet
//
//  Created by cuiyuxuan on 2021/6/7.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "WalletViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    WalletViewController *vc = [[WalletViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController =   vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}



@end

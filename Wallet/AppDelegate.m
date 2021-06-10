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
#import "ExchangeRateVC.h"
#import "ExchangeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginVC *vc = [[LoginVC alloc] init];
    QMUINavigationController *nav = [[QMUINavigationController alloc] initWithRootViewController:vc];
    
    
    self.window.rootViewController = nav;
    
//    //跳转
//    QMUITabBarViewController *tabBarViewController = [[QMUITabBarViewController alloc] init];
//
//    //首页
//    WalletViewController *walletVC = [[WalletViewController alloc] init];
//    walletVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Wallet" image:UIImageMake(@"wallet") tag:0];
//    walletVC.tabBarItem.selectedImage = UIImageMake(@"wallet");
//    QMUINavigationController *nav1 = [[QMUINavigationController alloc] initWithRootViewController:walletVC];
//
//    //汇率
//    ExchangeRateVC *exchangeVC = [[ExchangeRateVC alloc] initWithStyle:UITableViewStyleGrouped];
//    exchangeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Rate" image:UIImageMake(@"wallet") tag:1];
//    exchangeVC.tabBarItem.selectedImage = UIImageMake(@"wallet");
//    QMUINavigationController *nav2 = [[QMUINavigationController alloc] initWithRootViewController:exchangeVC];
//
//    tabBarViewController.viewControllers = @[nav1, nav2];
//    self.window.rootViewController = tabBarViewController;

    [self.window makeKeyAndVisible];
    
    return YES;
}



@end

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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    

//    ViewController *vc = [[ViewController alloc] init];
    
    LoginVC *vc = [[LoginVC alloc] init];
    QMUINavigationController *nav = [[QMUINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nav;

    [self.window makeKeyAndVisible];
    
    return YES;
}



@end

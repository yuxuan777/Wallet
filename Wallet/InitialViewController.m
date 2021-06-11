//
//  InitialViewController.m
//  Wallet
//
//  Created by cuiyuxuan on 2021/6/11.
//

#import "InitialViewController.h"
#import "LoginVC.h"
#import <QMUIKit/QMUIKit.h>
#import "AppDelegate.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
//    CGRect rect = [UIScreen mainScreen].bounds;
//    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    vc.view.frame = rect;
//    [vc.view.layer renderInContext:context];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    UIView *launchView = vc.view;
    
//    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
//    launchView.frame = [UIApplication sharedApplication].keyWindow.frame;
//    [launchView addSubview:self.dynamicLabel];
    [self.view addSubview:launchView];
    
    
    [UIView animateWithDuration:1.2f delay:1.5f options:UIViewAnimationOptionCurveLinear animations:^{

       launchView.alpha = 0.0f;
       launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);

    } completion:^(BOOL finished) {
//       [launchView removeFromSuperview];
        
//
//        mainWindow.rootViewController = nav;
//        [mainWindow makeKeyAndVisible];
        [self showMain];
    }];
    
}

- (void)showMain {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    LoginVC *vc = [[LoginVC alloc] init];
    QMUINavigationController *nav = [[QMUINavigationController alloc] initWithRootViewController:vc];
    
    delegate.window.rootViewController = nav;
}


@end

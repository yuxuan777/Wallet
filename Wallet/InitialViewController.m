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
    
    CGFloat imageWH = 160;
    CGFloat imageX = (SCREEN_WIDTH - imageWH) * 0.5;
    CGFloat imageY = SCREEN_HEIGHT - imageWH - 140;
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageWH, imageWH)];
    iconView.image = [UIImage imageNamed:@"icon-1024-1"];
    iconView.alpha = 0.0f;
    [self.view addSubview:iconView];
    
    [UIView animateWithDuration:0.8f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        iconView.alpha = 1.0f;

        
    } completion:^(BOOL finished) {

        [UIView animateWithDuration:0.6f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
            
            launchView.alpha = 0.0f;
//            launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
            
            CGFloat imageWH1 = 160;
            CGFloat imageX1 = (SCREEN_WIDTH - imageWH) * 0.5;
            CGFloat imageY1 = 120;
            iconView.frame = CGRectMake(imageX1, imageY1, imageWH1, imageWH1);
            
        } completion:^(BOOL finished) {
           [launchView removeFromSuperview];
            [iconView removeFromSuperview];
        
            [self showMain];
        }];
    }];

    
}

- (void)showMain {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    LoginVC *vc = [[LoginVC alloc] init];
    QMUINavigationController *nav = [[QMUINavigationController alloc] initWithRootViewController:vc];
    
    delegate.window.rootViewController = nav;
}


@end

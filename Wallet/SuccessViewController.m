//
//  SuccessViewController.m
//  Wallet
//
//  Created by HuangBin Ye on 2021/6/9.
//

#import "SuccessViewController.h"
#import "QMUIKit.h"
@interface SuccessViewController ()

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"suc"]];
    [self.view addSubview:imgView];
    
    QMUILabel *label = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(16) textColor:[UIColor blackColor]];
    label.text = self.info;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    imgView.frame = CGRectMake(SCREEN_WIDTH * 0.3, SCREEN_WIDTH * 0.15, SCREEN_WIDTH * 0.4, SCREEN_WIDTH * 0.4);
    label.frame = CGRectMake(20, SCREEN_WIDTH * 0.6, SCREEN_WIDTH -40,  150);
    
    QMUIFillButton *sureBtn =  [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorBlue];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 60, SCREEN_WIDTH * 0.6 + 160, 120, 40);
    sureBtn.cornerRadius = 2;
    [sureBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    // Do any additional setup after loading the view.
}

- (UIColor *)titleViewTintColor {
    return [UIColor blackColor];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

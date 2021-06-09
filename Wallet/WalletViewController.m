//
//  WalletViewController.m
//  Wallet
//
//  Created by HuangBin Ye on 2021/6/8.
//

#import "WalletViewController.h"
#import "SGQRCode.h"
@interface WalletViewController ()

@property (nonatomic, strong) QMUILabel *addressLabel;
@property (nonatomic, strong) QMUIButton *addressButton;
@property (nonatomic, strong) QMUILabel *totalLabel;
@property (nonatomic, strong) QMUIButton *rmbButton;
@property (nonatomic, strong) QMUIButton *drmbButton;
@property (nonatomic, strong) QMUIButton *usdButton;
@property (nonatomic, strong) QMUIButton *eurButton;
@property (nonatomic, strong) QMUIButton *smButton;
// 币种
@property (nonatomic, strong) QMUILabel *drmbLabel;
@property (nonatomic, strong) QMUILabel *rmbLabel;
@property (nonatomic, strong) QMUILabel *usdLabel;
@property (nonatomic, strong) QMUILabel *eurLabel;


@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10 , 60, SCREEN_WIDTH - 20, SCREEN_HEIGHT * 0.15)];
    bgView.backgroundColor = [UIColor blueColor];
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    QMUILabel *label1 = [[QMUILabel alloc] init];
    _addressLabel = [[QMUILabel alloc] init];
    _addressButton = [[QMUIButton alloc] init];
    _totalLabel = [[QMUILabel alloc] init];
    QMUILabel *label2 = [[QMUILabel alloc] init];
    _smButton = [[QMUIButton alloc] init];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:18];
    label1.text = @"DRMB";
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = @"资产折合(RMB)：";
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.font = [UIFont systemFontOfSize:14];
    [_addressButton setImage:[UIImage imageNamed:@"ewm"] forState:UIControlStateNormal];
    [_smButton setImage:[UIImage imageNamed:@"sm"] forState:UIControlStateNormal];
    _totalLabel.textColor = [UIColor whiteColor];
    _totalLabel.font = [UIFont systemFontOfSize:24];
    
    
    
    
    label1.frame = CGRectMake(20, 10, 60, 18);
    _addressButton.frame = CGRectMake(80, 10, 20, 20);
    _smButton.frame = CGRectMake(bgView.qmui_width - 60, 20, 40, 40);
    _addressLabel.frame = CGRectMake(20, 40, 100, 18);
    label2.frame = CGRectMake(20, bgView.frame.size.height - 40, 120, 30);
    _totalLabel.textAlignment = NSTextAlignmentRight;
    _totalLabel.frame = CGRectMake(140, bgView.frame.size.height - 40, bgView.frame.size.width - 160, 30);
    
    _addressLabel.text = @"xsadsadasdas";
    _totalLabel.text =  @"saeaweawawe";
    [bgView addSubview:label1];
    [bgView addSubview:_addressLabel];
    [bgView addSubview:_addressButton];
    [bgView addSubview:label2];
    [bgView addSubview:_totalLabel];
    [bgView addSubview:_smButton];
    
    [_smButton addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
    [_addressButton addTarget:self action:@selector(qrClick) forControlEvents:UIControlEventTouchUpInside];
    
     
    
    
}



- (void)qrClick {
    [[SGQRCodeManager QRCodeManager]  scanWithController:self resultBlock:^(SGQRCodeManager *manager, NSString *result) {
        NSLog(@"result");
    }];
}

- (void)scanClick {
    
}


- (UIView *)createCoinUI: (QMUILabel *)label imgName: (NSString *)imgName labelName: (NSString *)labelName {
    UIView *contain = [[UIView alloc] init];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    QMUILabel *textLabel = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor]];
    label = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor]];
    [contain addSubview:label];
    return contain;
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

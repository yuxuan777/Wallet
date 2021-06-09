//
//  TransferViewController.m
//  Wallet
//
//  Created by HuangBin Ye on 2021/6/9.
//

#import "TransferViewController.h"
#import "SGQRCode.h"
#import "QMUIKit.h"
@interface TransferViewController ()
@property (nonatomic, strong) QMUITextField *addressTF;
@property (nonatomic, strong) QMUITextField *moneyTF;
@property (nonatomic, strong) QMUIFillButton *submitButton;
@property (nonatomic, strong) QMUIButton *smButton;
@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    CGFloat dynamicY = 40;
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"f6f6f6"];
    UILabel *label1 = [[UILabel alloc] qmui_initWithFont:UIFontMake(16) textColor:UIColorBlack];
    label1.text = @"收款地址";
    [self.view addSubview:label1];
    label1.frame = CGRectMake(10, dynamicY, 100, 30);
    dynamicY += 40;
    _addressTF = [[QMUITextField alloc] initWithFrame:CGRectMake(10, dynamicY, SCREEN_WIDTH - 70, 50)];
    
    _addressTF.font = UIFontMake(18);
    _addressTF.layer.cornerRadius = 4;
    _addressTF.placeholder = @"钱包地址";
    _addressTF.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _addressTF.backgroundColor = [UIColor whiteColor];
    _addressTF.placeholder = _address;
    [self.view addSubview:_addressTF];
    
    _smButton = [[QMUIButton alloc] init];
    [_smButton setImage:[UIImage imageNamed:@"sm2"] forState:UIControlStateNormal];
    [self.view addSubview:_smButton];
    _smButton.frame = CGRectMake(SCREEN_WIDTH - 50, dynamicY + 10, 30, 30);
    dynamicY += 70;
    
    UILabel *label2 = [[UILabel alloc] qmui_initWithFont:UIFontMake(16) textColor:UIColorBlack];
    label2.text = @"金额";
    label2.frame = CGRectMake(10, dynamicY, 50, 30);
    UILabel *label3 = [[UILabel alloc] qmui_initWithFont:UIFontMake(16) textColor:UIColorBlack];
    
    label3.text = [NSString stringWithFormat:@"当前可用DRMB：%@", self.availableDRMB];
    label3.frame = CGRectMake(SCREEN_WIDTH - 240, dynamicY, 180, 30);
    label3.textAlignment = NSTextAlignmentRight;
    QMUIButton *exchangeBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, dynamicY, 50, 30)];
    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    exchangeBtn.titleLabel.font = UIFontMake(16);
    [exchangeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:exchangeBtn];
    [self.view addSubview:label3];
    dynamicY += 40;
    [self.view addSubview:label2];
    _moneyTF = [[QMUITextField alloc] initWithFrame:CGRectMake(10, dynamicY, SCREEN_WIDTH - 20, 100)];
    dynamicY += 100;
    _moneyTF.font = UIFontMake(36);
    _moneyTF.layer.cornerRadius = 4;
    _moneyTF.placeholder = @"0";
    _moneyTF.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _moneyTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_moneyTF];
    
    QMUILabel *label4 = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(16) textColor:UIColorBlack];
    label4.text = @"交易手续费：0.12%";
    label4.frame = CGRectMake(0, dynamicY + 50, SCREEN_WIDTH, 30);
    label4.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label4];
//    _addressTF = [QMUITextField alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)

    _submitButton = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorBlue frame:CGRectMake(30, SCREEN_HEIGHT - 70, SCREEN_WIDTH-60, 50)];
    [_submitButton setTitle:@"转账" forState:UIControlStateNormal];
    [self.view addSubview:_submitButton];
    
    [_smButton addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [exchangeBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];

}

- (void)scan {
    [[SGQRCodeManager QRCodeManager]  scanWithController:self resultBlock:^(SGQRCodeManager *manager, NSString *result) {
        NSLog(@"result");
    }];
}

- (void)submit {
    
}

- (void)exchange {
    
}

@end

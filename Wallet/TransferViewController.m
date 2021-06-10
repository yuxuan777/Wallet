//
//  TransferViewController.m
//  Wallet
//
//  Created by HuangBin Ye on 2021/6/9.
//

#import "TransferViewController.h"
#import "SGQRCode.h"
#import "SuccessViewController.h"
#import "User.h"
#import <AFNetworking/AFNetworking.h>
#import "ZFScanViewController.h"
#import "ExchangeViewController.h"
@interface TransferViewController ()<UITextFieldDelegate,QMUITextFieldDelegate>
@property (nonatomic, strong) QMUITextField *addressTF;
@property (nonatomic, strong) QMUITextField *moneyTF;
@property (nonatomic, strong) QMUITextField *remarkTF;
@property (nonatomic, strong) QMUIFillButton *submitButton;
@property (nonatomic, strong) QMUIButton *smButton;
@property (nonatomic, strong) QMUILabel *drmbLabel;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转账";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
    
    if (self.toAddress) {
        _addressTF.text = self.toAddress;
    }
    self.moneyTF.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self getData];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [NSString stringWithFormat:@"%.2f", textField.text.floatValue];
}

- (UIColor *)titleViewTintColor {
    return [UIColor blackColor];
}

- (UIColor *)navigationBarTintColor {
    return [UIColor blackColor];
}


- (void)setupUI {
    CGFloat dynamicY = 10;
    self.view.backgroundColor = [UIColor whiteColor];
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
    _addressTF.backgroundColor = [UIColor qmui_colorWithHexString:@"f6f6f6"];
    [self.view addSubview:_addressTF];
    
    _smButton = [[QMUIButton alloc] init];
    [_smButton setImage:[UIImage imageNamed:@"sm2"] forState:UIControlStateNormal];
    [self.view addSubview:_smButton];
    _smButton.frame = CGRectMake(SCREEN_WIDTH - 50, dynamicY + 10, 30, 30);
    dynamicY += 70;
    
    UILabel *label2 = [[UILabel alloc] qmui_initWithFont:UIFontMake(16) textColor:UIColorBlack];
    label2.text = @"金额";
    label2.frame = CGRectMake(10, dynamicY, 50, 30);
    _drmbLabel = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(16) textColor:UIColorBlack];
    
    _drmbLabel.frame = CGRectMake(70, dynamicY, SCREEN_WIDTH - 130, 30);
    _drmbLabel.textAlignment = NSTextAlignmentRight;
    QMUIButton *exchangeBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, dynamicY, 30, 30)];
    [exchangeBtn setBackgroundImage:UIImageMake(@"t_ex") forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
//    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
//    exchangeBtn.titleLabel.font = UIFontMake(16);
    
    
    [self.view addSubview:exchangeBtn];
    [self.view addSubview:_drmbLabel];
    dynamicY += 40;
    [self.view addSubview:label2];
    _moneyTF = [[QMUITextField alloc] initWithFrame:CGRectMake(10, dynamicY, SCREEN_WIDTH - 20, 100)];
   
    _moneyTF.font = UIFontMake(36);
    _moneyTF.layer.cornerRadius = 4;
    _moneyTF.placeholder = @"0.00";
    _moneyTF.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _moneyTF.backgroundColor = [UIColor qmui_colorWithHexString:@"f6f6f6"];
    _moneyTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_moneyTF];
    
    
    
    dynamicY += 100;
    _remarkTF = [[QMUITextField alloc] initWithFrame:CGRectMake(10, dynamicY, SCREEN_WIDTH - 20, 50)];
    _remarkTF.font = UIFontMake(20);
    _remarkTF.layer.cornerRadius = 4;
    _remarkTF.placeholder = @"备注";
    _remarkTF.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _remarkTF.backgroundColor = [UIColor qmui_colorWithHexString:@"f6f6f6"];
    [self.view addSubview:_remarkTF];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, dynamicY, SCREEN_WIDTH - 40, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    dynamicY += 80;
    QMUILabel *label4 = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(16) textColor:UIColorGreen];

    label4.textColor = [UIColor greenColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"转账手续费：0.00%"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 6)];

    label4.attributedText = str;
    label4.frame = CGRectMake(0, dynamicY, SCREEN_WIDTH, 30);
    label4.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label4];

    dynamicY += 40;
    _submitButton = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorBlue frame:CGRectMake(30, dynamicY, SCREEN_WIDTH-60, 50)];
    [_submitButton setFillColor:[UIColor blueColor]];
    [_submitButton setTitle:@"转账" forState:UIControlStateNormal];
    _submitButton.cornerRadius = 4;
    [self.view addSubview:_submitButton];
    
    [_smButton addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];


}

-(void)getData {
   User *user = [User sharedInstance];
   if (user.token.length <= 0) {
       return;
   }
   
   NSString *url = @"http://sz.zy.hn:8123/api/info";
   
   NSDictionary *params = @{@"token": user.token
   };
   if (_manager == nil) {
       AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
       
       manager.requestSerializer = [AFJSONRequestSerializer serializer];
       manager.responseSerializer = [AFJSONResponseSerializer serializer];
       
       [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
       manager.requestSerializer.timeoutInterval = 60;
       manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
       _manager = manager;
   }
   
   [_manager POST:url parameters:params headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       //{"status":"ok","msg":"登录成功","data":{"name":"cyx","token":"j3jtqmd2rCPJGgL0yq6w2rKs0lIpfzGl-afgHIJuAQE="}}
       NSDictionary *dict = responseObject;
       if ([dict[@"status"] isEqualToString:@"ok"]) {
           NSNumber *num = dict[@"data"][@"drmb"];
           self.drmbLabel.text = [NSString stringWithFormat:@"当前可用DRMB：%.2f", [num floatValue]];
       }

   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"登录请求失败");
   }];


   // 获取汇率

}


- (void)scan {

    ZFScanViewController * vc = [[ZFScanViewController alloc] init];
       vc.returnScanBarCodeValue = ^(NSString * barCodeString){
           //扫描完成后，在此进行后续操作
           self.addressTF.text = barCodeString;
       };

       [self presentViewController:vc animated:YES completion:nil];
}

- (void)submit {
    NSString *money = _moneyTF.text;
    if (money.length <= 0) {
        return;
    }
    NSString *address = _addressTF.text;
    NSString *remark = _remarkTF.text;
    if (address.length <= 0) {
        [QMUITips showError:@"请输入钱包地址" inView:self.view hideAfterDelay:2];
        return;
    }
    if (money.floatValue > [User sharedInstance].drmb) {
        [QMUITips showError:@"余额不足" inView:self.view hideAfterDelay:2];
        return;;
    }
    User *user = [User sharedInstance];
    if (user.token.length <= 0) {
        return;
    }
    
    NSString *url = @"http://sz.zy.hn:8123/api/transfer";
    
    NSDictionary *params = @{@"token": user.token,
                             @"amount": [NSNumber numberWithLong:[money longLongValue]],
                             @"address": address,
                             @"mark": remark ? remark : @""
    };

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];

    
    [QMUITips showLoadingInView:self.view];
    [manager POST:url parameters:params headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [QMUITips hideAllTips];
        //{"status":"ok","msg":"登录成功","data":{"name":"cyx","token":"j3jtqmd2rCPJGgL0yq6w2rKs0lIpfzGl-afgHIJuAQE="}}
        NSDictionary *dict = responseObject;
        NSString *info = dict[@"msg"];
        if ([dict[@"status"] isEqualToString:@"ok"]) {
            
            SuccessViewController *sucVC = [[SuccessViewController alloc] init];
            sucVC.info = info;
            [self presentViewController:sucVC animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:false];
            }];

        } else {
            [QMUITips showError:info inView:self.view hideAfterDelay:2];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [QMUITips hideAllTips];
        NSLog(@"登录请求失败");
    }];
    
}

- (void)exchange {
    ExchangeViewController *vc = [[ExchangeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

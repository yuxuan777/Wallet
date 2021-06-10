//
//  WalletViewController.m
//  Wallet
//
//  Created by HuangBin Ye on 2021/6/8.
//

#import "WalletViewController.h"
#import "SGQRCode.h"
#import <AFNetworking/AFNetworking.h>
#import "User.h"
#import "TransferViewController.h"
#import "ZFScanViewController.h"

@interface WalletViewController ()

@property (nonatomic, strong) QMUILabel *addressLabel;
@property (nonatomic, strong) QMUIButton *addressButton;
@property (nonatomic, strong) QMUILabel *totalLabel;
@property (nonatomic, strong) QMUIButton *rmbButton;
@property (nonatomic, strong) QMUIButton *drmbButton;
@property (nonatomic, strong) QMUIButton *usdButton;
@property (nonatomic, strong) QMUIButton *eurButton;
@property (nonatomic, strong) QMUIButton *smButton;
@property (nonatomic, strong) SGQRCodeManager *cameraManager;

// 币种
@property (nonatomic, strong) QMUILabel *drmbLabel;
@property (nonatomic, strong) QMUILabel *rmbLabel;
@property (nonatomic, strong) QMUILabel *usdLabel;
@property (nonatomic, strong) QMUILabel *eurLabel;

@property (nonatomic, strong) AFHTTPSessionManager *manager;


@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"钱包";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"转账" style:UIBarButtonItemStylePlain target:self action:@selector(transfer)];
    
    [self setupUI];
    

    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getData];
}

- (UIColor *)titleViewTintColor {
    return [UIColor blackColor];
}

- (UIColor *)navigationBarTintColor {
    return [UIColor blackColor];
}


- (void)transfer {
    
    [self.navigationController pushViewController:[[TransferViewController alloc] init] animated:YES];
}
- (void)getData {
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
            [self setupInfoData: dict];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录请求失败");
    }];


    // 获取汇率

}

- (void)setupInfoData: (NSDictionary *)dict {
    NSDictionary *data = dict[@"data"];
    NSNumber *drmb = data[@"drmb"];
    NSNumber *eur = data[@"eur"];
    NSNumber *rmb = data[@"rmb"];
    NSNumber *usd = data[@"usd"];
    
    _drmbLabel.text = [NSString stringWithFormat:@"%.2f",[drmb qmui_CGFloatValue]];
    _eurLabel.text = [NSString stringWithFormat:@"%.2f",[eur qmui_CGFloatValue]];
    _rmbLabel.text = [NSString stringWithFormat:@"%.2f",[rmb qmui_CGFloatValue]];
    _usdLabel.text = [NSString stringWithFormat:@"%.2f",[usd qmui_CGFloatValue]];
    _addressLabel.text = data[@"wallet"];
    [User sharedInstance].wallet = data[@"wallet"];
    [User sharedInstance].drmb = [drmb floatValue];
    NSDictionary *param = @{@"token": [User sharedInstance].token};
    NSString *url = @"http://sz.zy.hn:8123/api/er";
    [_manager POST:url parameters:
    param headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"ok"]) {
            NSDictionary *rateData = responseObject[@"data"];
            NSNumber *rateEur = rateData[@"eur"];
            NSNumber *rateUsd = rateData[@"usd"];
            CGFloat total = rmb.qmui_CGFloatValue + drmb.qmui_CGFloatValue + eur.qmui_CGFloatValue/rateEur.qmui_CGFloatValue + usd.qmui_CGFloatValue/rateUsd.qmui_CGFloatValue;
            _totalLabel.text = [NSString stringWithFormat:@"¥ %.2f", total];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
    /*
     {
         drmb = 0;
         eur = 0;
         name = cyx;
         rmb = 5000;
         usd = 0;
         wallet = 1GMhPo7kzSmth1M4VU8Xiq4fGjCWU3h5rq;
     };
     */
}
- (void)setupUI {
    CGFloat dynamicY = 10;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10 , dynamicY, SCREEN_WIDTH - 20, 160)];
    dynamicY += 160;
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
    label1.font = [UIFont boldSystemFontOfSize:18];
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
    
    QMUIButton *dupBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(bgView.qmui_width - 90, 55, 20, 20)];
    [dupBtn setBackgroundImage:UIImageMake(@"dup") forState:UIControlStateNormal];
    [dupBtn addTarget:self action:@selector(dupAddress) forControlEvents:UIControlEventTouchUpInside];
    
    
    label1.frame = CGRectMake(20, 10, 60, 18);
    _addressButton.frame = CGRectMake(80, 10, 20, 20);
    _smButton.frame = CGRectMake(bgView.qmui_width - 60, 20, 40, 40);
    _addressLabel.frame = CGRectMake(20, 40, bgView.qmui_width - 110, 50);
    label2.frame = CGRectMake(20, bgView.frame.size.height - 40, 120, 30);
    _totalLabel.textAlignment = NSTextAlignmentRight;
    _totalLabel.frame = CGRectMake(140, bgView.frame.size.height - 40, bgView.frame.size.width - 160, 30);
    
    _addressLabel.text = @"";
    _totalLabel.text =  @"";
    [bgView addSubview:label1];
    [bgView addSubview:_addressLabel];
    [bgView addSubview:_addressButton];
    [bgView addSubview:label2];
    [bgView addSubview:_totalLabel];
    [bgView addSubview:_smButton];
    [bgView addSubview:dupBtn];
    
    [_smButton addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
    [_addressButton addTarget:self action:@selector(qrClick) forControlEvents:UIControlEventTouchUpInside];
    
    QMUILabel *coinLabel = [[QMUILabel alloc] qmui_initWithFont:[UIFont boldSystemFontOfSize:18] textColor:[UIColor grayColor]];
    coinLabel.frame = CGRectMake(10, dynamicY + 20, SCREEN_WIDTH - 20, 30);
    coinLabel.text = @"资产";
    dynamicY += 50;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, dynamicY, SCREEN_WIDTH - 20, 1)];
    dynamicY += 1;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:coinLabel];
    [self.view addSubview:lineView];
    
    
    _drmbLabel = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor]];
    UIView *drmbView = [self createCoinUI:_drmbLabel imgName:@"b1" labelName:@"DRMB"];
    [self.view addSubview:drmbView];
    drmbView.frame = CGRectMake(10, dynamicY, SCREEN_WIDTH-20, 50);
    dynamicY += 50;
    
    _rmbLabel = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor]];
    UIView *rmbView = [self createCoinUI:_rmbLabel imgName:@"b2" labelName:@"RMB"];
    [self.view addSubview:rmbView];
    rmbView.frame = CGRectMake(10, dynamicY, SCREEN_WIDTH-20, 50);
    dynamicY += 50;
    
    _usdLabel = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor]];
    UIView *usdView = [self createCoinUI:_usdLabel imgName:@"b3" labelName:@"USD"];
    [self.view addSubview:usdView];
    usdView.frame = CGRectMake(10, dynamicY, SCREEN_WIDTH-20, 50);
    dynamicY += 50;
    
    _eurLabel = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor]];
    UIView *eurView = [self createCoinUI:_eurLabel imgName:@"b4" labelName:@"EUR"];
    [self.view addSubview:eurView];
    eurView.frame = CGRectMake(10, dynamicY, SCREEN_WIDTH-20, 50);
    dynamicY += 50;
    
     
    
    
}


- (void)dupAddress {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.addressLabel.text;
    [QMUITips showSucceed:@"复制成功" inView:self.view hideAfterDelay:1.5];
}

- (void)qrClick {
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(30, (SCREEN_HEIGHT - SCREEN_WIDTH)*0.5, SCREEN_WIDTH - 60, SCREEN_WIDTH - 30)];
    contentView.backgroundColor = [UIColor blueColor];
//    UIImage *img = [SGQRCodeManager generateQRCodeWithData:[User sharedInstance].wallet size:SCREEN_WIDTH - 120];
    UIImage *img = [SGQRCodeManager generateQRCodeWithData:[User sharedInstance].wallet size:SCREEN_WIDTH - 120 logoImage:UIImageMake(@"AppIcon") ratio:0.25];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [contentView addSubview:imgView];
    imgView.frame = CGRectMake(30, 60, SCREEN_WIDTH - 120, SCREEN_WIDTH - 120);
    
    QMUILabel *titleLabel = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(16) textColor:[UIColor whiteColor]];
    titleLabel.numberOfLines = 0;
    
    
    titleLabel.text = [NSString stringWithFormat:@"扫描二维码可向 %@ 转账",[User sharedInstance].name];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.frame = CGRectMake(0, 10, SCREEN_WIDTH - 60, 40);
    
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.dimmingView = bgView;
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)scanClick {

    ZFScanViewController * vc = [[ZFScanViewController alloc] init];
       vc.returnScanBarCodeValue = ^(NSString * barCodeString){
           //扫描完成后，在此进行后续操作
           TransferViewController *vc = [[TransferViewController alloc] init];
           vc.toAddress = barCodeString;
           [self.navigationController pushViewController:vc animated:YES];
       };

       [self presentViewController:vc animated:YES completion:nil];
}


- (UIView *)createCoinUI:  (QMUILabel* )label imgName: (NSString *)imgName labelName: (NSString *)labelName {
    UIView *contain = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 60)];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    QMUILabel *textLabel = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor]];
    textLabel.text = labelName;

    [contain addSubview:icon];
    [contain addSubview:textLabel];
    [contain addSubview:label];
    icon.frame = CGRectMake(10, 10, 30, 30);
    textLabel.frame = CGRectMake(50, 10, 70, 30);
    label.frame = CGRectMake(120, 10, SCREEN_WIDTH - 150, 30);
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"¥100";
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

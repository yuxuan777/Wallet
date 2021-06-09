//
//  WalletViewController.m
//  Wallet
//
//  Created by HuangBin Ye on 2021/6/8.
//

#import "WalletViewController.h"
#import "SGQRCode.h"
#import <AFNetworking/AFNetworking.h>
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
//    [self getData];
    // Do any additional setup after loading the view.
}
- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

//    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    // 获取信息
    NSDictionary *params = @{@"token":@"sEHocA8weOZWvalhdHfEp2NBBJW9Ww7CUiSoYT-QTmM="};
    
  
    [manager POST:@"http://sz.zy.hn:8123/api/info" parameters:params headers:@{} progress:Nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];

    // 获取汇率
//    [manager GET:@"http://sz.zy.hn:8123/api/er" parameters:@{@"token": @"uDOq7Z7Aq6aQd6rL6YF5-yWw9ecQr6a2pkw_zVJL3aM="} headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        }];
}

- (void)setupUI {
    CGFloat dynamicY = 60;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10 , dynamicY, SCREEN_WIDTH - 20, SCREEN_HEIGHT * 0.15)];
    dynamicY += SCREEN_HEIGHT * 0.15;
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
    
    QMUILabel *coinLabel = [[QMUILabel alloc] qmui_initWithFont:[UIFont boldSystemFontOfSize:18] textColor:[UIColor grayColor]];
    coinLabel.frame = CGRectMake(10, dynamicY + 20, SCREEN_WIDTH - 20, 30);
    coinLabel.text = @"资产";
    dynamicY += 50;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, dynamicY, SCREEN_WIDTH - 20, 1)];
    dynamicY += 1;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:coinLabel];
    [self.view addSubview:lineView];
    
    UIView *drmbView = [self createCoinUI:_drmbLabel imgName:@"b1" labelName:@"DRMB"];
    [self.view addSubview:drmbView];
    drmbView.frame = CGRectMake(10, dynamicY, SCREEN_WIDTH-20, 60);
    dynamicY += 60;
    
    UIView *rmbView = [self createCoinUI:_drmbLabel imgName:@"b2" labelName:@"RMB"];
    [self.view addSubview:rmbView];
    rmbView.frame = CGRectMake(10, dynamicY, SCREEN_WIDTH-20, 60);
    dynamicY += 60;
    
    UIView *usdView = [self createCoinUI:_drmbLabel imgName:@"b3" labelName:@"USD"];
    [self.view addSubview:usdView];
    usdView.frame = CGRectMake(10, dynamicY, SCREEN_WIDTH-20, 60);
    dynamicY += 60;
    
    UIView *eurView = [self createCoinUI:_drmbLabel imgName:@"b4" labelName:@"EUR"];
    [self.view addSubview:eurView];
    eurView.frame = CGRectMake(10, dynamicY, SCREEN_WIDTH-20, 60);
    dynamicY += 60;
    
     
    
    
}



- (void)qrClick {
    UIImage *img = [SGQRCodeManager generateQRCodeWithData:@"xxxxxx" size:SCREEN_WIDTH - 80];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = imgView;
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)scanClick {
    [[SGQRCodeManager QRCodeManager]  scanWithController:self resultBlock:^(SGQRCodeManager *manager, NSString *result) {
        NSLog(@"result");
    }];
}


- (UIView *)createCoinUI: (QMUILabel *)label imgName: (NSString *)imgName labelName: (NSString *)labelName {
    UIView *contain = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 60)];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    QMUILabel *textLabel = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor]];
    textLabel.text = labelName;
    label = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor]];
    [contain addSubview:icon];
    [contain addSubview:textLabel];
    [contain addSubview:label];
    icon.frame = CGRectMake(10, 10, 40, 40);
    textLabel.frame = CGRectMake(60, 10, 100, 40);
    label.frame = CGRectMake(SCREEN_WIDTH-130, 10, 100, 40);
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

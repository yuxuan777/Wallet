//
//  ExchangeViewController.m
//  Wallet
//
//  Created by SimonYHB on 2021/6/9.
//

#import "ExchangeViewController.h"
#import "QMUIKit.h"
#import <AFNetworking/AFNetworking.h>
#import "User.h"
@interface ExchangeViewController ()<UITextFieldDelegate,QMUITextFieldDelegate>
@property (nonatomic, strong) QMUIButton *expBtn;
@property (nonatomic, strong) QMUIButton *exgBtn;
@property (nonatomic, strong) QMUITextField *expTF;
@property (nonatomic, strong) QMUITextField *exgTF;
@property (nonatomic, strong) QMUILabel *rateLabel;
@property (nonatomic, strong) NSDictionary *rateDict;
@property (nonatomic, assign) CGFloat currentRate;
@property (nonatomic, assign) BOOL isEXP;


@property (nonatomic, strong) NSArray *expArr;
@property (nonatomic, strong) NSArray *exgArr;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换";
    self.currentRate = 1;
    [self getRateData];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
    [_expBtn addTarget:self action:@selector(expBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_exgBtn addTarget:self action:@selector(exgBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_expTF addTarget:self action:@selector(expTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
//    [_exgTF addTarget:self action:@selector(exgTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _expTF.delegate = self;
    _exgTF.delegate = self;
    self.expArr = @[@"DRMB",@"RMB",@"USD",@"EUR"];
    self.exgArr =  @[@"RMB",@"USD",@"EUR"];
    
    // Do any additional setup after loading the view.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _expTF) {
        CGFloat exp = textField.text.floatValue;
        self.exgTF.text = [NSString stringWithFormat:@"%.2f", exp*_currentRate];
    } else {
        CGFloat exg = textField.text.floatValue;
        self.expTF.text = [NSString stringWithFormat:@"%.2f", exg/_currentRate];
    }
    textField.text = [NSString stringWithFormat:@"%.2f", textField.text.floatValue];
}


- (void)getRateData {
    NSDictionary *param = @{@"token": [User sharedInstance].token};
    NSString *url = @"http://sz.zy.hn:8123/api/er";
    if (_manager == nil) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer.timeoutInterval = 60;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
        _manager = manager;
    }
    [_manager POST:url parameters:
    param headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"ok"]) {
            self.rateDict = responseObject[@"data"];
            
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
}

-(void)expBtnClick {
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"转出币种";
    dialogViewController.items = self.expArr;
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
    };
    dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        if ([self.expArr[itemIndex] isEqualToString:@"DRMB"])  {
            self.exgArr = @[@"RMB",@"USD",@"EUR"];
            if ([[self.exgBtn titleForState:UIControlStateNormal] isEqualToString:@"DRMB"]) {
                [self.exgBtn setTitle:@"RMB" forState:UIControlStateNormal];
            }
        } else {
            [self.exgBtn setTitle:@"DRMB" forState:UIControlStateNormal];
            self.exgArr = @[@"DRMB"];
        }
        [self.expBtn setTitle:self.expArr[itemIndex] forState:UIControlStateNormal];
        NSString *exgS = [[self.exgBtn titleForState:UIControlStateNormal] lowercaseString];
        NSString *expS = [self.expArr[itemIndex] lowercaseString];
        self.currentRate = [self.rateDict[exgS] floatValue] / [self.rateDict[expS] floatValue];
        [self reloadRateLabel];

        self.exgTF.text = [NSString stringWithFormat:@"%.2f", self.expTF.text.floatValue*self.currentRate];
        [aDialogViewController hide];
        
    };
    [dialogViewController show];
}

-(void)exgBtnClick {
 
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"收到币种";
    dialogViewController.items = self.exgArr;
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
    };
    dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        
        [self.exgBtn setTitle:self.exgArr[itemIndex] forState:UIControlStateNormal];
        NSString *exgS = [self.exgArr[itemIndex] lowercaseString];
        NSString *expS = [[self.expBtn titleForState:UIControlStateNormal] lowercaseString];
        self.currentRate = [self.rateDict[exgS] floatValue] / [self.rateDict[expS] floatValue];
        [self reloadRateLabel];
        self.exgTF.text = [NSString stringWithFormat:@"%.2f", self.expTF.text.floatValue*self.currentRate];
        [aDialogViewController hide];
    };
    [dialogViewController show];
}
- (void)reloadRateLabel {
    NSString *exp = [self.expBtn titleForState:UIControlStateNormal];
    NSString *exg = [self.exgBtn titleForState:UIControlStateNormal];
    
    self.rateLabel.text = [NSString stringWithFormat:@"当前汇率 1 %@ = %.2f %@",exp,self.currentRate,exg];
}
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat dynamicY = 20;
    UIImageView *expIcon = [[UIImageView alloc] initWithImage:UIImageMake(@"exp")];
    expIcon.frame = CGRectMake(20, dynamicY+5, 40, 40);
    [self.view addSubview:expIcon];
    self.expBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(50, dynamicY, 80, 50)];
    [self.expBtn setTitle:@"DRMB" forState:UIControlStateNormal];
    [_expBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _expBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_expBtn];
    _expTF = [[QMUITextField alloc] initWithFrame:CGRectMake(140, dynamicY, SCREEN_WIDTH - 160, 50)];
    _expTF.textAlignment = NSTextAlignmentRight;
    _expTF.placeholder = @"兑换数量";
    _expTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_expTF];
    dynamicY+=50;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, dynamicY+19.5, SCREEN_WIDTH - 40, 1)];
    line.backgroundColor = [UIColor qmui_colorWithHexString:@"eeeeee"];
    [self.view addSubview:line];
    UIImageView *exIcon = [[UIImageView alloc] initWithImage:UIImageMake(@"ex")];
    exIcon.backgroundColor = [UIColor whiteColor];
    exIcon.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 20, dynamicY, 40, 40);
    [self.view addSubview:exIcon];
    dynamicY+=40;
    
    UIImageView *exgIcon = [[UIImageView alloc] initWithImage:UIImageMake(@"exg")];
    exgIcon.frame = CGRectMake(20, dynamicY+5, 40, 40);
    [self.view addSubview:exgIcon];
    self.exgBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(50, dynamicY, 80, 50)];
    [self.exgBtn setTitle:@"RMB" forState:UIControlStateNormal];
    [self.exgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.exgBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    

    [self.view addSubview:_exgBtn];
    _exgTF = [[QMUITextField alloc] initWithFrame:CGRectMake(120, dynamicY, SCREEN_WIDTH - 140, 50)];
    _exgTF.textAlignment = NSTextAlignmentRight;
    _exgTF.placeholder = @"预计支出数量";
    [self.view addSubview:_exgTF];
    _exgTF.keyboardType = UIKeyboardTypeNumberPad;
    dynamicY += 70;
    
    _rateLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(20, dynamicY, SCREEN_WIDTH-40, 30)];
    _rateLabel.font = [UIFont systemFontOfSize:14];
    _rateLabel.textColor = [UIColor qmui_colorWithHexString:@"999999"];
    _rateLabel.text = @"当前汇率 1DRMB = 1RMB";
    [self.view addSubview:_rateLabel];
    dynamicY += 40;
    
    QMUIFillButton *button = [[QMUIFillButton alloc] initWithFillColor:[UIColor blueColor] titleTextColor:[UIColor whiteColor]];
    [button setTitle:@"确定兑换" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, dynamicY, SCREEN_WIDTH-40, 40);
    button.cornerRadius = 4;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
}

- (void)exchange {
    NSString *exg = self.exgTF.text;
//    NSNumber *exg_num = [[NSNumber alloc] initWithDouble:[exg doubleValue]];
    if (exp > 0) {
        User *user = [User sharedInstance];
        if (user.token.length <= 0) {
            return;
        }
        
        NSString *url = @"http://sz.zy.hn:8123/api/exchange";
        
        NSDictionary *params = @{@"token": user.token,
                                 @"currency": [[self.expBtn titleForState:UIControlStateNormal] lowercaseString],
                                 @"target": [[self.exgBtn titleForState:UIControlStateNormal] lowercaseString],
                                 @"amount": @([exg floatValue])

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
        [QMUITips showLoadingInView:self.view];
        [_manager POST:url parameters:params headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [QMUITips hideAllTips];
            //{"status":"ok","msg":"登录成功","data":{"name":"cyx","token":"j3jtqmd2rCPJGgL0yq6w2rKs0lIpfzGl-afgHIJuAQE="}}
            NSDictionary *dict = responseObject;
            if ([dict[@"status"] isEqualToString:@"ok"]) {
                [QMUITips showSucceed:@"兑换成功" inView:self.view hideAfterDelay:1.5];
            } else {
                NSString *msg = dict[@"msg"];
                [QMUITips showError:msg inView:self.view hideAfterDelay:1.5];
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [QMUITips hideAllTips];
            [QMUITips showError:error.description inView:self.view hideAfterDelay:1.5];
        }];
    }
}
@end

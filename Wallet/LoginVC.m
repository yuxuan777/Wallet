//
//  LoginVC.m
//  Wallet
//
//  Created by cuiyuxuan on 2021/6/8.
//

#import "LoginVC.h"
#import <AFNetworking/AFNetworking.h>
#import "RSA.h"
#import "User.h"
#import "WalletViewController.h"
#import "ExchangeRateVC.h"

#import "SuccessViewController.h"

@interface LoginVC ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) QMUIFillButton *loginBtn;
@property (nonatomic, strong) QMUITextField *nameField;
@property (nonatomic, strong) QMUITextField *pwdField;
//@property (nonatomic, strong) QMUIButton *loginBtn;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (UIColor *)titleViewTintColor {
    return [UIColor blackColor];
}

- (UIColor *)navigationBarTintColor {
    return [UIColor blackColor];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"登录";
    
    CGFloat imageWH = 160;
    CGFloat imageX = (SCREEN_WIDTH - imageWH) * 0.5;
    CGFloat imageY = 120;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageWH, imageWH)];
    imageView.image = UIImageMake(@"icon-1024-1");
    [self.view addSubview:imageView];
    
    CGFloat iconWH = 20;
    CGFloat textW = SCREEN_WIDTH - 120;
    
    CGFloat sumW = iconWH + 10 + textW;
    CGFloat iconX = (SCREEN_WIDTH - sumW) * 0.5;
    CGFloat iconY = imageView.qmui_bottom + 20 + 10;
    UIImageView *iconView1 = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconWH, iconWH)];
    iconView1.image = UIImageMake(@"用户名");
//    iconView1.backgroundColor = [UIColor redColor];
    [self.view addSubview:iconView1];
    
    CGFloat textH = 44;
    CGFloat textY = iconY - 10;
    CGFloat textX = iconView1.qmui_right + 10;
    QMUITextField *nameField = [[QMUITextField alloc] initWithFrame:CGRectMake(textX, textY, textW, textH)];
    nameField.placeholder = @"用户名";
    nameField.font = UIFontMake(18);
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    nameField.text = @"cyx";
//    nameField.backgroundColor = [UIColor redColor];
    [self.view addSubview:nameField];
    self.nameField = nameField;
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(textX, CGRectGetMaxY(nameField.frame), textW, PixelOne)];
    line1.backgroundColor = UIColorSeparator;
    [self.view addSubview:line1];
    
    iconY = nameField.qmui_bottom + 20;
    UIImageView *iconView2 = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconWH, iconWH)];
    iconView2.image = UIImageMake(@"密码");
//    iconView2.backgroundColor = [UIColor redColor];
    [self.view addSubview:iconView2];
    
    CGFloat pwdY = nameField.qmui_bottom + 10;
    
    QMUITextField *pwdField = [[QMUITextField alloc] initWithFrame:CGRectMake(textX, pwdY, textW, textH)];
    pwdField.placeholder = @"密码";
    pwdField.font = UIFontMake(18);
    pwdField.secureTextEntry = YES;
    pwdField.text = @"12345678";
//    pwdField.backgroundColor = [UIColor redColor];
    pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdField.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.view addSubview:pwdField];
    self.pwdField = pwdField;
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(textX, CGRectGetMaxY(pwdField.frame), textW, PixelOne)];
    line2.backgroundColor = UIColorSeparator;
    [self.view addSubview:line2];
    
    CGFloat btnW = pwdField.qmui_width;
    CGFloat btnX = (SCREEN_WIDTH - btnW) * 0.5;
    CGFloat btnY = CGRectGetMaxY(pwdField.frame) + 40;
    QMUIFillButton *loginBtn = [[QMUIFillButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, 44)];
    loginBtn.fillColor = [UIColor blackColor];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = UIFontMake(18);
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)loginBtnPressed {
    if (self.nameField.text.length <= 0 || self.pwdField.text.length <= 0) {
        return;;
    }

    [self requestLogin];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)requestLogin {
    
//    [self showEmptyViewWithLoading];
    [self showEmptyViewWithLoading:YES image:nil text:@"加载中" detailText:nil buttonTitle: nil buttonAction:nil];
    
    NSString *name = self.nameField.text;
    NSString *pwd = self.pwdField.text;

    NSString *encyptText = [self rsa:pwd];

    NSDictionary *params = @{@"name": name,
                             @"pass": encyptText
    };

//    NSString *url = @"https://sz.ilovn.com/api/login";
    NSString *url = @"http://sz.zy.hn:8123/api/login";

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.timeoutInterval = 60;
    
    //这一行必须加
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];

    [manager POST:url parameters:params headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //{"status":"ok","msg":"登录成功","data":{"name":"cyx","token":"j3jtqmd2rCPJGgL0yq6w2rKs0lIpfzGl-afgHIJuAQE="}}
        NSDictionary *dict = responseObject;
        if ([dict[@"status"] isEqualToString:@"ok"]) {

            [self loginSuccess:dict];
        }
        
        [self hideEmptyView];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录请求失败");
        
        [self hideEmptyView];
    }];
}

- (NSString *)rsa:(NSString *)pwdText {
    NSString *pubkey = @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDAvlVsH1HRrqgVeInz28Dm2vp2a4XHeDLFeCJeDQ48BjXV/VDaTKGlpdznhzX0zijb7xmniKJ56nBYrFCVUUH7IHCpRZNCIAqxqnuTz3ddKA3wT3QSGqgQA27VLF4rVYiBcpjYiXDXrqgNvR8L+/hw/WGpKpuf0ZlwZWp54bhAwwIDAQAB-----END PUBLIC KEY-----";
    
//    NSString *privkey = @"-----BEGIN RSA PRIVATE KEY-----MIICXQIBAAKBgQDAvlVsH1HRrqgVeInz28Dm2vp2a4XHeDLFeCJeDQ48BjXV/VDaTKGlpdznhzX0zijb7xmniKJ56nBYrFCVUUH7IHCpRZNCIAqxqnuTz3ddKA3wT3QSGqgQA27VLF4rVYiBcpjYiXDXrqgNvR8L+/hw/WGpKpuf0ZlwZWp54bhAwwIDAQABAoGALJFWS0QKtUN/lkdjDsI3nqnv1EYUjwUaKFMZD0pRikudUzfZ5EBn+Feb9uVq8ophJEnrUrPjbfFpvPdLQtuhN7uI9grYNTYyORcMQ/7gSNiIgKh3WrsxHkxZWIj4PodtxZlDvN2KXvRPzfn+xIy+Ly0pgEblmSYK6bQb7JYz8xECQQDkwC+vzEohbmdLsFZBLN10E4tPVg1JuM2P4jrJAU+alUZ8SqQnfnFuy2zp26Oy9zqOdsI5RbSas9PynRtgPmKfAkEA17QY5DmjltP7jw1GfW1FEdkPmw/O6uKZKArhxgow+qHsOOBC46HYGSnb9HZ7uHzWsYh1NfVBRk1w8rC03J9zXQJBAM23sKsOs9Qg77B34vo2GOpc8TnmD4kvM16ke21tSmOgv4Tjs4D5C5YyR76AklVOVVDtqHnNIEDIXGGhvI7vS80CQQDK/uZeAhB+JUkcuzWXXHof7dLN7vaf/lh8YqFPKtAlTrVsYUER0IH6THZ/ffG5EWNK+Ey2VvTzIHYnLz1GU5jRAkBSm1yhDud2UFrtB4E2jANx4BSGEseBN5DQwauDBQ85bWjsgdLynb++4LoZngOyqaXwyapwH/K8F1R8ghTRAuTt-----END RSA PRIVATE KEY-----";

    NSString *encrypted = [RSA encryptString:pwdText publicKey:pubkey];
//    NSLog(@"encrypted: %@", encrypted);

    return encrypted;
}

- (void)loginSuccess:(NSDictionary *)dict {
    NSDictionary *dataDic = dict[@"data"];
    
    //保存用户信息
    User *user = [User sharedInstance];
    user.name = dataDic[@"name"];
    user.token = dataDic[@"token"];
    
    //跳转
    QMUITabBarViewController *tabBarViewController = [[QMUITabBarViewController alloc] init];
    tabBarViewController.tabBar.tintColor = [UIColor blackColor];
    
    //首页
    WalletViewController *walletVC = [[WalletViewController alloc] init];
    
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"钱包" image:[UIImageMake(@"钱包") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
//    tabBarItem1.imageInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    tabBarItem1.selectedImage = [UIImageMake(@"钱包 (1)") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    walletVC.tabBarItem = tabBarItem1;
//    walletVC.hidesBottomBarWhenPushed = YES;
    
    QMUINavigationController *nav1 = [[QMUINavigationController alloc] initWithRootViewController:walletVC];
//    nav1.navigationItem.qmui_navigationBar.tintColor = [UIColor blackColor];
    
    //汇率
    ExchangeRateVC *exchangeVC = [[ExchangeRateVC alloc] initWithStyle:UITableViewStylePlain];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"汇率" image:[UIImageMake(@"汇率 (1)") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:1];
    tabBarItem2.imageInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    tabBarItem2.selectedImage = [UIImageMake(@"汇率") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    exchangeVC.tabBarItem = tabBarItem2;
//    exchangeVC.hidesBottomBarWhenPushed = YES;
    
    
    QMUINavigationController *nav2 = [[QMUINavigationController alloc] initWithRootViewController:exchangeVC];
//    nav2.navigationItem.qmui_navigationBar.tintColor = [UIColor blackColor];
//    nav2.navigationItem.qmui_nextItem.qmui_navigationBar.tintColor = [UIColor blackColor];
    
    tabBarViewController.viewControllers = @[nav1, nav2];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarViewController;
    
}

@end

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

@interface LoginVC ()

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

//- (void)didInitialize {
//    [super didInitialize];
//}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setTitle:@"登录"];
    
    CGFloat textW = SCREEN_WIDTH - 80;
    CGFloat textH = 44;
    CGFloat textY = 160;
    CGFloat textX = (SCREEN_WIDTH - textW) * 0.5;
    QMUITextField *nameField = [[QMUITextField alloc] initWithFrame:CGRectMake(textX, textY, textW, textH)];
    nameField.placeholder = @"用户名";
    nameField.font = UIFontMake(18);
//    nameField.layer.cornerRadius = 2;
//    nameField.layer.borderColor = UIColorSeparator.CGColor;
//    nameField.layer.borderWidth = PixelOne;
    nameField.clearButtonMode = UITextFieldViewModeAlways;
    nameField.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    nameField.text = @"cyx";
    [self.view addSubview:nameField];
    self.nameField = nameField;
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(textX, CGRectGetMaxY(nameField.frame), textW, PixelOne)];
    line1.backgroundColor = UIColorSeparator;
    [self.view addSubview:line1];
    
    CGFloat pwdY = CGRectGetMaxY(nameField.frame) + 10;
    QMUITextField *pwdField = [[QMUITextField alloc] initWithFrame:CGRectMake(textX, pwdY, textW, textH)];
    pwdField.placeholder = @"密码";
    pwdField.font = UIFontMake(18);
    pwdField.secureTextEntry = YES;
    pwdField.text = @"12345678";
//    pwdField.layer.cornerRadius = 2;
//    pwdField.layer.borderColor = UIColorSeparator.CGColor;
//    pwdField.layer.borderWidth = PixelOne;
    pwdField.clearButtonMode = UITextFieldViewModeAlways;
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
    loginBtn.fillColor = [UIColor orangeColor];
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
    
//    //跳转
//    QMUITabBarViewController *tabBarViewController = [[QMUITabBarViewController alloc] init];
//
//    //首页
//    WalletViewController *walletVC = [[WalletViewController alloc] init];
//    walletVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"wallet" image:UIImageMake(@"wallet") tag:0];
//    walletVC.tabBarItem.selectedImage = UIImageMake(@"wallet");
//    tabBarViewController.viewControllers = @[walletVC];
//
//    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarViewController;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)requestLogin {
    
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

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录请求失败");
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
    
    //首页
    WalletViewController *walletVC = [[WalletViewController alloc] init];
    walletVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Wallet" image:UIImageMake(@"wallet") tag:0];
    walletVC.tabBarItem.selectedImage = UIImageMake(@"wallet");
    QMUINavigationController *nav1 = [[QMUINavigationController alloc] initWithRootViewController:walletVC];
    
    //汇率
    ExchangeRateVC *exchangeVC = [[ExchangeRateVC alloc] initWithStyle:UITableViewStyleGrouped];
    exchangeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Rate" image:UIImageMake(@"wallet") tag:1];
    exchangeVC.tabBarItem.selectedImage = UIImageMake(@"wallet");
    QMUINavigationController *nav2 = [[QMUINavigationController alloc] initWithRootViewController:exchangeVC];
    
    tabBarViewController.viewControllers = @[nav1, nav2];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarViewController;
    
    
}

@end

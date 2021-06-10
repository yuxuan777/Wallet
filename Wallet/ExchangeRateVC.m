//
//  ExchangeRateVC.m
//  Wallet
//
//  Created by cuiyuxuan on 2021/6/9.
//

#import "ExchangeRateVC.h"
#import <AFNetworking/AFNetworking.h>
#import "User.h"
#import "ExchangeTableViewCell.h"
#import "ExchangeViewController.h"

@interface ExchangeRateVC () <QMUITableViewDelegate, QMUITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ExchangeRateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self request];
}

- (void)setupUI {
    self.title = @"汇率";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"兑换" style:UIBarButtonItemStylePlain target:self action:@selector(exchange)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    QMUILabel *label = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor grayColor]];
//    label.frame = CGRectMake(20, NavigationContentTop, SCREEN_WIDTH, 40);
//    label.text = @"每1元数字人民币货币预计可以兑换：";
//    [self.view addSubview:label];
    
//    self.tableView.frame = CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (UIColor *)titleViewTintColor {
    return [UIColor blackColor];
}

- (UIColor *)navigationBarTintColor {
    return [UIColor blackColor];
}

- (void)didInitializeWithStyle:(UITableViewStyle)style {
    [super didInitializeWithStyle:style];

//    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];


//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//    QMUILabel *label = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor grayColor]];
//    label.frame = CGRectMake(20, 0, SCREEN_WIDTH, 40);
//    label.text = @"每1元数字人民币货币预计可以兑换：";
//    [self.view addSubview:label];

//    self.tableView.frame = CGRectMake(0, NavigationContentTop + 40, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)exchange {
    ExchangeViewController *vc = [[ExchangeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)request {
    [self showEmptyViewWithLoading:YES image:nil text:@"加载中" detailText:nil buttonTitle: nil buttonAction:nil];

    User *user = [User sharedInstance];
    if (user.token.length <= 0) {
        return;
    }

    NSString *url = @"http://sz.zy.hn:8123/api/er";

    NSDictionary *params = @{@"token": user.token
    };

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.timeoutInterval = 60;
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

- (void)loginSuccess:(NSDictionary *)dict {
    NSDictionary *dataDic = dict[@"data"];

    //  {"status":"ok","msg":"","data":{"drmb":1,"eur":0.13,"rmb":1,"usd":0.16}}
    NSString *drmb = [NSString stringWithFormat:@"%@", dataDic[@"drmb"]];
    NSString *eur = [NSString stringWithFormat:@"%@", dataDic[@"eur"]];
    NSString *rmb = [NSString stringWithFormat:@"%@", dataDic[@"rmb"]];
    NSString *usd = [NSString stringWithFormat:@"%@", dataDic[@"usd"]];

    if (drmb.length > 0 && eur.length > 0 && rmb.length > 0 && usd.length > 0) {
        self.dataArray = @[@{@"name": @"EUR", @"value": eur, @"icon": @"b4"},
                           @{@"name": @"RMB", @"value": rmb, @"icon": @"b2"},
                           @{@"name": @"USD", @"value": usd, @"icon": @"b3"}];
    }
    [self.tableView reloadData];
}

#pragma mark - QMUITableViewDelegate, QMUITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-  (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeTableViewCell *cell = [[ExchangeTableViewCell alloc] initForTableView:self.tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.qmui_separatorInsetsBlock = ^UIEdgeInsets(__kindof UITableView * _Nonnull tableView, __kindof UITableViewCell * _Nonnull cell) {
        return QMUITableViewCellSeparatorInsetsNone;
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *dataDic = self.dataArray[indexPath.row];

    cell.icon = UIImageMake(dataDic[@"icon"]);
    cell.exchangeTitle = dataDic[@"name"];
    cell.detailTextLabel.text = dataDic[@"value"];
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"   每1元数字人民币货币预计可以兑换：";
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor qmui_colorWithHexString:@"ebebeb"];
    QMUILabel *label = [[QMUILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor grayColor]];
    label.frame = CGRectMake(20, 0, SCREEN_WIDTH, view.frame.size.height);
    label.text = @"每1元数字人民币货币预计可以兑换：";
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{//Grouped风格下底部留白
//    return 0.0001;
//}

@end

//
//  ExchangeRateVC.m
//  Wallet
//
//  Created by cuiyuxuan on 2021/6/9.
//

#import "ExchangeRateVC.h"
#import <AFNetworking/AFNetworking.h>
#import "User.h"

@interface ExchangeRateVC () <QMUITableViewDelegate, QMUITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ExchangeRateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    
    [self setupUI];
    
    [self request];
}

- (void)setupData {
    self.dataArray = @[];
}

- (void)setupUI {
    self.title = @"汇率";
    
    
}

- (void)request {
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

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录请求失败");
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
        self.dataArray = @[@{@"name": @"eur", @"value": eur},
                           @{@"name": @"rmb", @"value": rmb},
                           @{@"name": @"usd", @"value": usd}];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    cell.textLabel.text =  dataDic[@"name"];
    cell.detailTextLabel.text = dataDic[@"value"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"计价货币：drmb";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

@end

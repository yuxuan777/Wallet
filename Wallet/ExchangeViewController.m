//
//  ExchangeViewController.m
//  Wallet
//
//  Created by SimonYHB on 2021/6/9.
//

#import "ExchangeViewController.h"
#import "QMUIKit.h"
@interface ExchangeViewController ()
@property (nonatomic, strong) QMUIButton *expBtn;
@property (nonatomic, strong) QMUIButton *exgBtn;
@property (nonatomic, strong) QMUITextField *expTF;
@property (nonatomic, strong) QMUITextField *exgTF;
@property (nonatomic, strong) QMUILabel *rateLabel;

@property (nonatomic, strong) NSArray *expArr;
@property (nonatomic, strong) NSArray *exgArr;
@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
    [_expBtn addTarget:self action:@selector(expBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_exgBtn addTarget:self action:@selector(exgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.expArr = @[@"DRMB",@"RMB",@"USD",@"EUR"];
    self.exgArr =  @[@"RMB",@"USD",@"EUR"];
    // Do any additional setup after loading the view.
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
        [self reloadRateLabel];
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
        [self reloadRateLabel];
        [aDialogViewController hide];
    };
    [dialogViewController show];
}
- (void)reloadRateLabel {
    NSString *exp = [self.expBtn titleForState:UIControlStateNormal];
    NSString *exg = [self.exgBtn titleForState:UIControlStateNormal];
    CGFloat rate = 1;
    self.rateLabel.text = [NSString stringWithFormat:@"当前汇率 1 %@ = %.2f %@",exp,rate,exg];
}
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat dynamicY = 40;
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
    _expTF.placeholder = @"转出数量";
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
    _exgTF.placeholder = @"收到数量";
    [self.view addSubview:_exgTF];
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
    
}
@end

//
//  TDRechargeViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/2/24.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDRechargeViewController.h"
#import <StoreKit/StoreKit.h>
#import "TDRechargeTableViewCell.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "CocoaLumberjack.h"
#import "SKProduct+LocalizedPrice.h"
#import "LoginStateManager.h"
#import "LoginManager.h"
#import "LoginHandler.h"

@interface TDRechargeViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate>
@property (nonatomic, strong) NSArray *productId;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSArray *productIdentifiers;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation TDRechargeViewController
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"充值";
    self.view.backgroundColor = TDViewBackgrouondColor;
    
    self.productIdentifiers = @[@"com.jwr.recharge5",@"com.jwr.recharge10",@"com.jwr.recharge60",@"com.jwr.recharge200",@"com.jwr.rechargevip"];
    [self.view addSubview:self.tableView];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.center = CGPointMake((kScreenWidth)/2, (kScreenHeight-64)/2);
    
    [self requestProductWithIdentifiers:self.productIdentifiers];
}


- (void)requestProductWithIdentifiers:(NSArray *)array {
    if (![SKPaymentQueue canMakePayments]) {
        return;
    }
    
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    NSSet *nsset = [NSSet setWithArray:array];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}


#pragma mark -SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    if([response.products count] == 0){
        [self.indicatorView stopAnimating];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:0.6];
        DDLogError(@"应用内购买商品为空");
        return;
    }
    
    SKProduct *(^QueryProduct)(NSString *identifier) = ^(NSString *identifier){
        
        for (SKProduct *product in response.products) {
            if ([product.productIdentifier isEqualToString:identifier]) {
                return product;
            }
        }
        return (SKProduct *)nil;
    };
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:response.products.count];
    
    for (NSString *identifier in self.productIdentifiers) {
        SKProduct *product = QueryProduct(identifier);
        if (product) {
            [array addObject:product];
        }
    }
    
    [self.indicatorView stopAnimating];
    
    self.products = array;
    [self.tableView reloadData];
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"购买" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    btn.frame = CGRectMake(12, 15, kScreenWidth-24, 44);
    btn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
    [btn addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:btn];
    self.tableView.tableFooterView = bottom;
    
    // 默认选择第一个
    if (self.isVipRecharge) {
        // vip 是最后一个
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(array.count-1) inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    DDLogError(@"加载苹果应用内购买失败 error=%@",error);
    [self.indicatorView stopAnimating];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载失败";
    [hud hide:YES afterDelay:0.6];
}

- (void)requestDidFinish:(SKRequest *)request{
}


- (void)donePressed:(id)sender {
    
    if (US.isLogIn == NO) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"购买钥匙" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *one = [UIAlertAction actionWithTitle:@"登录在购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            LoginViewController *login = [[LoginViewController alloc] init];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
        }];
        UIAlertAction *two = [UIAlertAction actionWithTitle:@"直接购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self buyKey];
        }];
        
        [alert addAction:one];
        [alert addAction:two];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self buyKey];
    }
}

- (void)buyKey {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (!indexPath) {
        return;
    }
    
    [self.indicatorView startAnimating];
    
    SKProduct *product = self.products[indexPath.row];
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark -SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions  {
    for(SKPaymentTransaction *tran in transactions){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                [self.indicatorView stopAnimating];
                [self verifyPurchaseWithPaymentTransaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                DDLogInfo(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:{
                DDLogInfo(@"已经购买过商品");
                
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                DDLogError(@"交易失败");
                [self.indicatorView stopAnimating];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"购买失败";
                [hud hide:YES afterDelay:0.6];
            }
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];
    
    __weak TDRechargeViewController *wself = self;
    
    BOOL isDebug = NO;
#ifdef DEBUG
    isDebug = YES;
#endif
    
    NSDictionary *para = @{@"receipt": receiptString,
                           @"debug": @(isDebug)};
    NetworkManager *ma = [[NetworkManager alloc] init];

    NSString *api = @"";
    if (US.isLogIn) {
        api = API_IAPVerify;
    } else {
        api = API_IAPGuesVerify;
    }
    
    [ma POST:api parameters:para completion:^(id data, NSError *error){
        [MBProgressHUD hideHUDForView:wself.view animated:YES];
        
        if (!error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.labelText = @"购买成功";
            hud.delegate = wself;
            [hud hide:YES afterDelay:0.5];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.labelText = @"购买失败";
            [hud hide:YES afterDelay:0.6];
        }
        
        if (US.isLogIn == NO) {
            NSString *accouont = data[@"user_name"];
            NSString *password = data[@"user_passwd"];
            
            [LoginHandler saveLoginAccountId:accouont password:password];
            [LoginManager checkLogin];
        }
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.products.count>0)?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.products count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 60, 20)];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
    label.text = @"充值数量";
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDRechargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDRechargeTableViewCellID"];

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;
    
    SKProduct *product = self.products[indexPath.row];
    NSString *productIdentifier = product.productIdentifier;
    NSAttributedString *attr  = [self attributedStringWithIdentifier:productIdentifier];
    
    if ([productIdentifier isEqualToString:@"com.jwr.recharge5"]) {
        cell.keyLabel.attributedText = attr;
        
    } else if ([productIdentifier isEqualToString:@"com.jwr.recharge10"]) {
        cell.keyLabel.attributedText = attr;
//        cell.amountLabel.text = @"￥50";
    } else if ([productIdentifier isEqualToString:@"com.jwr.recharge60"]) {
        cell.keyLabel.attributedText = attr;
//        cell.amountLabel.text = @"￥298";
    } else if ([productIdentifier isEqualToString:@"com.jwr.recharge200"]) {
        cell.keyLabel.attributedText = attr;
//        cell.amountLabel.text = @"￥998";
    } else if ([productIdentifier isEqualToString:@"com.jwr.rechargevip"]) {
        NSString *str = @"VIP（一次性解锁所有公司调研）";
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str
                                                                                   attributes:nil];
        [strAtt addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(3, 13)];
        cell.keyLabel.attributedText = strAtt;
        
//        cell.amountLabel.text = @"￥98";
    }
    
    cell.amountLabel.text = [NSString stringWithFormat:@"%@",product.localizedPrice];
    
    return cell;
}

- (NSMutableAttributedString *)attributedStringWithIdentifier:(NSString *)productIdentifier {
    NSString *str;
    if ([productIdentifier isEqualToString:@"com.jwr.recharge5"]) {
        str = @"钥匙  5";
    } else if ([productIdentifier isEqualToString:@"com.jwr.recharge10"]) {
        str = @"钥匙  10";
    } else if ([productIdentifier isEqualToString:@"com.jwr.recharge60"]) {
        str = @"钥匙  60";
    } else if ([productIdentifier isEqualToString:@"com.jwr.recharge200"]) {
        str = @"钥匙  200";
    } else {
        return nil;
    }
    
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str
                                                                               attributes:nil];
    NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch.bounds = CGRectMake(0, -4, 19, 22);
    attatch.image = [UIImage imageNamed:@"icon_key_small.png"];
    
    NSAttributedString *wait = [NSAttributedString attributedStringWithAttachment:attatch];
    NSRange range = [str rangeOfString:@"钥匙"];
    if (range.location != NSNotFound) {
        [strAtt replaceCharactersInRange:range withAttributedString:wait];
    }
    
    return strAtt;
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.backgroundColor = TDViewBackgrouondColor;
        
        UINib *nib = [UINib nibWithNibName:@"TDRechargeTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"TDRechargeTableViewCellID"];
    }
    
    return _tableView;
}
@end

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
#import "TDRechargeCollectionViewCell.h"


@interface TDRechargeViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MBProgressHUDDelegate>
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSArray *productIdentifiers;
@property (nonatomic, strong) UICollectionView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIButton *doneBtn;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.center = CGPointMake((kScreenWidth)/2, (kScreenHeight-64)/2);
    
    self.productIdentifiers = @[@"com.jwr.recharge5",@"com.jwr.recharge10",@"com.jwr.recharge60",@"com.jwr.recharge200"];
    [self requestProductWithIdentifiers:self.productIdentifiers];
}


- (void)requestProductWithIdentifiers:(NSArray *)array {
    if (![SKPaymentQueue canMakePayments]) {
        return;
    }
    
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    __weak TDRechargeViewController *wself = self;
    
    NSSet *nsset = [NSSet setWithArray:array];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = wself;
    [request start];
}


#pragma mark -SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    if([response.products count] == 0){
        [self.indicatorView stopAnimating];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"加载失败";
        [hud hideAnimated:YES afterDelay:0.6];
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
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-64, kScreenWidth, 64)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"购买" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightMedium];
    btn.frame = CGRectMake(12, 0, kScreenWidth-24, 44);
    btn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"];
    [btn addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:btn];
    [self.view addSubview:bottom];
    self.doneBtn = btn;
    
    [self.tableView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.tableView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    DDLogError(@"加载苹果应用内购买失败 error=%@",error);
    [self.indicatorView stopAnimating];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载失败";
    [hud hideAnimated:YES afterDelay:0.6];
}

- (void)requestDidFinish:(SKRequest *)request{
}


- (void)donePressed:(id)sender {
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    NSIndexPath *indexPath = self.tableView.indexPathsForSelectedItems.firstObject;
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
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [self verifyPurchaseWithPaymentTransaction];
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
                hud.label.text = @"购买失败";
                [hud hideAnimated:YES afterDelay:0.6];
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

    
    [ma POST:API_IAPVerify parameters:para completion:^(id data, NSError *error){
        [MBProgressHUD hideHUDForView:wself.view animated:YES];
        
        if (!error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.label.text = @"购买成功";
            hud.delegate = wself;
            [hud hideAnimated:YES afterDelay:0.5];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.label.text = @"购买失败";
            [hud hideAnimated:YES afterDelay:0.6];
        }
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.products.count?1:0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TDRechargeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TDRechargeCollectionViewCellID" forIndexPath:indexPath];
    
    SKProduct *product = self.products[indexPath.row];
    cell.titleLabel.text = product.localizedTitle;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",product.price];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TDRechargeSectionHeader" forIndexPath:indexPath];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 36, kScreenWidth, TDPixel)];
        sep.backgroundColor = TDSeparatorColor;
        [headerView addSubview:sep];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 200, 16)];
        label.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightMedium];
        label.textColor = TDLightGrayColor;
        label.text = [NSString stringWithFormat:@"充值账号：%@", US.userPhone];
        [headerView addSubview:label];
        
        return headerView;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SKProduct *product = self.products[indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"立即支付(%@元)", product.price];
    [self.doneBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Getter
- (UICollectionView *)tableView {
    if (!_tableView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 18.0f;
        layout.minimumInteritemSpacing = 15.0f;
        layout.sectionInset = UIEdgeInsetsMake(17, 15, 17, 15);
        layout.itemSize = CGSizeMake((kScreenWidth-60)/3, 80);
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, 36);
        
        _tableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-64) collectionViewLayout:layout];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];

        UINib *nib = [UINib nibWithNibName:@"TDRechargeCollectionViewCell" bundle:nil];
        [_tableView registerNib:nib forCellWithReuseIdentifier:@"TDRechargeCollectionViewCellID"];
        [_tableView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TDRechargeSectionHeader"];
    }
    
    return _tableView;
}
@end

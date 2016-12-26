//
//  StockMarketViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockMarketViewController.h"
#import "HexColors.h"
#import "UIImage+Color.h"
#import "NetworkManager.h"
#import "StockMarketModel.h"
#import "StockMarketComparisonView.h"
#import "UIButton+WebCache.h"
#import "RechargeView.h"
#import "SelWXOrAlipayView.h"
#import "LoginViewController.h"
#import "KeysExchangeViewController.h"

#import "LoginState.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"

@interface StockMarketViewController ()<RechargeViewDelegate,SelWXOrAlipayViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockTypeLabel;
@property (weak, nonatomic) IBOutlet StockMarketComparisonView *comparison;
@property (weak, nonatomic) IBOutlet UILabel *kanzhangLabel;
@property (weak, nonatomic) IBOutlet UILabel *kandieLabel;
@property (weak, nonatomic) IBOutlet UIButton *expressBtn;
@property (weak, nonatomic) IBOutlet UILabel *keyNumberLabel;

@property (nonatomic,strong) RechargeView *rechargeView;      //充值页面

@property (nonatomic,strong) SelWXOrAlipayView *payView;      //选择支付页面

@property (nonatomic,strong) NSString *keysNum;

@property (nonatomic, strong) StockMarketModel *stockMarket;
@end

@implementation StockMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.topView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.topView.layer.shadowOpacity = 0.24f;
    self.topView.layer.shadowOffset = CGSizeMake(0, 1);
    
    // 用户头像
    self.avatarBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarBtn.imageView.layer.cornerRadius = 15.0f;
    self.avatarBtn.imageView.clipsToBounds = YES;
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nav_unLoginAvatar.png"]];
    
    // 背景颜色渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor hx_colorWithHexRGBAString:@"fbae34"].CGColor,(__bridge id)[UIColor hx_colorWithHexRGBAString:@"f57618"].CGColor];
    gradientLayer.locations = @[@(0.47),@(0.83)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 40, kScreenWidth, kScreenHeight-154);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    if (self.stockType == kStockTypeSZ) {
        self.stockTypeLabel.text = @"上证指数猜涨跌";
    } else {
        self.stockTypeLabel.text = @"创业板指数猜涨跌";
    }
        
    [self requestUserKeysNum];
//    [self queryStockMarket];
}


- (void)requestUserKeysNum{

    if (US.isLogIn) {
        NSDictionary *para = @{@"user_id":US.userId};
        NetworkManager *ma = [[NetworkManager alloc] initWithBaseUrl:kAPI_songsong];
        [ma POST:API_QueryKeyNumber parameters:para completion:^(id data, NSError *error){
            if (!error) {
                long keyNumber = [data[@"keyNum"] longValue];
                self.keyNumberLabel.text = [NSString stringWithFormat:@"%ld",keyNumber];
            }
            else
            {
                //
            }
        }];
    }
    
    
}

- (void)queryStockMarket {
    
    NSString *type = @"";
    switch (self.stockType) {
        case kStockTypeSZ:
            type = @"sz";
            break;
        case kStockTypeCY:
            type = @"cy";
            break;
        default:
            break;
    }
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"block": type};
    if (US.isLogIn) {
        NSAssert(US.userId, @"用户Id不能为空");
        dict = @{@"block": type,@"user_id": US.userId};
    }
    
    [ma GET:API_GetGuessIndex parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            StockMarketModel *model = [[StockMarketModel alloc] initWithDictionary:data];
            self.stockMarket = model;
            [self reloadView];
        }
    }];
}

- (void)reloadView {
    
    self.kanzhangLabel.text = [NSString stringWithFormat:@"%.0lf%%",self.stockMarket.upPre];
    self.kandieLabel.text = [NSString stringWithFormat:@"%.0lf%%",(1-self.stockMarket.upPre)];
    self.comparison.kandie = 1-self.stockMarket.upPre/100;
}

#pragma mark - 弹出充值页面
- (IBAction)clickTopUp:(UIButton *)sender {
    self.rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.rechargeView.delegate = self;
    [self.view addSubview:self.rechargeView];
}

#pragma mark - 关闭页面
- (void)closeRechargeView:(UIButton *)sender
{
    [self.rechargeView removeFromSuperview];
}

- (void)closeSelWXOrAlipayView:(UIButton *)sender
{
    [self.payView removeFromSuperview];
}

#pragma mark - 选择数量
- (void)clickRecharge:(UIButton *)sender
{
    if (sender.tag == 0) {
        self.keysNum = @"1";
    }
    else if (sender.tag == 1){
        self.keysNum = @"5";
    }
    else if (sender.tag == 2){
        self.keysNum = @"10";
    }
    else
    {
        self.keysNum = @"VIP";
    }
    //进入选择付款页面
    [self.rechargeView removeFromSuperview];
    self.payView = [[SelWXOrAlipayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.payView.delegate = self;
    [self.view addSubview:self.payView];
}

- (IBAction)clickExchange:(UIButton *)sender {
    if (US.isLogIn) {
        //进入钥匙兑换页
        KeysExchangeViewController *keysExchange = [[KeysExchangeViewController alloc] init];
        [self.navigationController pushViewController:keysExchange animated:YES];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

#pragma mark - 支付宝或者微信
- (void)didSelectWXOrZhifubao:(NSIndexPath *)indePath
{
    if (indePath.row == 0) { //支付宝支付
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 设置请求接口回来的时候支持什么类型的数据
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        NSDictionary *dic;
        if (![self.keysNum isEqualToString:@"VIP"]) {
            dic = @{@"type":@"1",
                    @"number":self.keysNum,
                    @"version":@"1.0",
                    @"user_id":US.userId};
        }
        else
        {
            dic = @{@"type":@"2",   //type = 2 表示充值VIP
                    @"number":@"1",
                    @"version":@"1.0",
                    @"user_id":US.userId};
        }
        
        NSString *url = [NSString stringWithFormat:@"%@Survey/alipayKey",API_HOST];
        
        [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            nil;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = responseObject;
            NSString *orderString = dic[@"data"];
            NSString *appScheme = @"TDjuwairen";
            
            [self.payView removeFromSuperview];
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    else    //微信支付
    {
        NSString *urlString   = [NSString stringWithFormat:@"%@Survey/wxpayKey",API_HOST];
        NSDictionary *dic;
        if (![self.keysNum isEqualToString:@"VIP"]) {
            dic = @{@"type":@"1",
                    @"number":self.keysNum,
                    @"user_id":US.userId,
                    @"device":@"1"};
        }
        else
        {
            dic = @{@"type":@"2",
                    @"number":@"1",
                    @"user_id":US.userId,
                    @"device":@"1"};
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        [manager POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            nil;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = responseObject;
            NSString *str = dic[@"data"];
            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *order = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&err];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID = [order objectForKey:@"appid"];
            req.partnerId           = [order objectForKey:@"mch_id"];
            req.prepayId            = [order objectForKey:@"prepay_id"];
            req.nonceStr            = [order objectForKey:@"nonce_str"];
            req.timeStamp           = [[order objectForKey:@"timestamp"] intValue];
            req.package             = @"Sign=WXPay";
            req.sign                = [order objectForKey:@"sign"];
            
            [self.payView removeFromSuperview];
            
            [WXApi sendReq:req];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}
@end

//
//  PaySuccessViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#define redColor [HXColor hx_colorWithHexRGBAString:@"#F30B25"]

#import "PaySuccessViewController.h"
#import "MyOrderViewController.h"
#import "RechargeView.h"
#import "SelWXOrAlipayView.h"

#import "UIdaynightModel.h"
#import "LoginState.h"
#import "NetworkDefine.h"
#import "Masonry.h"
#import "HexColors.h"
#import "AFNetworking.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"

@interface PaySuccessViewController ()<RechargeViewDelegate,SelWXOrAlipayViewDelegate>

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UIImageView *sucImg;

@property (nonatomic,strong) UILabel *sucLab;

@property (nonatomic,strong) UIButton *seeBtn;

@property (nonatomic,strong) UIButton *goonBtn;

@property (nonatomic, copy) NSString *keysNum;

@property (nonatomic,strong) RechargeView *rechargeView;

@property (nonatomic,strong) SelWXOrAlipayView *payView;
@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    
    [self setupWithNavigation];
    [self setupWithSuccessView];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    self.title = @"支付成功";
}

- (void)setupWithSuccessView{
    self.view.backgroundColor = self.daynightModel.backColor;
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 500)];
    self.backView.backgroundColor = self.daynightModel.navigationColor;
    [self.view addSubview:self.backView];
    
    self.sucImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, 30, 100, 100)];
    self.sucImg.layer.cornerRadius = 50;
    self.sucImg.image = [UIImage imageNamed:@"btn_chongzhichenggong"];
    [self.backView addSubview:self.sucImg];
    
    self.sucLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth, 30)];
    self.sucLab.text = @"恭喜您，充值成功";
    self.sucLab.font = [UIFont systemFontOfSize:18];
    self.sucLab.textAlignment = NSTextAlignmentCenter;
    self.sucLab.textColor = self.daynightModel.textColor;
    [self.backView addSubview:self.sucLab];
    
    CGFloat seeleft = kScreenWidth/2 - 140 - 10;
    CGFloat goonleft = kScreenWidth/2 - seeleft -140;
    self.seeBtn = [[UIButton alloc] initWithFrame:CGRectMake(seeleft, 210, 140, 40)];
    [self.seeBtn setTitleColor:redColor forState:UIControlStateNormal];
    [self.seeBtn setTitle:@"查看充值记录" forState:UIControlStateNormal];
    self.seeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.seeBtn.layer.borderWidth = 1;
    self.seeBtn.layer.borderColor = redColor.CGColor;
    self.seeBtn.layer.cornerRadius = 10;
    self.seeBtn.backgroundColor = [UIColor whiteColor];
    [self.seeBtn addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.seeBtn];

    self.goonBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2 + goonleft, 210, 140, 40)];
    [self.goonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.goonBtn setTitle:@"继续充值" forState:UIControlStateNormal];
    self.goonBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.goonBtn.layer.borderWidth = 1;
    self.goonBtn.layer.borderColor = redColor.CGColor;
    self.goonBtn.layer.cornerRadius = 10;
    self.goonBtn.backgroundColor = redColor;
    [self.goonBtn addTarget:self action:@selector(goon:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.goonBtn];
}

- (void)go:(UIButton *)sender{
    MyOrderViewController *order = [[MyOrderViewController alloc] init];
    [self.navigationController pushViewController:order animated:YES];
}

- (void)goon:(UIButton *)sender{
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

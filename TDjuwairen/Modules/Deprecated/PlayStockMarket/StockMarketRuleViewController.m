//
//  StockMarketRuleViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/19.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockMarketRuleViewController.h"
#import "HexColors.h"
/*
 
 1.用户通过充值2元可以参与竞猜上证指数和
 创业板指数相对前一个交易日涨跌结果。
 
 2.竞猜对象:
 上证指数或创业板指数的收盘指数。
 竞猜规则:
 当天交易日15:00收盘点数> 前一个交易日
 的15:00收盘点数，押红方获得1把钥匙。
 当天交易日15:00收盘点数＝前一个交易日
 的15:00收盘点数   押红或绿方都获得1把
 钥匙。
 当天交易日15:00收盘点数< 前一个交易日
 的15:00收盘点数，押绿方获得1把钥匙。
 
 3.每个用户一天只能各参与一次上证指数和
 创业板指数的竞猜。参与当天的猜红绿，必
 须是前一交易日的15：00至当天9：30前参
 与，其它时间无效。
 */
@interface StockMarketRuleViewController ()

@end

@implementation StockMarketRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 背景颜色渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor hx_colorWithHexRGBAString:@"fbae34"].CGColor,(__bridge id)[UIColor hx_colorWithHexRGBAString:@"f57618"].CGColor];
    gradientLayer.locations = @[@(0.47),@(0.83)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-114);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    UIImage *topImage = [UIImage imageNamed:@"bg_youxiguize.png"];
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:topImage];
    topImageView.contentMode = UIViewContentModeCenter;
    topImageView.frame = CGRectMake((kScreenWidth - topImage.size.width)/2, 20, topImage.size.width, topImage.size.height);
    [self.view addSubview:topImageView];
    
    UIImage *bgImage = [UIImage imageNamed:@"bg_hangqing.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(15, 117, kScreenWidth-30, kScreenHeight-64-117-50-35);
    [self.view insertSubview:bgImageView belowSubview:topImageView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(30, 157, kScreenWidth-60, kScreenHeight-64-157-20-50-35)];
    textView.text = @"1.用户通过充值2元可以参与竞猜上证指数和\r\n创业板指数相对前一个交易日涨跌结果。\r\n\r\n2.竞猜对象:\r\n上证指数或创业板指数的收盘指数。\r\n竞猜规则:\r\n当天交易日15:00收盘点数> 前一个交易日的15:00收盘点数，押红方获得1把钥匙。\r\n当天交易日15:00收盘点数＝前一个交易日的15:00收盘点数   押红或绿方都获得1把钥匙。\r\n当天交易日15:00收盘点数< 前一个交易日的15:00收盘点数，押绿方获得1把钥匙。\r\n\r\n3.每个用户一天只能各参与一次上证指数和创业板指数的竞猜。参与当天的猜红绿，必须是前一交易日的15：00至当天9：30前参与，其它时间无效。";
    textView.font = [UIFont boldSystemFontOfSize:15.0f];
    textView.textColor = [UIColor hx_colorWithHexRGBAString:@"#C26F09"];
    textView.editable = NO;
    textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textView];
}


@end

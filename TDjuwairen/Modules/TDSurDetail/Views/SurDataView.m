//
//  SurDataView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurDataView.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "NSString+Ext.h"
#import "NSString+GetDevice.h"
#import "UIdaynightModel.h"

@interface SurDataView ()

@property (nonatomic,strong) NSDictionary *data;

@end

@implementation SurDataView

- (SurDataView *)initWithFrame:(CGRect)frame WithStockID:(NSString *)StockID
{
    if (self = [super initWithFrame:frame]) {
        [self requestWithDataWithStockID:StockID];
    }
    return self;
}

- (void)requestWithDataWithStockID:(NSString *)StockID{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    NSString *url = [NSString stringWithFormat:@"http://web.juhe.cn:8080/finance/stock/hs?gid=%@&type=&key=84fbc17aeef934baa37526dd3f57b841",StockID];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *result = dic[@"result"];
        if (result.count > 0) {
            NSDictionary *diction = result[0];
            self.data = diction[@"data"];
            
            //传标题
            if (self.block) {
                NSDictionary *dapandata = diction[@"dapandata"];
                NSDictionary *dataDic= diction[@"data"];
                NSString *code = [dataDic[@"gid"] substringFromIndex:2];
                NSString *title = [NSString stringWithFormat:@"%@(%@)",dapandata[@"name"],code];
                self.block(title,dataDic[@"gid"]);
            }
            
            [self setupWithUI];
        }
        else
        {
            [self setupWithUI];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)setupWithUI{
    self.nowPri = [[UILabel alloc] init];
    UIFont *nowPriFont = [UIFont boldSystemFontOfSize:38];
    self.nowPri.font = nowPriFont;
    
    self.increase = [[UILabel alloc] init];
    self.increase.font = [UIFont systemFontOfSize:15];
    
    self.increPer = [[UILabel alloc] init];
    self.increPer.font = [UIFont systemFontOfSize:15];
    
    UIFont *font;
    NSString *speed;
    NSString *deviceType = [NSString getiPHoneDeviceType];
    if ([deviceType isEqualToString:@"1"]) {
        font = [UIFont systemFontOfSize:14];
        speed = @" ";
    }
    else
    {
        font = [UIFont systemFontOfSize:16];
        speed = @"  ";
    }
    
    self.yestodEndPri = [[UILabel alloc] init];
    self.yestodEndPri.font = font;
    
    self.todayStartPri = [[UILabel alloc] init];
    self.todayStartPri.font = font;
    
    self.todayMax = [[UILabel alloc] init];
    self.todayMax.font = font;
    
    self.todayMin = [[UILabel alloc] init];
    self.todayMin.font = font;
    
    self.traNumber = [[UILabel alloc] init];
    self.traNumber.font = font;
    
    self.traAmount = [[UILabel alloc] init];
    self.traAmount.font = font;
    
    [self addSubview:self.nowPri];
    [self addSubview:self.increase];
    [self addSubview:self.increPer];
    [self addSubview:self.yestodEndPri];
    [self addSubview:self.todayStartPri];
    [self addSubview:self.todayMax];
    [self addSubview:self.todayMin];
    [self addSubview:self.traNumber];
    [self addSubview:self.traAmount];
    
    if ([self.data[@"increPer"] floatValue] > 0) {
        self.nowPri.textColor = [UIColor redColor];
        self.increPer.textColor = [UIColor redColor];
        self.increase.textColor = [UIColor redColor];
    }
    else if([self.data[@"increPer"] floatValue] < 0){
        self.nowPri.textColor = [UIColor greenColor];
        self.increPer.textColor = [UIColor greenColor];
        self.increase.textColor = [UIColor greenColor];
    }
    else
    {
        self.nowPri.textColor = [UIColor grayColor];
        self.increPer.textColor = [UIColor grayColor];
        self.increase.textColor = [UIColor grayColor];
    }
    
    NSString *nowPri = [NSString stringWithFormat:@"%.2f",[self.data[@"nowPri"] floatValue]];
    CGSize nowPriSize = [nowPri calculateSize:CGSizeMake(200, 100) font:nowPriFont];
    self.nowPri.text = nowPri;
    [self.nowPri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(15);
        make.left.equalTo(self).with.offset(15);
        make.width.mas_equalTo(nowPriSize.width+10);
        make.height.mas_equalTo(40);
    }];
    
    if (self.data[@"increase"]) {
        self.increase.text = self.data[@"increase"];
    }
    else
    {
        self.increase.text = @"0.00";
    }
    [self.increase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(15);
        make.left.equalTo(self.nowPri.mas_right).with.offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    if (self.data[@"increPer"]) {
        self.increPer.text = [NSString stringWithFormat:@"%@%@",self.data[@"increPer"],@"%"];
    }
    else
    {
        self.increPer.text = @"0.00";
    }
    [self.increPer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.increase).with.offset(20);
        make.left.equalTo(self.nowPri.mas_right).with.offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    NSString *yestodEndPri = [NSString stringWithFormat:@"昨收%@%.2f",speed,[self.data[@"yestodEndPri"] floatValue]];
    CGSize yesSize = [yestodEndPri calculateSize:CGSizeMake(100, 100) font:font];
    self.yestodEndPri.text = yestodEndPri;
    [self.yestodEndPri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nowPri).with.offset(15+40);
        make.left.equalTo(self).with.offset(15);
        make.width.mas_equalTo(yesSize.width);
        make.height.mas_equalTo(20);
    }];
    
    NSString *todayStartPri = [NSString stringWithFormat:@"今开%@%.2f",speed,[self.data[@"todayStartPri"] floatValue]];
    CGSize todSize = [todayStartPri calculateSize:CGSizeMake(100, 100) font:font];
    self.todayStartPri.text = todayStartPri;
    [self.todayStartPri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yestodEndPri).with.offset(15+20);
        make.left.equalTo(self).with.offset(15);
        make.bottom.equalTo(self).with.offset(-15);
        make.width.mas_equalTo(todSize.width);
        make.height.mas_equalTo(20);
    }];
    
    NSString *todayMax = [NSString stringWithFormat:@"最高%@%.2f",speed,[self.data[@"todayMax"] floatValue]];
    CGSize MaxSize = [todayMax calculateSize:CGSizeMake(100, 100) font:font];
    self.todayMax.text = todayMax;
    [self.todayMax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nowPri).with.offset(15+40);
        make.left.equalTo(self.yestodEndPri).with.offset(15+yesSize.width);
        make.width.mas_equalTo(MaxSize.width);
        make.height.mas_equalTo(20);
    }];
    
    NSString *todayMin = [NSString stringWithFormat:@"最低%@%.2f",speed,[self.data[@"todayMin"] floatValue]];
    CGSize MinSize = [todayMin calculateSize:CGSizeMake(100, 100) font:font];
    self.todayMin.text = todayMin;
    [self.todayMin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.todayMax).with.offset(15+20);
        make.left.equalTo(self.todayMax).with.offset(0);
        make.width.mas_equalTo(MinSize.width);
        make.height.mas_equalTo(20);
    }];
    
    NSString *traNumber = [NSString stringWithFormat:@"成交量%@%.4lf万股",speed,[self.data[@"traNumber"] doubleValue] / 10000];
    self.traNumber.text = traNumber;
    [self.traNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nowPri).with.offset(15+40);
        make.left.equalTo(self.todayMax).with.offset(15+MaxSize.width);
        make.right.equalTo(self).with.offset(-5);
        make.height.mas_equalTo(20);
    }];
    
    NSString *traAmount = [NSString stringWithFormat:@"成交额%@%.2lf万",speed,[self.data[@"traAmount"] doubleValue] / 10000];
    self.traAmount.text = traAmount;
    [self.traAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.traNumber).with.offset(15+20);
        make.left.equalTo(self.traNumber).with.offset(0);
        make.right.equalTo(self).with.offset(-5);
        make.height.mas_equalTo(20);
    }];
    
}

- (void)setupWithStock:(StockInfo *)stock
{
    float yestodEndPri = [[NSDecimalNumber decimalNumberWithString:stock.yestodEndPri] floatValue];
    float nowPri = [[NSDecimalNumber decimalNumberWithString:stock.nowPri] floatValue];
    
    float value = nowPri - yestodEndPri;   //跌涨额
    float valueB = value/yestodEndPri;     //跌涨百分比

    self.nowPri.text = [NSString stringWithFormat:@"%.2lf",nowPri];
    
    self.increase.text = [NSString stringWithFormat:@"%.2f",value];
    
    self.increPer.text = [NSString stringWithFormat:@"%.2f%%",valueB*100];
    
    if (value > 0) {
        self.nowPri.textColor = [UIColor redColor];
        self.increPer.textColor = [UIColor redColor];
        self.increase.textColor = [UIColor redColor];
    }
    else if(value < 0){
        self.nowPri.textColor = [UIColor greenColor];
        self.increPer.textColor = [UIColor greenColor];
        self.increase.textColor = [UIColor greenColor];
    }
    else
    {
        self.nowPri.textColor = [UIColor grayColor];
        self.increPer.textColor = [UIColor grayColor];
        self.increase.textColor = [UIColor grayColor];
    }
    UIFont *font;
    NSString *speed;
    NSString *deviceType = [NSString getiPHoneDeviceType];
    if ([deviceType isEqualToString:@"1"]) {
        font = [UIFont systemFontOfSize:14];
        speed = @" ";
    }
    else
    {
        font = [UIFont systemFontOfSize:16];
        speed = @"  ";
    }
    NSString *yestod = [NSString stringWithFormat:@"昨收%@%.2f",speed,[stock.yestodEndPri floatValue]];
    self.yestodEndPri.text = yestod;
    self.yestodEndPri.font = font;
    
    NSString *todayStartPri = [NSString stringWithFormat:@"今开%@%.2f",speed,[stock.todayStartPri floatValue]];
    self.todayStartPri.text = todayStartPri;
    self.todayStartPri.font = font;
    
    NSString *todayMax = [NSString stringWithFormat:@"最高%@%.2f",speed,[stock.todayMax floatValue]];
    self.todayMax.text = todayMax;
    self.todayMax.font = font;
    
    NSString *todayMin = [NSString stringWithFormat:@"最低%@%.2f",speed,[stock.todayMin floatValue]];
    self.todayMin.text = todayMin;
    self.todayMin.font = font;
    
    NSString *traNumber = [NSString stringWithFormat:@"成交量%@%.4lf万股",speed,[stock.traNumber doubleValue] / 10000];
    self.traNumber.text = traNumber;
    self.traNumber.font = font;
    
    NSString *traAmount = [NSString stringWithFormat:@"成交额%@%.2lf万元",speed,[stock.traAmount doubleValue] / 10000];
    self.traAmount.text = traAmount;
    self.traAmount.font = font;
    
}


@end

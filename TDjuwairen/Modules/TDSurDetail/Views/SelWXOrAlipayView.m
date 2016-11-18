//
//  SelWXOrAlipayView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SelWXOrAlipayView.h"

#import "UIdaynightModel.h"
#import "Masonry.h"

@interface SelWXOrAlipayView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) NSArray *imgArr;

@property (nonatomic,strong) NSArray *titArr;

@property (nonatomic,strong) NSArray *subArr;

@end

@implementation SelWXOrAlipayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.daynightModel = [UIdaynightModel sharedInstance];
        self.imgArr = @[@"icon_zhifubao",@"icon_weixinzhifu"];
        self.titArr = @[@"支付宝支付",@"微信支付"];
        self.subArr = @[@"推荐支付宝用户使用",@"微信客户端安全支付"];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = 0.5;
        
        
        self.showView = [[UIView alloc] init];
        self.showView.backgroundColor = self.daynightModel.navigationColor;
        self.showView.layer.cornerRadius = 10;
        self.showView.clipsToBounds = YES;
        
        UIButton *close = [[UIButton alloc] init];
        [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(closeSelWXOrAlipayView:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *rechargeLabl = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frame.size.width, 30)];
        rechargeLabl.text = @"选择充值方式";
        rechargeLabl.textColor = self.daynightModel.textColor;
        rechargeLabl.textAlignment = NSTextAlignmentCenter;
        rechargeLabl.font = [UIFont systemFontOfSize:22];
        
        UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, 150) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.estimatedRowHeight = 75;
        tableview.rowHeight = UITableViewAutomaticDimension;
        
        [self addSubview:self.backView];
        [self addSubview:self.showView];
        [self addSubview:close];
        [self.showView addSubview:rechargeLabl];
        [self.showView addSubview:tableview];
        
        
        [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(50);
            make.right.equalTo(self).with.offset(-50);
            make.height.mas_equalTo(210);
        }];
        
        [rechargeLabl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.showView);
            make.top.equalTo(self.showView).with.offset(15);
            make.width.mas_equalTo(self.showView.mas_width);
            make.height.mas_equalTo(30);
        }];
        
        [close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.showView);
            make.top.equalTo(self.showView.mas_bottom).with.offset(30);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rechargeLabl.mas_bottom).with.offset(15);
            make.left.equalTo(self.showView).with.offset(0);
            make.right.equalTo(self.showView).with.offset(0);
            make.bottom.equalTo(self.showView).with.offset(0);
        }];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.imageView.image = [UIImage imageNamed:self.imgArr[indexPath.row]];
    cell.textLabel.text = self.titArr[indexPath.row];
    cell.textLabel.textColor = self.daynightModel.textColor;
    cell.detailTextLabel.text = self.subArr[indexPath.row];
    cell.detailTextLabel.textColor = self.daynightModel.titleColor;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectWXOrZhifubao:)]) {
        [self.delegate didSelectWXOrZhifubao:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)closeSelWXOrAlipayView:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(closeSelWXOrAlipayView:)]) {
        [self.delegate closeSelWXOrAlipayView:sender];
    }
}

@end

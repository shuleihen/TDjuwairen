//
//  NMView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "NMView.h"
#import "UIdaynightModel.h"

@interface NMView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *imgArr;

@property (nonatomic,strong) NSArray *titArr;

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@end

@implementation NMView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.daynightModel = [UIdaynightModel sharedInstance];
        
        NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
        NSString *daynight = [userdefalut objectForKey:@"daynight"];
        NSString *mod ;//模式
        NSString *img ;//图片
        if ([daynight isEqualToString:@"yes"]) {
            mod = @"夜间模式";
            img = @"btn_yejian.png";
        }
        else
        {
            mod = @"日间模式";
            img = @"btn_night_rijian.png";
        }
        self.imgArr = @[img,@"btn_ziti.png",@"iconfont-fenxiang",@"btn_fankui"];
        self.titArr = @[mod,@"字体大小",@"分享",@"反馈"];
        
        self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 176) style:UITableViewStylePlain];
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        [self addSubview:self.tableview];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.imageView.image = [UIImage imageNamed:self.imgArr[indexPath.row]];
    cell.textLabel.text = self.titArr[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundColor = self.daynightModel.navigationColor;
    cell.textLabel.textColor = self.daynightModel.textColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        if ([cell.textLabel.text isEqualToString:@"日间模式"]) {
            cell.imageView.image = [UIImage imageNamed:@"btn_yejian@3x.png"];
            cell.textLabel.text = @"夜间模式";
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"btn_night_rijian@3x.png"];
            cell.textLabel.text = @"日间模式";
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectWithNMViewTableView:andIndexPath:)]) {
        [self.delegate selectWithNMViewTableView:tableView andIndexPath:indexPath];
    }
}

@end

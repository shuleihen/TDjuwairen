//
//  NaviMoreView.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "NaviMoreView.h"
#import "UIdaynightModel.h"

@interface NaviMoreView ()

@property (nonatomic,strong) UIdaynightModel *model;
@property (nonatomic,strong) UITableViewCell *selectCell;
@end

@implementation NaviMoreView

- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)iscollect
{
    if (self = [super initWithFrame:frame]) {
        self.model = [UIdaynightModel sharedInstance];
        
        NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
        NSString *daynight = [userdefalut objectForKey:@"daynight"];
        NSString *mod ;//模式
        NSString *img ;//图片
        NSString *coll;//收藏
        NSString *colImg;
        if ([daynight isEqualToString:@"yes"]) {
            mod = @"夜间模式";
            img = @"btn_yejian.png";
        }
        else
        {
            mod = @"日间模式";
            img = @"btn_night_rijian.png";
        }
        if ([iscollect isEqualToString:@"yes"]) {
            coll = @"取消收藏";
            colImg = @"btn_col_pre.png";
        }
        else
        {
            coll = @"收藏";
            colImg = @"btn_col.png";
        }
        
        self.imgArr = @[@"btn_fuzhi.png",colImg,@"btn_ziti.png",img,@"btn_jubao.png"];
        self.titleArr = @[@"复制链接",coll,@"字体大小",mod,@"举报"];
        
        
        [self setupWithViewShadow];
        [self setupWithTableView];
    }
    return self;
}

- (void)setupWithViewShadow{
    self.backgroundColor = [UIColor whiteColor];
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, self.frame.size.height) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableview];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.imageView.image = [UIImage imageNamed:self.imgArr[indexPath.row]];
        cell.textLabel.text = self.titleArr[indexPath.row];
    }
    cell.textLabel.textColor = self.model.titleColor;
    cell.backgroundColor = self.model.navigationColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* 取消选中状态 */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 3) {
        
        if ([cell.textLabel.text isEqualToString:@"日间模式"]) {
            cell.imageView.image = [UIImage imageNamed:@"btn_yejian@3x.png"];
            cell.textLabel.text = @"夜间模式";
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"btn_night_rijian@3x.png"];
            cell.textLabel.text = @"日间模式";
        }
        [tableView reloadData];
    }
    
    if ([self respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate didSelectedWithIndexPath:cell];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height/5;
}

@end

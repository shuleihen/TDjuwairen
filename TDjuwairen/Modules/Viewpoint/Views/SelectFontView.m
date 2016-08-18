//
//  SelectFontView.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SelectFontView.h"
#import "YXFont.h"

@interface SelectFontView ()
@property (nonatomic,strong) UITableViewCell *selectcell;
@end

@implementation SelectFontView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        self.fontArr = @[@19,@18,@17,@16];
        self.titleArr = @[@"特大字号",@"大字号",@"中字号",@"小字号"];
        [self create];
        
        [self setupWithViewShadow];
    }
    return self;
}

- (void)create{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, self.frame.size.width-30, 20)];
    label.text = @"正文字号";
    label.font = [UIFont systemFontOfSize:20];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(15, 15+20+15, self.frame.size.width-30, self.frame.size.height-70-50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = NO;
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-70, self.frame.size.height-55, 40, 30)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSure:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-140, self.frame.size.height-55, 40, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:label];
    [self addSubview:self.tableview];
    [self addSubview:sureBtn];
    [self addSubview:cancelBtn];
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"btn_select2@3x.png"];
    cell.textLabel.text = self.titleArr[indexPath.row];
    CGFloat flo = [self.fontArr[indexPath.row] floatValue];
    cell.textLabel.font = [YXFont lightFontSize:flo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* 取消选中状态 */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectcell.imageView.image = [UIImage imageNamed:@"btn_select2@3x.png"];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"btn_select2_pre@3x.png"];
    
    self.selectcell = cell;
    
    if ([self respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate SelectFontWithIndexPath:indexPath.row];
    }
}

- (void)clickSure:(UIButton *)sender{
    if ([self respondsToSelector:@selector(clickSure:)]) {
        [self.delegate clickSure:sender];
    }
}

- (void)clickCancel:(UIButton *)sender{
    if ([self respondsToSelector:@selector(clickCancel:)]) {
        [self.delegate clickCancel:sender];
    }
}



@end

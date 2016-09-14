//
//  CompanySelTableView.m
//  TDjuwairen
//
//  Created by 团大 on 16/9/14.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CompanySelTableView.h"

@implementation CompanySelTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"availableTags" ofType:@"plist"];
        self.companyArr = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        
        self.showArr = [NSMutableArray arrayWithArray:self.companyArr];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.showArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block) {
        self.block(tableView,indexPath);
    }
}

@end

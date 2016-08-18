//
//  NaviMoreView.h
//  TDjuwairen
//
//  Created by 团大 on 16/7/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NaviMoreViewDelegate <NSObject>

- (void)didSelectedWithIndexPath:(UITableViewCell*)cell;

@end

@interface NaviMoreView : UIView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *imgArr;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,assign) id<NaviMoreViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)iscollect;

@end

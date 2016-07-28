//
//  SelectFontView.h
//  TDjuwairen
//
//  Created by 团大 on 16/7/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectFontViewDelegate <NSObject>

- (void)SelectFontWithIndexPath:(NSInteger)indexPath;

- (void)clickSure:(UIButton *)sender;

- (void)clickCancel:(UIButton *)sender;

@end

@interface SelectFontView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *fontArr;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,assign) id<SelectFontViewDelegate>delegate;

@end

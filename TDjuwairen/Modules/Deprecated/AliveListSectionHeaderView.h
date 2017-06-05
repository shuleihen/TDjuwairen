//
//  AliveListSectionHeaderView.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AliveListSectionHeaderView;
@protocol AliveListSectionHeaderDelegate <NSObject>

- (void)alivelistSectionHeaderView:(AliveListSectionHeaderView *)headerView deletePressed:(id)sender;

@end

@interface AliveListSectionHeaderView : UIView
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, weak) id<AliveListSectionHeaderDelegate> delegate;
@end

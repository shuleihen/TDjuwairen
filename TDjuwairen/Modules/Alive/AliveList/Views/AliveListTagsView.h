//
//  AliveListTagsView.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AliveListTagsView;
@protocol AliveListTagsViewDelegate <NSObject>
- (void)aliveListTagsView:(AliveListTagsView *)tagsView didSelectedWithIndex:(NSInteger)index;

@end

@interface AliveListTagsView : UIView
@property (nonatomic, weak) id<AliveListTagsViewDelegate> delegate;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *stockHolderName;
@end

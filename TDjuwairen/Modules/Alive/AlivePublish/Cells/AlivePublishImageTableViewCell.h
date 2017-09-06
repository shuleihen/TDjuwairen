//
//  AlivePublishImageTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/9/5.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivePublishImageTableViewCell;
@protocol AlivePublishImageCellDegate <NSObject>

- (void)alivePublishImageCell:(AlivePublishImageTableViewCell *)cell addPressed:(id)sender;
- (void)alivePublishImageCell:(AlivePublishImageTableViewCell *)cell deletePressed:(id)sender;
@end

@interface AlivePublishImageTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger imageLimit;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, weak) id<AlivePublishImageCellDegate> delegate;

+ (CGFloat)heightWithImageCount:(NSInteger)count withLimit:(NSInteger)limit;
@end

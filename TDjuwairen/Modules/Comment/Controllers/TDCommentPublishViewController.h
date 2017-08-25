//
//  TDCommentPublishViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kCommentPublishStockPool,
    kCommentPublishStockPoolReplay,
    kCommentPublishAlive,
    kCommentPublishPlayStock,
} CommentPublishType;

@protocol TDCommentPublishDelegate <NSObject>

- (void)commentPublishSuccessed;

@end

@interface TDCommentPublishViewController : UIViewController
@property (nonatomic, assign) CommentPublishType publishType;
@property (nonatomic, weak) id<TDCommentPublishDelegate> delegate;
@property (nonatomic, strong) NSString *masterId;
@property (nonatomic, strong) NSString *commentId;
@end

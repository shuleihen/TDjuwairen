//
//  StockPoolCommentViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDCommentViewController.h"

typedef enum : NSUInteger {
    kCommentStockPool = 1,
    kCommentAlive = 2,
    kCommentPlayStock = 3,
} CommentType;


@protocol StockPoolCommentViewControllerDelegate <NSObject>
- (void)commentListLoadComplete;

@end

@interface StockPoolCommentViewController : TDCommentViewController
@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, strong) NSString *masterId;
@property (nonatomic, weak) id<StockPoolCommentViewControllerDelegate> delegate;
- (CGFloat)contentViewControllerHeight;
- (void)onRefesh;
- (void)loadMore;

@end

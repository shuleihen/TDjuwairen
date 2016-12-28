//
//  GuessCommentPublishViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/28.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    kGuessPublishAdd,
    kGuessPublishReply,
} GuessPublishType;

@protocol GuessCommentPublishDelegate <NSObject>

- (void)guessCommentPublishType:(GuessPublishType)type withContent:(NSString *)content withReplyCommentId:(NSString *)commentId;
@end

@interface GuessCommentPublishViewController : UIViewController
@property (nonatomic, weak) id<GuessCommentPublishDelegate> delegate;
@property (nonatomic, assign) GuessPublishType type;
@property (nonatomic, assign) NSString *replyCommentId;
@end

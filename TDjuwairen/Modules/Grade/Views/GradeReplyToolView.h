//
//  GradeReplyToolView.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GradeReplyToolViewDelegate <NSObject>

- (void)sendReplyWithContent:(NSString *)content withReviewId:(NSString *)reviewId;

@end

@interface GradeReplyToolView : UIView<UITextViewDelegate>
@property (nonatomic, weak) id<GradeReplyToolViewDelegate> delegate;

@property (nonatomic, strong) NSString *reviewId;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendBtn;

@end

//
//  GradeReplyToolView.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeReplyToolView : UIView<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendBtn;

@end

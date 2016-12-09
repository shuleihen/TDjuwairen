//
//  YXSecurityCodeButton.h
//  RmbWithdraw
//
//  Created by zdy on 16/8/31.
//  Copyright © 2016年 lianlian. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YXSecurityCodeButton;
@protocol YXSecurityCodeButtonDelegate <NSObject>
@optional
- (BOOL)canRequest;
@required
- (NSString *)codeWithPhone;
- (void)codeCompletionWithResult:(NSError *)error;
@end



@interface YXSecurityCodeButton : UIButton
@property (nonatomic, assign) IBInspectable int remainTime;
@property (nonatomic, strong) IBInspectable NSString *normalTitle;
@property (nonatomic, strong) IBInspectable NSString *formatTitle;  // %ld重新发送
@property (nonatomic, assign) int time;
@property (nonatomic, weak) IBOutlet id delegate;

- (void)handStart;
@end

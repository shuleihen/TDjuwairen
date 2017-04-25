//
//  YXSecurityCodeButton.h
//  RmbWithdraw
//
//  Created by zdy on 16/8/31.
//  Copyright © 2016年 lianlian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    kPhoneCodeForRegister   =1,
    kPhoneCodeForLogin      =2,
    kPhoneCodeForUpdate     =3,
    kPhoneCodeForSupplement =4,
    kPhoneCodeForFind       =5,
    kPhoneOpenAccount       =6
} PhoneCodeType;

@class YXSecurityCodeButton;
@protocol YXSecurityCodeButtonDelegate <NSObject>
@optional
- (BOOL)canRequest;
@required
- (NSString *)codeWithPhone;
- (PhoneCodeType)codeType;
@end



@interface YXSecurityCodeButton : UIButton
@property (nonatomic, strong) NSString *msg_unique_id;
@property (nonatomic, assign) IBInspectable int remainTime;
@property (nonatomic, strong) IBInspectable NSString *normalTitle;
@property (nonatomic, strong) IBInspectable NSString *formatTitle;  // %ld重新发送
@property (nonatomic, assign) int time;
@property (nonatomic, weak) IBOutlet id delegate;

- (void)handStart;
@end

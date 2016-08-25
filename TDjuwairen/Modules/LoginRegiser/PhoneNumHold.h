//
//  PhoneNumHold.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PhoneNumHoldDelegate <NSObject>

- (void)phoneSure:(UIButton *)sender;
- (void)phoneClean:(UIButton *)sender;

@end
@interface PhoneNumHold : UIView

@property (nonatomic,weak) id<PhoneNumHoldDelegate>delegate;

@end

//
//  UnlockView.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol unlockViewDelegate <NSObject>

- (void)closeUnlockView:(UIButton *)sender;

- (void)clickUnlockOrRecharge:(UIButton *)sender;

@end

@interface UnlockView : UIView

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UIView *showView;

@property (nonatomic,strong) UILabel *balanceLab;

@property (nonatomic,assign) id<unlockViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andCompany_name:(NSString *)companyName;

@end

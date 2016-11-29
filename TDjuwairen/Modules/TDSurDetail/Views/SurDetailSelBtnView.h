//
//  SurDetailSelBtnView.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SurDetailSelBtnViewDelegate <NSObject>

- (void)selectWithDetail:(UIButton *)sender;

@end

@interface SurDetailSelBtnView : UIView

@property (nonatomic,strong) UIButton *selBtn;

@property (nonatomic,strong) NSMutableArray *btnsArr;

@property (nonatomic,strong) UILabel *line1;
@property (nonatomic,strong) UILabel *line2;

@property (nonatomic,assign) BOOL isLocked;

@property (nonatomic,assign) id<SurDetailSelBtnViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame WithStockCode:(NSString *)code;
@end
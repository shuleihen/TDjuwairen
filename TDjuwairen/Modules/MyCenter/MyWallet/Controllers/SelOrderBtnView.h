//
//  SelOrderBtnView.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelOrderBtnViewDelegate <NSObject>

- (void)selectOrder:(UIButton *)sender;

@end

@interface SelOrderBtnView : UIView

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,strong) UILabel *selectLab;

@property (nonatomic,strong) NSMutableArray *btnsArr;

@property (nonatomic,assign) id<SelOrderBtnViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withArr:(NSArray *)arr;

@end

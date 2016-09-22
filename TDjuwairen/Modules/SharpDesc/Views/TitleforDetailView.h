//
//  TitleforDetailView.h
//  TDjuwairen
//
//  Created by 团大 on 16/9/20.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickAttentionBlock)();
@interface TitleforDetailView : UIView

@property (nonatomic,strong) UIImageView *userheadImage;
@property (nonatomic,strong) UILabel *usernickname;
@property (nonatomic,strong) UILabel *addtime;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *isAttention;

@property (nonatomic,copy) ClickAttentionBlock block;
@end

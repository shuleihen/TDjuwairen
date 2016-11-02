//
//  KeysNumberTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeysNumberTableViewCellDelegate <NSObject>

- (void)clickTopUp:(UIButton *)sender;

@end

@interface KeysNumberTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *keysLab;

@property (nonatomic,strong) UIImageView *keysImg;

@property (nonatomic,strong) UILabel *numLab;

@property (nonatomic,strong) UIButton *topupBtn;

@property (nonatomic,assign) id<KeysNumberTableViewCellDelegate>delegate;

@end

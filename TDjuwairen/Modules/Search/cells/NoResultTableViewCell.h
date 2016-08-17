//
//  NoResultTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoResultTableViewCellDelegate <NSObject>

- (void)clickSubmit:(UIButton *)sender;

@end
@interface NoResultTableViewCell : UITableViewCell

@property (nonatomic,assign) CGSize textsize;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *submit;
@property (nonatomic,assign) id<NoResultTableViewCellDelegate>delegate;
@end

//
//  CollectionTableViewCell.h
//  TDjuwairen
//
//  Created by tuanda on 16/6/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sharpImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *SelectImageView;

-(void)setCellWithDic:(NSDictionary *)dic;
@end

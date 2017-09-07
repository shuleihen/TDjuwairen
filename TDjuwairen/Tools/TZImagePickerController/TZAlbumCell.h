//
//  TZAlbumCell.h
//  TZImagePickerController
//
//  Created by ZYP-MAC on 2017/8/25.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TZAlbumModel;

@interface TZAlbumCell : UITableViewCell

@property (nonatomic, strong) TZAlbumModel *model;
@property (weak, nonatomic) UIButton *selectedCountButton;

@end

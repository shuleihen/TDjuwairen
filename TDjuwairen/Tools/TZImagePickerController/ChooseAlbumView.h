//
//  ChooseAlbumView.h
//  TZImagePickerController
//
//  Created by ZYP-MAC on 2017/8/25.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TZAssetModel.h"
@class TZAlbumModel;

typedef void(^FilterViewBackBlock)(TZAlbumModel *currentModel,BOOL needRefesh);
@interface ChooseAlbumView : UIView
@property (strong, nonatomic) NSArray *dataArr;
@property (copy, nonatomic) FilterViewBackBlock filterBlock;
- (instancetype)initWithCommonViewWithFrame:(CGRect)rect;


@end

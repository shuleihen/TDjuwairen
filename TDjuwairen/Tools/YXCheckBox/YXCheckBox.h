//
//  YXCheckBox.h
//  baiwandian
//
//  Created by zdy on 15/11/13.
//  Copyright © 2015年 xinyunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXCheckBox : UIButton
@property (nonatomic, assign) BOOL checked;


- (id)initWithCheckImage:(UIImage *)image checkedImage:(UIImage *)checkedImage withCheckedBlock:(void (^)(BOOL checked))checkedBlock;

@property (nonatomic, copy) void (^checkedBoxBlock)(BOOL checked);
@end

//
//  YXLocationPicker.h
//  baiwandian
//
//  Created by zdy on 15/12/15.
//  Copyright © 2015年 xinyunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLocationPicker : UIView
//- (void)setDefaultLocationWithProvinceId:(NSString *)province city:(NSString *)city district:(NSString *)district;

- (void)showWithCompleteBlock:(void(^)(NSString *province,NSString *city,NSString *strict))completeBlock;
- (void)dismiss;
@end

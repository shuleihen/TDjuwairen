//
//  SpecialModel.h
//  TDjuwairen
//
//  Created by 团大 on 16/7/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialModel : NSObject

@property (nonatomic,copy) NSString *subject_title;//专题标题
@property (nonatomic,copy) NSString *subject_tag;//专题标签
@property (nonatomic,copy) NSString *subject_logo_max;//专题图片

+(SpecialModel *)getInstanceWithDictionary:(NSDictionary *)dic;
@end

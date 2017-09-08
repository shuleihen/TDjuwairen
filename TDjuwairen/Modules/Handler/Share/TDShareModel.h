//
//  TDShareModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/27.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDShareModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *masterNickName;

@end

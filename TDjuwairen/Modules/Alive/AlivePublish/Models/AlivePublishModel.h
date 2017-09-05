//
//  AlivePublishModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/9/5.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlivePublishModel : NSObject
@property (nonatomic, strong) NSString *forwardId;
@property (nonatomic, assign) NSInteger forwardType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *masterNickName;
@property (nonatomic, strong) NSString *image;
@end

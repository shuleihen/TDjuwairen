//
//  TDTopicModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDTopicModel : NSObject

@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *topicTitle;
@property (nonatomic, copy) NSString *topicTime;
@property (nonatomic, copy) NSString *userAvatar;
@property (nonatomic, copy) NSString *userNickName;
@property (nonatomic, strong) NSArray *comments;
@end

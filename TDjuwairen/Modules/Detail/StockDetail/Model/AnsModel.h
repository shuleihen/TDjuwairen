//
//  AnsModel.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/10.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnsModel : NSObject

@property (nonatomic, copy) NSString *answerId;
@property (nonatomic, copy) NSString *ansContent;
@property (nonatomic, copy) NSString *ansUserName;
@property (nonatomic, copy) NSString *ansUserAvatar;
@property (nonatomic, strong) NSNumber *ansLikeNum;
@property (nonatomic, assign) BOOL isLiked;


- (id)initWithDict:(NSDictionary *)dict;

@end

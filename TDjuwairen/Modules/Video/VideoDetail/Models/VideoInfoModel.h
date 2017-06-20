//
//  VideoInfoModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *videoSrc;
@property (nonatomic, copy) NSNumber *visitNum;
@property (nonatomic, copy) NSNumber *shareNum;
@property (nonatomic, assign) BOOL isUnlock;

- (id)initWithDictionary:(NSDictionary *)dict;
@end

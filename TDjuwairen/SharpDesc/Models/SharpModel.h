//
//  SharpModel.h
//  TDjuwairen
//
//  Created by zdy on 16/7/28.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharpModel : NSObject
@property (nonatomic, strong) NSString *sharpId;
@property (nonatomic, assign) int sharpTypeId;
@property (nonatomic, strong) NSString *sharpTitle;
@property (nonatomic, strong) NSString *sharpContent;
@property (nonatomic, strong) NSString *sharpUserIcon;
@property (nonatomic, strong) NSString *sharpUserId;
@property (nonatomic, strong) NSString *sharpUserName;
@property (nonatomic, strong) NSString *sharpWtime;   // 撰稿时间
@property (nonatomic, strong) NSString *sharpPtime;   // 发布时间
@property (nonatomic, assign) int sharpIsOriginal;
@property (nonatomic, strong) NSString *sharpDesc;
@property (nonatomic, assign) int sharpVisitNum;
@property (nonatomic, assign) int sharpCommentNumbers;
@property (nonatomic, strong) NSString *sharpThumbnail;
@property (nonatomic, assign) BOOL sharpIsCollect; // 是否收藏
@property (nonatomic, strong) NSArray *sharpTags;
+ (id)sharpWithDictionary:(NSDictionary *)dict;
@end

//
//  PSIndividualArticleModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSIndividualArticleModel : NSObject
@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *articleTitle;
@property (nonatomic, copy) NSString *articleUrl;
//0表示没有，1表示调研，2表示热点，3表示观点，4表示直播 5表示公告
@property (nonatomic, assign) NSInteger articleType;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)typeString;
@end

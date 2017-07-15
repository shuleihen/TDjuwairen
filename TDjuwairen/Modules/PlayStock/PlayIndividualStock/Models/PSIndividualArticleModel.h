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
@property (nonatomic, assign) NSInteger articleType;

- (id)initWithDictionary:(NSDictionary *)dict;
@end

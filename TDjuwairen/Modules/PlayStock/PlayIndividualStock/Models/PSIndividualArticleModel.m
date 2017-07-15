//
//  PSIndividualArticleModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PSIndividualArticleModel.h"

@implementation PSIndividualArticleModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.articleId = dict[@"article_id"];
        self.articleTitle = dict[@"article_title"];
        self.articleType = [dict[@"article_type"] integerValue];
    }
    
    return self;
}
@end

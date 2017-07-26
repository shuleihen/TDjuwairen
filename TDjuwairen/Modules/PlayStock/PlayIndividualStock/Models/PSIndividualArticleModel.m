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
        self.articleUrl = dict[@"article_url"];
        self.articleType = [dict[@"article_type"] integerValue];
    }
    
    return self;
}

- (NSString *)typeString {
    NSString *string = @"";
    
    switch (self.articleType) {
        case 1:
            string = @"调研";
            break;
        case 2:
            string = @"热点";
            break;
        case 3:
            string = @"观点";
            break;
        case 4:
            string = @"直播";
            break;
        case 5:
            string = @"公告";
            break;
        default:
            break;
    }
    
    return string;
}
@end

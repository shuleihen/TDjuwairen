//
//  PSIndividualListModel.m
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PSIndividualListModel.h"
#import "PSIndividualArticleModel.h"

@implementation PSIndividualListModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.stockName = dict[@"guess_company"];
        self.guess_end_price = dict[@"guess_end_price"];
        self.guess_status = dict[@"guess_status"];
        self.guess_season = dict[@"guess_season"];
        self.guess_key_num = dict[@"guess_key_num"];
        self.guessId = dict[@"guess_id"];
        self.stockCode = dict[@"com_code"];
        self.guess_item_num = [dict[@"guess_item_num"] integerValue];
        self.has_join = [dict[@"has_join"] boolValue];
        self.winner_list = dict[@"winner_list"];
        self.stockId = dict[@"stock"];
        self.isReward = [dict[@"is_backstart"] boolValue];
        
        id articleList = dict[@"article_info"];
        if ([articleList isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[articleList count]];
            for (NSDictionary *d in articleList) {
                PSIndividualArticleModel *model = [[PSIndividualArticleModel alloc] initWithDictionary:d];
                [array addObject:model];
            }
            self.artile_list = array;
        }
    }
    
    return self;
}

- (NSArray *)artileTimeArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.artile_list.count];
    for (PSIndividualArticleModel *model in self.artile_list) {
        NSString *title = [NSString stringWithFormat:@"%@：%@",model.typeString,model.articleTitle];
        [array addObject:title];
    }
    
    return array;
}
@end

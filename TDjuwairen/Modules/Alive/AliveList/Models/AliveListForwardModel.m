//
//  AliveListForwardModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListForwardModel.h"
#import "AliveListModel.h"

@implementation AliveListForwardModel
- (id)initWithArray:(NSArray *)array {
    if (self =  [super init]) {
        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            AliveListModel *model = [[AliveListModel alloc] initWithDictionary:dict];
            [marray addObject:model];
        }
        
        self.forwardList = marray;
//        self.aliveId = dict[@"alive_id"];
//        self.aliveType = [dict[@"alive_type"] integerValue];
//        self.aliveImg = dict[@"alive_img"];
//        self.aliveImgs = dict[@"alive_images"];
//        self.aliveTitle = dict[@"alive_title"];
//        self.aliveTime = dict[@"alive_time"];
//        self.masterId = dict[@"alive_master_id"];
//        self.masterNickName = dict[@"user_nickname"];
//        self.aliveTags = dict[@"alive_com_tag"];
//        self.stockCode = dict[@"company_code"];
//        self.forwardUrl = dict[@"forward_url"];
//        self.isLocked = [dict[@"is_lock"] boolValue];
    }
    return self;
}

- (NSString *)forwardTitle {
    NSMutableString *string = [[NSMutableString alloc] init];
    
    for (int i=0; i<self.forwardList.count-1; i++) {
        AliveListModel *model = self.forwardList[i];
        [string appendFormat:@"//@%@%@",model.masterNickName,model.aliveTitle];
    }
    
    return string;
}
@end

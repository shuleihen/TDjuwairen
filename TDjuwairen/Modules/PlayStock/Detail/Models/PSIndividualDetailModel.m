//
//  PSIndividualDetailModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PSIndividualDetailModel.h"
#import "PSIndividualUserListModel.h"

@implementation PSIndividualDetailModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.stockName = dict[@"guess_stock_name"];
        self.stockCode = dict[@"guess_stock"];
        self.guessId = dict[@"guess_id"];
        self.endPrice = dict[@"guess_end_price"];
        self.status = [dict[@"guess_status"] integerValue];
        self.season = [dict[@"guess_season"] integerValue];
        self.guessKeyNum = [dict[@"guess_keynum"] integerValue];
        self.rewardKeyNum = [dict[@"guess_key_num"] integerValue];
        self.joinNum = [dict[@"guess_item_count"] integerValue];
        self.isClosed = [dict[@"guess_isclose"] boolValue];
        self.isReward = [dict[@"is_backstart"] boolValue];
        self.endTime = [dict[@"guess_endtime"] longLongValue];
        self.rate = [dict[@"login_user_rate"] integerValue];
        self.extra_keyNum = [dict[@"guess_extra_res"] integerValue];
        self.result = [dict[@"guess_result"] integerValue];
        self.date = dict[@"guess_date"];
        self.shareTitle = dict[@"share_title"];
        self.shareContent = dict[@"share_content"];
        self.shareUrl = dict[@"share_url"];
        self.shareImg = dict[@"share_img"];
        
        id userList = dict[@"guess_users"];
        if ([userList isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[userList count]];
            for (NSDictionary *d in userList) {
                PSIndividualUserListModel *model = [[PSIndividualUserListModel alloc] initWithDetailDictionary:d];
                model.showItemPoints = (self.status != kPSGuessExecuting);
                [array addObject:model];
            }
            self.joinList = array;
        }
    }
    
    return self;
}

- (NSString *)statusString {
    // 0表示正在进行，1表示封盘，2表示收盘
    NSString *string = @"";
    switch (self.status) {
        case kPSGuessExecuting:
            string = @"进行中";
            break;
        case kPSGuessStop:
            string = @"已封盘";
            break;
        case kPSGuessFinish:
            string = @"已结束";
            break;
        default:
            break;
    }
    return string;
}

- (NSString *)winStatusString {
    NSString *string = @"";
    switch (self.result) {
        case kPSWinNoFinish:
            string = @"进行中";
            break;
        case kPSWinYes:
            string = @"猜中";
            break;
        case kPSWinEntirely:
            string = @"完全猜中";
            break;
        case kPSWinNo:
            string = @"未猜中";
            break;
        default:
            break;
    }
    return string;
}
@end

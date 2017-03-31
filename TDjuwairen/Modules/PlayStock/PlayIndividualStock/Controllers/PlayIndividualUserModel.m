//
//  PlayIndividualUserModel.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayIndividualUserModel.h"
#import "PlayIndividualUserListModel.h"

@implementation PlayIndividualUserModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.guess_end_price = [NSString stringWithFormat:@"%@",dict[@"guess_end_price"]];
        self.guess_stock = dict[@"guess_stock"];
        self.guess_stock_name = dict[@"guess_stock_name"];
        self.guess_status = [NSString stringWithFormat:@"%@",dict[@"guess_status"]];
        self.guess_item_count = dict[@"guess_item_count"];
        self.guess_avg_points = [NSString stringWithFormat:@"%@",dict[@"guess_avg_points"]];
        BOOL showItemPoint = NO;
        switch ([self.guess_status integerValue]) {
            case 0:
                self.guessStatusStr = @"竞猜中";
                self.guess_end_price = @"__";
                break;
            case 1:
                self.guessStatusStr = @"封盘";
                showItemPoint = YES;
                break;
            case 2:
                self.guessStatusStr = @"收盘";
                showItemPoint = YES;
                break;
                
            default:
                break;
        }
        NSArray *arr = dict[@"guess_users"];
        NSMutableArray *arrM = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PlayIndividualUserListModel *model = [[PlayIndividualUserListModel alloc] initWithDictionary:obj];
            model.showItemPoints = showItemPoint;
            [arrM addObject:model];
        }];
        self.guess_users = [arrM mutableCopy];
        
        
    }
    
    return self;
}
@end

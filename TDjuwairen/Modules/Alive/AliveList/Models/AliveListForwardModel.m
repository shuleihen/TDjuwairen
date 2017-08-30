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

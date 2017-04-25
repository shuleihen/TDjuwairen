//
//  AskModel.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/10.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AskModel.h"
#import "AnsModel.h"
#import "NSString+Emoji.h"

@implementation AskModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.askContent = [dict[@"question_content"] stringByReplacingEmojiCheatCodesWithUnicode];
        self.askUserName = dict[@"user_nickname"];
        self.askUserAvatar = dict[@"userinfo_facemin"];
        self.askAddTime = dict[@"question_addtime"];
        
        NSArray *array = dict[@"ans_list"];
        if (array.count) {
            NSMutableArray *list = [NSMutableArray arrayWithCapacity:array.count];
            for (NSDictionary *dic in array) {
                AnsModel *m = [[AnsModel alloc] initWithDict:dic];
                [list addObject:m];
            }
            
            self.ansList = list;
        }
    }
    
    return self;
}

@end

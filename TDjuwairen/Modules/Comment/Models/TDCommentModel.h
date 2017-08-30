//
//  TDCommentModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDCommentModel : NSObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *replayToUserNickName;
@end

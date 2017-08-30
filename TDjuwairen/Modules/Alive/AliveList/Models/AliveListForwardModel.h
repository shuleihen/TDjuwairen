//
//  AliveListForwardModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliveTypeDefine.h"

@interface AliveListForwardModel : NSObject

@property (nonatomic, strong) NSArray *forwardList;

- (NSString *)forwardTitle;
- (id)initWithArray:(NSArray *)array;
@end

//
//  AliveListAdExtra.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveListAdExtra : NSObject
@property (nonatomic, assign) NSInteger linkType;
@property (nonatomic, copy) NSString *linkUrl;

- (id)initWithDictionary:(NSDictionary *)dict;
@end

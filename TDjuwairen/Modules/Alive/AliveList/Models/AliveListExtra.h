//
//  AliveListExtra.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/1.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveListExtra : NSObject
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, assign) BOOL isUnlock;
@property (nonatomic, assign) NSInteger unlockKeyNum;
@property (nonatomic, assign) NSInteger surveyType;
@property (nonatomic, copy) NSString *surveyDesc;
@property (nonatomic, copy) NSString *surveyUrl;

// 深度
@property (nonatomic, copy) NSString *deepPayTip;
@property (nonatomic, assign) NSInteger deepPayType;

- (id)initWithDictionary:(NSDictionary *)dict;
@end

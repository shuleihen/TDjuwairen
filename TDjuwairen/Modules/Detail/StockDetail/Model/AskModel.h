//
//  AskModel.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/10.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AskModel : NSObject

@property (nonatomic, copy) NSString *askId;
@property (nonatomic, copy) NSString *askContent;
@property (nonatomic, copy) NSString *askUserName;
@property (nonatomic, copy) NSString *askUserAvatar;
@property (nonatomic, copy) NSString *askAddTime;
@property (nonatomic, strong) NSArray *ansList;


- (id)initWithDict:(NSDictionary *)dict;
@end

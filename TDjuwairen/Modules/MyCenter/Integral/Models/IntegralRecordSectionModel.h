//
//  IntegralRecordSectionModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegralRecordSectionModel : NSObject
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) NSInteger allIn;
@property (nonatomic, assign) NSInteger allOut;
@property (nonatomic, strong) NSString *title;
@end

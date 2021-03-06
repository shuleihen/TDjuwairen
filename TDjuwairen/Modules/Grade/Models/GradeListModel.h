//
//  GradeListModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeListModel : NSObject
@property (nonatomic, assign) NSInteger sortNumber;
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, strong) NSString *stockId;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, assign) NSInteger type;

- (id)initWithDict:(NSDictionary *)dict;
@end

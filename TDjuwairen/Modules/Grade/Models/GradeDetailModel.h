//
//  GradeDetailModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeItem : NSObject
@property (nonatomic, strong) NSString *order;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *score;

- (id)initWithDict:(NSDictionary *)dict;
@end

@interface GradeDetailModel : NSObject
@property (nonatomic, assign) NSInteger totalGrade;
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, strong) NSString *stockId;
@property (nonatomic, assign) BOOL canGrade;
@property (nonatomic, assign) NSInteger lastTime;
@property (nonatomic, strong) NSArray *itemGrades;

- (id)initWithDict:(NSDictionary *)dict;
@end

//
//  SearchResultModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultModel : NSObject
@property (nonatomic, strong) NSString *resultId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isMyStock;

- (id)initWithStockDict:(NSDictionary *)dict;
- (id)initWithSurveyDict:(NSDictionary *)dict;
- (id)initWithViewpointDict:(NSDictionary *)dict;
@end

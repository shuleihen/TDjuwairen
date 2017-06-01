//
//  SearchSectionData.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchSectionData : NSObject
@property (nonatomic, strong) NSString *sectionTitle;
@property (nonatomic, assign) BOOL isShowMore;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL isFixed;
@property (nonatomic, assign) NSInteger searchType;
@end

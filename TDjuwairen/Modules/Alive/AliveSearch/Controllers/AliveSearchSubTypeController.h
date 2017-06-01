//
//  AliveSearchSubTypeController.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchSectionData;

typedef enum : NSUInteger {
    AliveSearchSubUserType     =0, // 用户搜索
    AliveSearchSubStockType  =1, // 股票搜索
    AliveSearchSubSurveyType       =2, // 调研搜索
    AliveSearchSubTopicType    =3, // 话题搜索
    AliveSearchSubPasteType      =4,  // 贴单搜索
    AliveSearchSubViewPointType      =5  // 观点搜索
} AliveSearchSubType;

@interface AliveSearchSubTypeController : UIViewController
@property (assign, nonatomic) AliveSearchSubType searchType;
@property (strong, nonatomic) SearchSectionData *transmitSearchSectionData;
@property (copy, nonatomic) NSString *searchTextStr;
@end

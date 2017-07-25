//
//  SurveyTypeDefine.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#ifndef SurveyTypeDefine_h
#define SurveyTypeDefine_h

// 股票详情调研列表数据： 1为实地、2为对话、3热点、5为深度、6为评论、7为功能、11为视频
typedef enum : NSUInteger {
    kSurveyTypeSpot      =1,
    kSurveyTypeDialogue  =2,
    kSurveyTypeHot       =3,
    kSurveyTypeShengdu   =5,
    kSurveyTypeComment   =6,
    kSurveyTypeAnnounce  =7,
    kSurveyTypeVido      =11
} SurveyType;


#define kSurveyListOptional         @"154"
#define kSurveyListRecommendTag     @"156"

@class SurveyListModel;
@protocol SurveyStockListCellDelegate <NSObject>

- (void)surveyStockListStockNamePressedWithSurveyListModel:(SurveyListModel *)model;
- (void)surveyStockListTitlePressedWithSurveyListModel:(SurveyListModel *)model;
@end

#endif /* SurveyTypeDefine_h */

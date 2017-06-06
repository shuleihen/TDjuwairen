//
//  SurveyTypeDefine.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#ifndef SurveyTypeDefine_h
#define SurveyTypeDefine_h

// 调研类型 1为实地、2为对话、3为产品、4为热点、5为深度、6为评论，11为视频
typedef enum : NSUInteger {
    kSurveyTypeSpot      =1,
    kSurveyTypeDialogue  =2,
    kSurveyTypeProduct   =3,
    kSurveyTypeHot       =4,
    kSurveyTypeShengdu   =5,
    kSurveyTypeComment   =6,
    kSurveyTypeVido      =11
} SurveyType;


#endif /* SurveyTypeDefine_h */

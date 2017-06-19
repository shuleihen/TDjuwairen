//
//  SurveyHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SurveyHandler.h"
#import "SurveyTypeDefine.h"

@implementation SurveyHandler
+ (UIImage *)imageWithSurveyType:(NSInteger)type {
    UIImage *image;
    
    switch (type) {
        case kSurveyTypeSpot:
            // 调研
            image = [UIImage imageNamed:@"type_shi.png"];
            break;
        case kSurveyTypeDialogue:
            // 对话
            image = [UIImage imageNamed:@"type_talk.png"];
            break;
        case kSurveyTypeShengdu:
            // 深度
            image = [UIImage imageNamed:@"type_deep.png"];
            break;
        case kSurveyTypeComment:
            // 评论
            image = [UIImage imageNamed:@"type_discuss.png"];
            break;
        case kSurveyTypeVido:
            // 视频
            image = [UIImage imageNamed:@"type_video.png"];
            break;
        default:
            break;
    }
    
    return image;
}
@end

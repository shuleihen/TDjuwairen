//
//  SurveyAnsView.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyAnsView : UIView
+ (CGFloat)heightWithAnsList:(NSArray *)ansList withWidth:(CGFloat)width;

@property (nonatomic, strong) NSArray *ansList;
@end

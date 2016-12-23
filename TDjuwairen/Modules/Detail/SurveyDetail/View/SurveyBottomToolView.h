//
//  SurveyBottomToolView.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyBottomToolView : UIView
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) void (^buttonBlock)(NSInteger);
@end

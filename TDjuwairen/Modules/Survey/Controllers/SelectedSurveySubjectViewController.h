//
//  SelectedSurveySubjectViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedSurveySubjectViewController : UIViewController

@property (nonatomic, strong) NSArray *selectedArray;

@property (nonatomic, copy) void (^selectedBlock)(NSArray *array);
@end

//
//  SurveyDetailWebViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyDetailContentViewController.h"
#import <WebKit/WebKit.h>

@interface SurveyDetailWebViewController : UIViewController
@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, strong) NSString *stockName;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSString *url;

@end

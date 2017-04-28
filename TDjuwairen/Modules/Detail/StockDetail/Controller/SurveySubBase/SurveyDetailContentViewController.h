//
//  SurveyDetailContentViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/30.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyDetailWebViewController.h"

@class SurveyDetailContentViewController;
@protocol SurveyDetailContenDelegate <NSObject>
- (void)contentDetailController:(SurveyDetailContentViewController *)controller withHeight:(CGFloat)height;
@optional
- (BOOL)canRead;
@end

@interface SurveyDetailContentViewController : UIViewController

// 股票名称
@property (nonatomic, copy) NSString *stockName;
// 股票代码
@property (nonatomic, copy) NSString *stockCode;
@property (nonatomic, copy) NSString *stockCover;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, weak) UIViewController *rootController;

@property (nonatomic, weak) id<SurveyDetailContenDelegate> delegate;


- (CGFloat)contentHeight;
- (NSDictionary *)contentParm;

- (void)reloadData;
- (NSString *)contenWebUrlWithContentId:(NSString *)contentId;
@end

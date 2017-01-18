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
@end

@interface SurveyDetailContentViewController : UIViewController
@property (nonatomic, copy) NSString *stockId;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, weak) UIViewController *rootController;

@property (nonatomic, weak) id<SurveyDetailContenDelegate> delegate;


- (CGFloat)contentHeight;
- (NSDictionary *)contentParmWithTag:(NSInteger)tag;

- (void)reloadData;
- (NSString *)contenWebUrlWithBaseUrl:(NSString *)baseUrl witTag:(NSInteger)tag;
@end
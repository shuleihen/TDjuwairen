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
- (void)unlocked;
@end

@interface SurveyDetailContentViewController : UIViewController

@property (nonatomic, copy) NSString *stockName;
@property (nonatomic, copy) NSString *stockCode;
@property (nonatomic, copy) NSString *stockCover;
@property (nonatomic, weak) UIViewController *rootController;

@property (nonatomic, weak) id<SurveyDetailContenDelegate> delegate;

- (CGFloat)contentHeight;

- (void)reloadData;
- (void)showNoDataView:(BOOL)isShow;

+ (NSString *)contenWebUrlWithContentId:(NSString *)contentId withTag:(NSInteger)tag;
@end

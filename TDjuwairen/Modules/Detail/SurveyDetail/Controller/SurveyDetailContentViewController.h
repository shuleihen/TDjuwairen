//
//  SurveyDetailContentViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/30.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SurveyDetailContentViewController;
@protocol SurveyDetailContenDelegate <NSObject>
- (void)contentDetailController:(SurveyDetailContentViewController *)controller withHeight:(CGFloat)height;
@end

@interface SurveyDetailContentViewController : UIViewController
@property (nonatomic, copy) NSString *stockId;  // 股票代码
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, weak) id<SurveyDetailContenDelegate> delegate;

- (void)loadWebWithUrl:(NSString *)url;
- (CGFloat)contentHeight;
- (NSDictionary *)contentParmWithTag:(NSInteger)tag;
- (NSString *)contenWebUrlWithBaseUrl:(NSString *)baseUrl witTag:(NSInteger)tag;
@end

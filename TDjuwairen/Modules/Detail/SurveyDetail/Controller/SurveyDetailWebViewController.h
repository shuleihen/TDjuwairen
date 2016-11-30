//
//  SurveyDetailWebViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol SurveyDetailContenDelegate <NSObject>
- (void)contentWebView:(WKWebView *)webView withHeight:(CGFloat)height;
@end

@interface SurveyDetailWebViewController : UIViewController
@property (nonatomic, strong) NSString *url;
- (void)loadWebWithUrl:(NSString *)url;
@property (nonatomic, weak) id<SurveyDetailContenDelegate> delegate;
@end

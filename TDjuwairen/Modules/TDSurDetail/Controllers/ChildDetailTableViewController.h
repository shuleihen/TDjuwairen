//
//  ChildDetailTableViewController.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@import WebKit;
@protocol ChildDetailDelegate <NSObject>

- (void)didFinishLoad;

- (void)childScrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface ChildDetailTableViewController : UITableViewController

@property (nonatomic,strong) WKWebView *webview;

@property (nonatomic,assign) id<ChildDetailDelegate>delegate;

- (void)requestWithSelBtn:(int )num WithSurveyID:(NSString *)surveyID;

@end

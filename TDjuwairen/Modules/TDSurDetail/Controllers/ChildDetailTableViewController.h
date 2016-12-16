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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)tapWebGesture:(UIGestureRecognizer *)pan;

- (void)clickToAns:(UIButton *)sender;

@end

@interface ChildDetailTableViewController : UITableViewController

@property (nonatomic,assign) int niuxiong;

@property (nonatomic,strong) UIWebView *webview;

@property (nonatomic,assign) id<ChildDetailDelegate>delegate;

- (void)requestWithSelBtn:(int )num WithSurveyID:(NSString *)surveyID;

@end

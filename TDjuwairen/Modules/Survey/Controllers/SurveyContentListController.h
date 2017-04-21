//
//  SurveyContentListController.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SurveyContentListDelegate <NSObject>

- (void)contentListLoadComplete;
@end

@interface SurveyContentListController : UIViewController
@property (nonatomic, strong) NSString *subjectId;
@property (nonatomic, strong) NSString *subjectTitle;
@property (nonatomic, weak) UIViewController *rootController;

@property (nonatomic, weak) id<SurveyContentListDelegate> delegate;

- (CGFloat)contentHeight;
- (void)refreshData;
- (void)loadMoreData;
@end

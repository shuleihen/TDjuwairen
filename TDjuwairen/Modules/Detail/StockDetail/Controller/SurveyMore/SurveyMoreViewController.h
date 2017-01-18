//
//  SurveyMoreViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SurveyMoreDelegate <NSObject>

- (void)didSelectedWithRow:(NSInteger)row;

@end

@interface SurveyMoreViewController : UITableViewController
@property (nonatomic, assign) id<SurveyMoreDelegate> delegate;
@end

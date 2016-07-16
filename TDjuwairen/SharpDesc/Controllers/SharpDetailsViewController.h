//
//  SharpDetailsViewController.h
//  TDjuwairen
//
//  Created by 团大 on 16/5/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyListModel.h"

@interface SharpDetailsViewController : UIViewController

@property (nonatomic,copy) NSString *sharp_id;
@property (nonatomic,copy) SurveyListModel *model;
@end

//
//  CommentViewController.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/14.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AskModel.h"

@interface CommentViewController : UIViewController

@property (nonatomic,assign) int tag;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *company_code;

@property (nonatomic,strong) AskModel *model;

@end

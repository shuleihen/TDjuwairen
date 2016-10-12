//
//  FeedbackViewController.h
//  juwairen
//
//  Created by tuanda on 16/5/25.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UITextField *contentTextField;
@property (nonatomic,strong) UIButton *SendBtn;
@property (nonatomic,copy)NSString *str;

@end

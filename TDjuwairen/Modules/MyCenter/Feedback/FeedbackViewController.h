//
//  FeedbackViewController.h
//  juwairen
//
//  Created by tuanda on 16/5/25.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
- (IBAction)SendBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *SendBtn;
@property (nonatomic,copy)NSString *str;

@end

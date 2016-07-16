//
//  ForgotSecondTableViewController.h
//  juwairen
//
//  Created by tuanda on 16/5/19.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotSecondTableViewController : UITableViewController
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *str;
- (IBAction)Verification:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *VerificationBtn;
@property (weak, nonatomic) IBOutlet UITextField *VerificationTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)FinishBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *FinishBtn;
@end

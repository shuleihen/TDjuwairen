//
//  RegiserSecondTableViewController.h
//  juwairen
//
//  Created by tuanda on 16/5/17.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegiserSecondTableViewController : UITableViewController
- (IBAction)messageBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UITextField *VerificationTextField;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *nickname;
- (IBAction)finishBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property(nonatomic,copy)NSString*phone;
@end

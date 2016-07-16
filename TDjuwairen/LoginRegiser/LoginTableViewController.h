//
//  LoginTableViewController.h
//  juwairen
//
//  Created by tuanda on 16/5/17.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginBtn:(UIButton *)sender;
- (IBAction)forgotBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
- (IBAction)openBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

//
//  ForgotTableViewController.h
//  juwairen
//
//  Created by tuanda on 16/5/19.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *forgotTextField;
- (IBAction)NextBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *NextBtn;

@end

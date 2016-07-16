//
//  RegiserTableViewController.h
//  juwairen
//
//  Created by tuanda on 16/5/17.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegiserTableViewController : UITableViewController
- (IBAction)RegiserBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *Regiser;
@property (weak, nonatomic) IBOutlet UITextField *phonetext;
- (IBAction)checkbox:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;
- (IBAction)agreeBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

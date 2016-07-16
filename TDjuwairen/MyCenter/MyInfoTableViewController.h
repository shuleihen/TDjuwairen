//
//  MyInfoTableViewController.h
//  juwairen
//
//  Created by tuanda on 16/5/20.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoTableViewController : UITableViewController
@property (nonatomic,copy)NSString *str;
- (IBAction)headimageBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *headimageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *postTextField;
@property (weak, nonatomic) IBOutlet UITextField *personalTextField;

@property (nonatomic,strong)UIBarButtonItem*preserveBtn;

@end

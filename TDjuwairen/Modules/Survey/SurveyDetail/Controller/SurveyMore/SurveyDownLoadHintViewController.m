//
//  SurveyDownLoadHintViewController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SurveyDownLoadHintViewController.h"
#import "STPopup.h"
#import "UIButton+Align.h"

@interface SurveyDownLoadHintViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation SurveyDownLoadHintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.closeBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -15)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (IBAction)closeButtonClick {
    [self.popupController dismiss];
}

- (IBAction)knowButtonClick {
    [self closeButtonClick];
}



@end

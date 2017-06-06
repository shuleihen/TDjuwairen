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
    self.showMessageLabel.text = @"若想下载公告文件\n请使用电脑\n在局外人网站上进行下载\n网址：www.juwairen.net";
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

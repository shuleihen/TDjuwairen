//
//  ShareViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ShareViewController.h"
#import "STPopup.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentSizeInPopup = CGSizeMake(kScreenWidth, 290);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(UIButton *)sender {
    [self.popupController dismiss];
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender.tag);
    }
}

- (IBAction)cancelPressed:(id)sender {
    [self.popupController dismiss];
}

@end

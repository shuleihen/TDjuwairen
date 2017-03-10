//
//  ContactViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ContactViewController.h"
#import "STPopup.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)contactPressed:(id)sender {
    [self.popupController dismiss];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:15968148830"]];
}

- (IBAction)closePressed:(id)sender {
    [self.popupController dismiss];
}
@end

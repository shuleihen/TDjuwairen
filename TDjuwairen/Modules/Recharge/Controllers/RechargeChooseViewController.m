//
//  RechargeChooseViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RechargeChooseViewController.h"
#import "NetworkManager.h"
#import "LoginStateManager.h"
#import "STPopup.h"

@interface RechargeChooseViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation RechargeChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.contentSizeInPopup = CGSizeMake(260, 150);
}

- (IBAction)zhifbaoPressed:(id)sender {

}

- (IBAction)wexinPressed:(id)sender {
 
}

@end

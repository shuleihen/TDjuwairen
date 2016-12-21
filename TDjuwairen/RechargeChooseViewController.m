//
//  RechargeChooseViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RechargeChooseViewController.h"

@interface RechargeChooseViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation RechargeChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentView.layer.cornerRadius = 5.0f;
}

- (IBAction)zhifbaoPressed:(id)sender {
}

- (IBAction)wexinPressed:(id)sender {
}

- (IBAction)hidePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view != self.contentView;
}
@end

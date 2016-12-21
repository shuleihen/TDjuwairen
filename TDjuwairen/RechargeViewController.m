//
//  RechargeViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeChooseViewController.h"

@interface RechargeViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentView.layer.cornerRadius = 5.0f;
}

- (IBAction)onePressed:(id)sender {
    [self rechargeWithMoney:5.0f];
}

- (IBAction)fivePressed:(id)sender {
    [self rechargeWithMoney:25.0f];
}

- (IBAction)tenPressed:(id)sender {
    [self rechargeWithMoney:50.0f];
}

- (IBAction)allPressed:(id)sender {
    [self rechargeWithMoney:2999.0f];
}

- (void)rechargeWithMoney:(CGFloat)money {
    RechargeChooseViewController *vc = [[UIStoryboard storyboardWithName:@"Recharge" bundle:nil] instantiateViewControllerWithIdentifier:@"RechargeChooseViewController"];
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)hidePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view != self.contentView;
}
@end

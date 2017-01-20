//
//  RechargeViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeChooseViewController.h"
#import "STPopup.h"

@interface RechargeViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.contentView.layer.cornerRadius = 5.0f;
    self.contentSizeInPopup = CGSizeMake(260, 150);
}

- (IBAction)onePressed:(id)sender {
    [self rechargeWithKeyNumber:1 type:1];
}

- (IBAction)fivePressed:(id)sender {
    [self rechargeWithKeyNumber:5 type:1];
}

- (IBAction)tenPressed:(id)sender {
    [self rechargeWithKeyNumber:10 type:1];
}

- (IBAction)allPressed:(id)sender {
    [self rechargeWithKeyNumber:0 type:2];
}

- (void)rechargeWithKeyNumber:(NSInteger)keyNumber type:(NSInteger)type{
    RechargeChooseViewController *vc = [[UIStoryboard storyboardWithName:@"Recharge" bundle:nil] instantiateViewControllerWithIdentifier:@"RechargeChooseViewController"];
    vc.keyNumber = keyNumber;
    vc.type = type;
    [self.popupController pushViewController:vc animated:YES];
}

@end

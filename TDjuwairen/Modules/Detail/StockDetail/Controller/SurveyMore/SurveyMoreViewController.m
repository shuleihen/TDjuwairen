//
//  SurveyMoreViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyMoreViewController.h"
#import "STPopup.h"
#import "HexColors.h"
#import "UIButton+Align.h"

@interface SurveyMoreViewController ()

@end

@implementation SurveyMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.contentSizeInPopup = CGSizeMake(kScreenHeight, 81);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)showAnimationView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -81, kScreenWidth, 81)];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [share setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateNormal];
    [share setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [share setTitle:@"分享" forState:UIControlStateNormal];
    share.frame = CGRectMake((kScreenHeight-(52*2+70))/2, 15, 46, 52);
    [share addTarget:self action:@selector(sharePressed:) forControlEvents:UIControlEventTouchUpInside];
    [share align:BAVerticalImage withSpacing:3];
    [view addSubview:share];
    
    UIButton *feedback = [UIButton buttonWithType:UIButtonTypeCustom];
    feedback.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [feedback setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateNormal];
    [feedback setImage:[UIImage imageNamed:@"icon_feedback.png"] forState:UIControlStateNormal];
    [feedback setTitle:@"反馈" forState:UIControlStateNormal];
    feedback.frame = CGRectMake(CGRectGetMaxX(share.frame)+70, 15, 46, 52);
    [feedback addTarget:self action:@selector(feedbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [feedback align:BAVerticalImage withSpacing:3];
    [view addSubview:feedback];
    
    view.tag = 10;
    [self.view addSubview:view];
    
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(0, 0, kScreenWidth, 81);
    }];
}

- (void)hideAnimation {
    UIView *view = [self.view viewWithTag:10];
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(0, -81, kScreenWidth, 81);
    }];
}

- (void)sharePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithRow:)]) {
        [self.delegate didSelectedWithRow:0];
    }
}

- (void)feedbackPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithRow:)]) {
        [self.delegate didSelectedWithRow:1];
    }
}
@end

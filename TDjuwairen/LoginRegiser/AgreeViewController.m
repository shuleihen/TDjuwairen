//
//  AgreeViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/24.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "AgreeViewController.h"

@interface AgreeViewController ()

@end

@implementation AgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.contentInset=UIEdgeInsetsMake(-66, 0, 0, 0);
    [self setNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigation
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    label.text=@"用户协议";
    self.navigationItem.titleView=label;
}
@end

//
//  AgreeViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/24.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "AgreeViewController.h"
#import "UIdaynightModel.h"

@interface AgreeViewController ()

@end

@implementation AgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIdaynightModel *daynightmodel = [UIdaynightModel sharedInstance];
    
    [self setNavigation];
    self.textView.backgroundColor = daynightmodel.navigationColor;
    self.textView.textColor = daynightmodel.textColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigation
{
    self.title = @"用户协议";
}
@end

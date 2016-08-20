//
//  AboutViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/24.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "AboutViewController.h"
#import "UIdaynightModel.h"

@interface AboutViewController ()



@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIdaynightModel *daynightmodel = [UIdaynightModel sharedInstance];
    self.labe1.textColor = daynightmodel.textColor;
    self.labe2.textColor = daynightmodel.textColor;
    self.label3.textColor = daynightmodel.titleColor;
    self.view.backgroundColor = daynightmodel.navigationColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self SetNavigation];
}

-(void)SetNavigation
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    label.text=@"关于我们";
    self.navigationItem.titleView=label;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  GameSelectViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/19.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "GameSelectViewController.h"
#import "GuessRedGreenViewController.h"

@interface GameSelectViewController ()

@end

@implementation GameSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWithNavigation];
    [self setupWithSelectBtn];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    self.title = @"玩票";
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"奖品兑换" style:UIBarButtonItemStyleDone target:self action:@selector(clickExchange:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)setupWithSelectBtn{
    CGFloat btnH = (kScreenHeight-64-50)/2;
    UIButton *guess = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, btnH)];
    [guess setBackgroundColor:[UIColor redColor]];
    [guess addTarget:self action:@selector(goGuess:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *compare = [[UIButton alloc] initWithFrame:CGRectMake(0, btnH, kScreenWidth, btnH)];
    [compare setBackgroundColor:[UIColor blueColor]];
    [compare addTarget:self action:@selector(goCompare:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:guess];
    [self.view addSubview:compare];
}

- (void)goGuess:(UIButton *)sender{
    GuessRedGreenViewController *guessView = [[GuessRedGreenViewController alloc] init];
    guessView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:guessView animated:YES];
}

- (void)goCompare:(UIButton *)sender{
    NSLog(@"比谁准");
}

- (void)clickExchange:(UIButton *)sender{
    NSLog(@"奖品兑换");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

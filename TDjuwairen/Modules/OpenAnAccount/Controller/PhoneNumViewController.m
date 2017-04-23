//
//  PhoneNumViewController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/4/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PhoneNumViewController.h"
#import "UIViewController+STPopup.h"
#import "STPopupController.h"
#import "NSObject+ChangeState.h"
@interface PhoneNumViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTabelView;

@end

@implementation PhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)cancleClick:(id)sender {
    [self.popupController dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = @"0371-6353822";
    cell.textLabel.textColor = TDThemeColor;
    AddLineAtBottom(cell);
    return cell;
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",@"13162050121"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
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

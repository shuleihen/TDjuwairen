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
   
}

- (void)setSourceArr:(NSArray *)sourceArr
{
    _sourceArr = sourceArr;
    [_mTabelView reloadData];
}
- (IBAction)cancleClick:(id)sender {
    [self.popupController dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _sourceArr[indexPath.row];
    cell.textLabel.textColor = TDThemeColor;
    AddLineAtBottom(cell);
    return cell;
}

- (CGFloat)getSelfHight
{
    return (_sourceArr.count+1)*49;
}
-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",_sourceArr[indexPath.row]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}


@end

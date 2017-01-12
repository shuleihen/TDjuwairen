//
//  PaySubscriptionViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PaySubscriptionViewController.h"
#import "HexColors.h"

@interface PaySubscriptionViewController ()
@property (nonatomic, strong) UIView *toolView;

@end

@implementation PaySubscriptionViewController
- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn setTitle:@"确认订阅" forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(12, 10, kScreenWidth-24, 35);
        btn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
        [btn addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:btn];
        
        UIImage *slipImage = [UIImage imageNamed:@"slipLine"];
        UIImageView *slipImageView = [[UIImageView alloc] initWithImage:slipImage];
        slipImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1/[UIScreen mainScreen].scale);
        [_toolView addSubview:slipImageView];
        
        _toolView.backgroundColor = [UIColor whiteColor];
    }
    return _toolView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardPressed:)];
    [self.tableView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.toolView.frame = CGRectMake(0, kScreenHeight-55, kScreenWidth, 55);
    [self.navigationController.view addSubview:self.toolView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.toolView removeFromSuperview];
}

- (void)confirmPressed:(id)sender {
    
}

- (void)hideKeyboardPressed:(id)sender {
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 35)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.dk_textColorPicker = DKColorPickerWithKey(DETAIL);
    [view addSubview:label];
    
    if (section == 0) {
        label.text = @"产品信息";
    } else {
        label.text = @"订阅信息";
    }
        
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
    
}

@end

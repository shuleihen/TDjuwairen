//
//  GradeDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeDetailViewController.h"
#import "HexColors.h"
#import "GradeHeaderView.h"
#import "GradeDetailCell.h"
#import "GradeCommentModel.h"
#import "GradeAddViewController.h"

@interface GradeDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GradeHeaderView *headerView;

@property (nonatomic, strong) NSArray *items;
@end

@implementation GradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolView];
    
    self.title = @"评级列表";
    
    [self.headerView setupGradeModel];
    [self testData];
}

- (void)testData {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<10; i++) {
        GradeCommentModel *model = [[GradeCommentModel alloc] init];
        model.userName = @"大团结";
        model.content = @"挺好挺好挺好挺好挺好挺好挺好挺好挺好挺好挺好挺好";
        model.grade = 78;
        model.createTime = @"2015-10-3 14:14";
        model.avatar = @"https://static.juwairen.net/Pc/Uploads/Images/Face/faceimg_330_70.jpg";
        [array addObject:model];
    }
    
    self.items = array;
}

- (void)gradePressed:(id)sender {
    GradeAddViewController *vc = [[GradeAddViewController alloc] init];
    vc.stockName = self.stockName;
    vc.stockId = self.stockId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001f;
    }
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 203;
    }
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35.0f)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 40, 20)];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
    label.text = @"评价";
    [view addSubview:label];
    
    UILabel *labelB = [[UILabel alloc] initWithFrame:CGRectMake(62, 7, 40, 160)];
    labelB.font = [UIFont systemFontOfSize:14.0f];
    labelB.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
    labelB.text = @"评价";
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeHeaderCellID"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GradeHeaderCellID"];
            [cell.contentView addSubview:self.headerView];
        }
        return cell;
    } else {
        GradeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeDetailCellID"];
        
        GradeCommentModel *model = self.items[indexPath.row];
        [cell setupCommentModel:model];
        
        return cell;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-55) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 120.0f;
        _tableView.separatorInset = UIEdgeInsetsZero;
        
        UINib *nib = [UINib nibWithNibName:@"GradeDetailCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"GradeDetailCellID"];
    }
    return _tableView;
}

- (GradeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[GradeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 204)];
    }
    return _headerView;
}

- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-55, kScreenWidth, 55)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"我要评分" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        btn.frame = CGRectMake(12, 12, kScreenWidth-24, 34);
        btn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
        [btn addTarget:self action:@selector(gradePressed:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:btn];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        sep.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
        [_toolView addSubview:sep];
        
        _toolView.backgroundColor = [UIColor whiteColor];
    }
    return _toolView;
}

@end

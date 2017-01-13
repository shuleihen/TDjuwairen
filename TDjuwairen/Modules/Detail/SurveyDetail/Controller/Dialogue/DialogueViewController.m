//
//  DialogueViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "DialogueViewController.h"
#import "SpotTableViewCell.h"
#import "SpotModel.h"
#import "NetworkManager.h"

@interface DialogueViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@end

@implementation DialogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    [self testData];
}

- (void)testData {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<5; i++) {
        SpotModel *model = [[SpotModel alloc] init];
        model.imageUrl = @"https://static.juwairen.net/Pc/Uploads/Images/Survey/200_sc_857_20170106163340.jpg";
        model.title = @"谣言戳破之后，PLED坠落神坛";
        model.dateTime = @"1天前";
        [array addObject:model];
    }
    
    self.items = array;
    [self.tableView reloadData];
    
    [self calculateTabelViewHeight];
}

- (void)reloadData {
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *para = [self contentParmWithTag:self.tag];
    
    [ma POST:API_SurveyDetail parameters:para completion:^(id data, NSError *error){
        if (!error && data) {
            [self reloadTableViewWithData:data];
        } else {
            // 查询失败
        }
    }];
}

- (void)reloadTableViewWithData:(NSArray *)askList {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[askList count]];
    
    for (NSDictionary *dic in askList) {
        SpotModel *model = [SpotModel getInstanceWithDictionary:dic];
        [array addObject:model];
    }
    
    self.items = array;
    [self.tableView reloadData];
    
    [self calculateTabelViewHeight];
}

- (void)calculateTabelViewHeight {
    CGFloat height = [self.items count] * 90;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentDetailController:withHeight:)]) {
        [self.delegate contentDetailController:self withHeight:height];
    }
}

- (CGFloat)contentHeight {
    return CGRectGetHeight(self.tableView.bounds);
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpotTableViewCellID"];
    
    SpotModel *model = self.items[indexPath.row];
    [cell setupSpotModel:model];
    
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 90;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
        
        UINib *nib = [UINib nibWithNibName:@"SpotTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"SpotTableViewCellID"];
    }
    
    return _tableView;
}

@end

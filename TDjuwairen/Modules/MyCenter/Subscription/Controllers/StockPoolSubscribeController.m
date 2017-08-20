//
//  StockPoolSubscribeController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSubscribeController.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "AliveListStockPoolTableViewCell.h"

@interface StockPoolSubscribeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation StockPoolSubscribeController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 150.0;
        _tableView.tableFooterView = [UIView new];
        UINib *nib = [UINib nibWithNibName:@"AliveListStockPoolTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"AliveListStockPoolTableViewCellID"];
        
        
    }
    
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationUI];
    self.view.backgroundColor = TDViewBackgrouondColor;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)configNavigationUI {
    self.title = @"我的订阅";
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"订阅历史" forState:UIControlStateNormal];
    [rightBtn setTitleColor:TDTitleTextColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(historySubcriptionClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

#pragma mark - actions
- (void)historySubcriptionClick:(UIButton *)sender {
    
    
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AliveListStockPoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListStockPoolTableViewCellID" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = [UIColor clearColor];
    return headerV;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerV = [[UIView alloc] init];
    footerV.backgroundColor = [UIColor clearColor];
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 45;
    }else {
        return 10;
    }
}







- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消\n订阅";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否取消收藏" message:@"\n取消收藏，将不在列表中显示\n" preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    //        [self cancelEditWithIndexPath:indexPath];
    //    }];
    //    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    //        [self deleteWithIndexPath:indexPath];
    //    }];
    //    [alert addAction:cancel];
    //    [alert addAction:done];
    //    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cancelEditWithIndexPath:(NSIndexPath *)indexPath {
    //    [self.tableView beginUpdates];
    //
    //    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //    [self.tableView endUpdates];
}

- (void)deleteWithIndexPath:(NSIndexPath *)indexPath {
    //    NSDictionary *dict;
    //
    //    if (self.type == kCollectionHot) {
    //        StockHotModel *model = self.itemList[indexPath.row];
    //        dict = @{@"collect_id": model.collectedId};
    //    } else {
    //        StockSurveyModel *model = self.itemList[indexPath.row];
    //        dict = @{@"collect_id": model.collectedId};
    //    }
    //
    //    NetworkManager *manager = [[NetworkManager alloc] init];
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.label.text = @"取消收藏";
    //    [manager POST:API_CancelCollection parameters:dict completion:^(id data, NSError *error){
    //        if (!error) {
    //            [hud hideAnimated:YES];
    //            [self deleteSuccessedWithIndexPath:indexPath];
    //        } else {
    //            hud.label.text = @"取消收藏失败";
    //            [hud hideAnimated:YES afterDelay:0.8];
    //        }
    //
    //    }];
}

- (void)deleteSuccessedWithIndexPath:(NSIndexPath *)indexPath {
    //    [self.tableView beginUpdates];
    //
    //    NSMutableArray *array = [NSMutableArray arrayWithArray:self.itemList];
    //    [array removeObjectAtIndex:indexPath.row];
    //    self.itemList = array;
    //    
    //    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    //    [self.tableView endUpdates];
}
@end

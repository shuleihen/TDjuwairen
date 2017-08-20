//
//  StockPoolSubscribeController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSubscribeController.h"
#import "NetworkManager.h"
#import "AliveListStockPoolTableViewCell.h"
#import "MBProgressHUD.h"
@interface StockPoolSubscribeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@end

@implementation StockPoolSubscribeController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
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
    [self loadMCStockPoolSubscribeData];
    _sourceArr = [NSMutableArray new];
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
    if (self.vcType == kMCSPSubscibeVCHistoryType) {
        self.title = @"历史订阅";
        rightBtn.hidden = YES;
    }
    
}

#pragma mark - actions
- (void)historySubcriptionClick:(UIButton *)sender {
    StockPoolSubscribeController *historyVC = [[StockPoolSubscribeController alloc] init];
    historyVC.vcType = kMCSPSubscibeVCHistoryType;
    
    [self.navigationController pushViewController:historyVC animated:YES];
}


- (void)loadMCStockPoolSubscribeData {
    /**
     type	int	0表示我的订阅，1表示历史订阅
     */
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *pDict = @{@"type":@(self.vcType)};
    __weak typeof (self)weakSelf = self;
    [manager GET:API_MyCenterGetUserSubscribeStockPool parameters:pDict completion:^(id data, NSError *error) {
        
        if (!error) {
            
            NSArray *arr = (NSArray *)data;
            
            [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AliveListStockPoolModel *model = [[AliveListStockPoolModel alloc] initWithDictionary:obj];
                [weakSelf.sourceArr addObject:model];
            }];
            
            [self.tableView reloadData];
        }
        
    }];
    
}


#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_sourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AliveListStockPoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListStockPoolTableViewCellID" forIndexPath:indexPath];
    [cell setupAliveStockPool:_sourceArr[indexPath.row]];
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
    
   return self.vcType == kMCSPSubscibeVCHistoryType?@"删除\r\n记录":@"取消\r\n订阅";

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof (self)weakSelf = self;
    AliveListStockPoolModel *model = _sourceArr[indexPath.row];
    if (self.vcType == kMCSPSubscibeVCHistoryType) {
        /** 删除记录*/
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"";
         NetworkManager *manager = [[NetworkManager alloc] init];
         NSDictionary *pDict = @{@"master_id":SafeValue(model.masterId)};
         [manager GET:API_MyCenterDeleteSubscribeStockPool parameters:pDict completion:^(id data, NSError *error) {
             if (!error) {
                 [weakSelf deleteSuccessedWithIndexPath:indexPath];
             }
             [hud hideAnimated:YES afterDelay:.5];
         }];
        return;
    }
    
    if (model.isExpire && !model.isFree) {
        /** 未过期    2天后才能取消订阅*/
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"2天后才能取消订阅" message:@"是否现在取消订阅？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self cancelEditWithIndexPath:indexPath];
        }];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"我意已决" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary *pDict = @{@"master_id":SafeValue(model.masterId)};
            [manager GET:API_MyCenterCancelSubscribeStockPool parameters:pDict completion:^(id data, NSError *error) {
                if (!error) {
                    [weakSelf deleteSuccessedWithIndexPath:indexPath];
                }
            }];
        }];
        [alert addAction:cancel];
        [alert addAction:done];
        [self presentViewController:alert animated:YES completion:nil];
       
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"";
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *pDict = @{@"master_id":SafeValue(model.masterId)};
    [manager GET:API_MyCenterCancelSubscribeStockPool parameters:pDict completion:^(id data, NSError *error) {
        if (!error) {
            
            [weakSelf deleteSuccessedWithIndexPath:indexPath];
        }
        [hud hideAnimated:YES afterDelay:.5];
        
    }];
   
}

- (void)cancelEditWithIndexPath:(NSIndexPath *)indexPath {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
}


- (void)deleteSuccessedWithIndexPath:(NSIndexPath *)indexPath {
        [self.tableView beginUpdates];
        [self.sourceArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
}

@end

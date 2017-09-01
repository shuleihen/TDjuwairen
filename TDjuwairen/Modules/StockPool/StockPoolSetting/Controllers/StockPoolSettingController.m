//
//  StockPoolSettingController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSettingController.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "StockPoolSettingCell.h"
#import "AliveCommentViewController.h"
#import "NetworkManager.h"
#import "StockPoolChargeTypeController.h"
#import "StockPoolPriceModel.h"


#define kStockPoolSettingCellID @"kStockPoolSettingCellID"


@interface StockPoolSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArr;
@property (copy, nonatomic) NSString *introduceStr;
@property (nonatomic, assign) BOOL isOpenEditSwitch;
@property (nonatomic, strong) StockPoolPriceModel *priceModel;

@end

@implementation StockPoolSettingController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44.0f;
        _tableView.tableFooterView = [UIView new];
        
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = TDViewBackgrouondColor;
    [self.view addSubview:self.tableView];
    
    self.titleArr = @[@"股票池设置",@"免费查看股票池",@"收费方式"];
    self.introduceStr = @"";
    
    [self loadStockPoolIntroductMessage];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadStockPoolPriceType];
}


- (void)loadStockPoolIntroductMessage {
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    __weak typeof(self)wSelf = self;
    [manager GET:API_StockPoolGetDesc parameters:nil completion:^(id data, NSError *error) {
        
        if (!error) {
            wSelf.introduceStr = data[@"desc"];
            [wSelf.tableView reloadData];
        }
    }];

}

- (void)loadStockPoolPriceType {
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    [manager GET:API_StockPoolGetPrice parameters:nil completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            if (data != nil) {
                self.priceModel = [[StockPoolPriceModel alloc] initWithDict:data];
                self.isOpenEditSwitch = self.priceModel.isFree;
                [self.tableView reloadData];
            }
        }
    }];
}


- (void)configChangeChargeType {
 
    if (self.priceModel.isFree == NO) {
        // 收费变成免费
        NSDictionary *dict = @{@"key_num":@"0",
                               @"day":@"0",
                               @"term": @"0",
                               @"is_free":@(1)};
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        [manager POST:API_StockPoolSetPrice parameters:dict completion:^(id data, NSError *error) {
            
            if (!error) {
                self.priceModel.isFree = YES;
                self.priceModel.term = 0;
                self.priceModel.key_num = @0;
                self.priceModel.day = @0;
                self.isOpenEditSwitch = YES;
                [self.tableView reloadData];
            }
            
        }];
    } else {
        self.isOpenEditSwitch = NO;
        [self.tableView reloadData];
    }
}


#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.priceModel == nil) {
        return 0;
    }
    return self.isOpenEditSwitch? 2 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockPoolSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:kStockPoolSettingCellID];
    if (cell == nil) {
        cell = [[StockPoolSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStockPoolSettingCellID];
    }
    
    if (indexPath.section == 0) {
        cell.sDescTextView.text = self.introduceStr;
    } else if (indexPath.section == 1) {
        cell.sSwitch.hidden = NO;
        cell.sSwitch.on = self.isOpenEditSwitch;
    } else if (indexPath.section == 2){
        if ([self.priceModel.term isEqual:@1]) {
            cell.billingLabel.text = [NSString stringWithFormat:@"%@把钥匙/周",self.priceModel.key_num];
        } else if ([self.priceModel.term isEqual:@2]) {
            cell.billingLabel.text = [NSString stringWithFormat:@"%@把钥匙/月",self.priceModel.key_num];
        } else {
            cell.billingLabel.text = @"";
        }
        
    } else {
        cell.sDescTextView.text = @"";
        cell.billingLabel.text = @"";
        cell.sSwitch.hidden = YES;
    }
    
    cell.sTitleLabel.text = self.titleArr[indexPath.section];
    __weak typeof(self)weakSelf = self;
    cell.changeBillingBlock = ^() {
        [weakSelf configChangeChargeType];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        AliveCommentViewController *editVC = [[AliveCommentViewController alloc] init];
        editVC.vcType = CommentVCStockPoolSettingType;
        __weak typeof(self)weakSelf = self;
        editVC.commentBlock = ^(){
            [weakSelf loadStockPoolIntroductMessage];
        };
        [self.navigationController pushViewController:editVC animated:YES];
    }else if (indexPath.section == 2) {
    
        StockPoolChargeTypeController *chagerVC = [[StockPoolChargeTypeController alloc] init];
        chagerVC.priceModel = self.priceModel;
        [self.navigationController pushViewController:chagerVC animated:YES];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = [UIColor clearColor];
    return headerV;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerV = [[UIView alloc] init];
    footerV.backgroundColor = [UIColor clearColor];
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = TDDetailTextColor;
    desLabel.font = [UIFont systemFontOfSize:13.0];
    desLabel.numberOfLines = 0;
    desLabel.hidden = section != 2;
    [footerV addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerV).mas_offset(15);
        make.right.equalTo(footerV).mas_offset(-15);
        make.top.bottom.equalTo(footerV);
    }];
    
    if (section == 1) {
        desLabel.text = @"不允许其他用户查看我的股票池";
    } else if (section == 2) {
        if ([self.priceModel.term isEqual:@1]) {
           desLabel.text = [NSString stringWithFormat:@"他人支付%@把钥匙即可查阅我的所有股票池记录\n有效期：1周（不含购买当天）",self.priceModel.key_num];
        } else if ([self.priceModel.term isEqual:@2]) {
            desLabel.text = [NSString stringWithFormat:@"他人支付%@把钥匙即可查阅我的所有股票池记录\n有效期：1个月（不含购买当天）",self.priceModel.key_num];
        } else {
            desLabel.text = @"";
        }
    }
    
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [StockPoolSettingCell loadStockPoolSettingCellHeight:self.introduceStr];
    }else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 45;
    }else {
        return 10;
    }
}

@end

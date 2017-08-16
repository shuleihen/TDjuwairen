//
//  StockPoolSearchViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSearchViewController.h"
#import "NetworkManager.h"

@interface StockPoolSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UISearchBar *customSearchBar;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *searchList;
@end

@implementation StockPoolSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupWithSearchBar];
    [self setupWithTableview];
}

- (void)setupWithSearchBar{
    UIView *titleview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    titleview.backgroundColor = [UIColor whiteColor];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50, 20, 50, 44)];
    back.titleLabel.font = [UIFont systemFontOfSize:16];
    [back setTitle:@"取消" forState:UIControlStateNormal];
    [back setTitleColor:TDTitleTextColor forState:UIControlStateNormal];
    [back setTitleColor:TDTitleTextColor forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(6, 20+7, kScreenWidth-6-50, 30)];
    self.customSearchBar.delegate = self;
    self.customSearchBar.placeholder = @"关键字/股票代码";
    self.customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    UITextField*searchField = [self.customSearchBar valueForKey:@"_searchField"];
    [searchField setValue:TDDetailTextColor forKeyPath:@"_placeholderLabel.textColor"];
    searchField.textColor= TDTitleTextColor;
    
    
    [self.view addSubview:titleview];
    [titleview addSubview:back];
    [titleview addSubview:self.customSearchBar];
}

- (void)setupWithTableview{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableview.separatorInset = UIEdgeInsetsZero;
    self.tableview.separatorColor = TDSeparatorColor;
    self.tableview.backgroundColor = TDViewBackgrouondColor;
    self.tableview.rowHeight = 44.0f;
    [self.view addSubview:self.tableview];
}

- (void)backPressed:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 0 - UISearch
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText.length) {
        return;
    }
    
    NSDictionary *dict = @{@"keyword": searchText};
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_ViewSearchCompnay parameters:dict completion:^(id data, NSError *error) {
        if (!error) {
            self.searchList = data;
        }
        
        [self.tableview reloadData];
    }];
}

#pragma mark - UITableView Data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPSearchCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SPSearchCellID"];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = TDTitleTextColor;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3A76E3"];
        cell.detailTextLabel.text = @"选择";
    }
    
    NSDictionary *dict = self.searchList[indexPath.row];
    NSString *stockName = dict[@"company_name"];
    NSString *stockCode = dict[@"company_code"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",stockName,stockCode];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedBlock) {
        NSDictionary *dict = self.searchList[indexPath.row];
        NSString *stockName = dict[@"company_name"];
        NSString *stockCode = dict[@"company_code"];
        
        self.selectedBlock(stockName, stockCode);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end

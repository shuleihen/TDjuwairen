//
//  AliveSearchAllTypeViewController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveSearchAllTypeViewController.h"
#import "HistoryView.h"
#import "YXSearchButton.h"
#import "YXTitleCustomView.h"
@interface AliveSearchAllTypeViewController (){

    NSMutableArray *searchHistory;
}
@property (weak, nonatomic) IBOutlet HistoryView *historyView;
@property (nonatomic,strong) UISearchBar *customSearchBar;

@end

@implementation AliveSearchAllTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWithSearchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.customSearchBar becomeFirstResponder];
}

- (void)setupWithSearchBar{
    UIView *titleview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    titleview.backgroundColor = [UIColor whiteColor];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50, 20, 50, 44)];
    back.titleLabel.font = [UIFont systemFontOfSize:14];
    [back setTitle:@"取消" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#646464"] forState:UIControlStateNormal];
    [back setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#646464"] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(6, 20+7, kScreenWidth-6-50, 30)];
    //    self.customSearchBar.delegate = self;
    self.customSearchBar.placeholder = @"搜索关键字";
    self.customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    UITextField*searchField = [self.customSearchBar valueForKey:@"_searchField"];
    [searchField setValue:TDDetailTextColor forKeyPath:@"_placeholderLabel.textColor"];
    searchField.textColor= TDTitleTextColor;
    
    
    [self.view addSubview:titleview];
    [titleview addSubview:back];
    [titleview addSubview:self.customSearchBar];
}
- (void)setupHistory {
    self.historyView = [[HistoryView alloc] initWithFrame:CGRectZero];
    
    __weak AliveSearchAllTypeViewController *wself = self;
    self.historyView.clickblock = ^(UIButton *sender){
        NSString *title = sender.titleLabel.text;
        wself.customSearchBar.text = title;
//        [wself requestDataWithText];
    };
//
    self.historyView.clearBlock = ^(UIButton *sender){
//        [wself clearHistoryPressed:sender];
    };
//
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"];
    searchHistory = [[NSMutableArray alloc] initWithArray:array];
    [self.historyView setTagWithTagArray:searchHistory];
}


#pragma mark - SearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //    [self.historyView setTagWithTagArray:searchHistory];
    //    [self.tableview reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //    if (self.customSearchBar.text.length == 0) {
    //        [self.tableview reloadData];
    //    }
    //    else
    //    {
    //        [self requestDataWithText];
    //    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //    NSString *str = [NSString stringWithFormat:@"%@",searchBar.text];
    //    [self addHistoryWithString:str];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
    //    NSString *str = [NSString stringWithFormat:@"%@",searchBar.text];
    //    [self addHistoryWithString:str];
}


#pragma mark - 按钮点击事件
- (IBAction)searchButtonClick:(UIButton *)sender {
    switch (sender.tag - 100) {
        case 1:
            // 用户
            break;
        case 2:
            //股票
            break;
        case 3:
            //调研
            break;
        case 4:
            //话题
            break;
        case 5:
            //贴单
            break;
        case 6:
            //观点
            break;
            
        default:
            break;
    }
    
}

// 取消
- (void)backPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end

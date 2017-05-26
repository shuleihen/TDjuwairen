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
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "SearchResultModel.h"
#import "SearchSectionData.h"


@interface AliveSearchAllTypeViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    NSMutableArray *searchHistory;
}
@property (weak, nonatomic) IBOutlet HistoryView *historyView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyViewLayoutH;
@property (nonatomic,strong) UISearchBar *customSearchBar;
@property (strong, nonatomic) NSMutableArray *searchResultsArrM;
@property (nonatomic, strong) NSArray *resultSections;

@property (nonatomic, strong) NSMutableArray *searchQueue;

@end

@implementation AliveSearchAllTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TDViewBackgrouondColor;
    self.searchQueue = [NSMutableArray arrayWithCapacity:10];
    
    [self configTableViewUI];
    [self setupWithSearchBar];
    [self setupHistory];
    self.searchResultsArrM = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.customSearchBar becomeFirstResponder];
}

- (void)configTableViewUI {
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.backgroundColor = TDViewBackgrouondColor;
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
    self.customSearchBar.delegate = self;
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
    __weak AliveSearchAllTypeViewController *wself = self;
    self.historyView.clickblock = ^(UIButton *sender){
        NSString *title = sender.titleLabel.text;
        wself.customSearchBar.text = title;
        [wself loadSearchData];
    };
    
    self.historyView.clearBlock = ^(UIButton *sender){
        [wself clearHistoryPressed:sender];
    };
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"aliveSearchHistory"];
    searchHistory = [[NSMutableArray alloc] initWithArray:array];
    [self.historyView setTagWithTagArray:searchHistory];
    [self configHistoryViewHidden:searchHistory.count <= 0];
    
    
}

- (void)configHistoryViewHidden:(BOOL)hid {
    if (hid == YES) {
        self.historyViewLayoutH.constant = 0;
        self.historyView.hidden = YES;
    }else {
        self.historyView.hidden = NO;
        self.historyViewLayoutH.constant = self.historyView.realViewHeight;
    }
}

#pragma mark - loadSearchData
- (void)loadSearchData {
    self.tableView.hidden = NO;
    
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dic = nil;
    if (US.isLogIn) {
        dic = @{@"keywords":self.customSearchBar.text,
                @"user_id":US.userId};
    }
    else
    {
        dic = @{@"keywords":self.customSearchBar.text};
    }
    
    __weak AliveSearchAllTypeViewController *wself = self;
    
    [manager POST:API_Search parameters:dic completion:^(id data, NSError *error){
        
        if (![wself needResponseWithNetManager:manager]) {
            return;
        }
        
        if (!error) {
            NSDictionary *dic = data;
            
            NSMutableArray *sections = [NSMutableArray array];
            
            NSArray *stockList = dic[@"stockList"];
            if (stockList) {
                SearchSectionData *sectionData = [[SearchSectionData alloc] init];
                sectionData.sectionTitle = @"股票";
                NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[stockList count]];
                
                for (NSDictionary *dict in stockList) {
                    SearchResultModel *result = [[SearchResultModel alloc] initWithStockDict:dict];
                    [marray addObject:result];
                }
                sectionData.items = marray;
                [sections addObject:sectionData];
            }
            
            NSArray *surveyList = dic[@"surveyList"];
            if (surveyList) {
                SearchSectionData *sectionData = [[SearchSectionData alloc] init];
                sectionData.sectionTitle = @"调研";
                NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[surveyList count]];
                
                for (NSDictionary *dict in surveyList) {
                    SearchResultModel *result = [[SearchResultModel alloc] initWithSurveyDict:dict];
                    [marray addObject:result];
                }
                sectionData.items = marray;
                [sections addObject:sectionData];
            }
            
            //            NSArray *viewList = dic[@"viewList"];
            //            if (viewList) {
            //                SearchSectionData *sectionData = [[SearchSectionData alloc] init];
            //                sectionData.sectionTitle = @"观点";
            //                NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[viewList count]];
            //
            //                for (NSDictionary *dict in viewList) {
            //                    SearchResultModel *result = [[SearchResultModel alloc] initWithViewpointDict:dict];
            //                    [marray addObject:result];
            //                }
            //                sectionData.items = marray;
            //                [sections addObject:sectionData];
            //            }
            /*
             NSArray *videoList = dic[@"videoList"];
             if (videoList) {
             SearchSectionData *sectionData = [[SearchSectionData alloc] init];
             sectionData.sectionTitle = @"视频";
             NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[videoList count]];
             
             for (NSDictionary *dict in videoList) {
             SearchResultModel *result = [[SearchResultModel alloc] initWithSurveyDict:dict];
             [marray addObject:result];
             }
             sectionData.items = marray;
             [sections addObject:sectionData];
             }
             */
            wself.resultSections = sections;
            [wself.tableView reloadData];
            
        } else {
            wself.resultSections = nil;
            [wself.tableView reloadData];
        }
    }];
    
    [self.searchQueue addObject:manager];
    
    
}


- (BOOL)needResponseWithNetManager:(NetworkManager *)manager {
    
    NSInteger index = [self.searchQueue indexOfObject:manager];
    if (index < 0 || index > self.searchQueue.count) {
        return NO;
    }
    
    @synchronized (self.searchQueue) {
        [self.searchQueue removeObjectsInRange:NSMakeRange(0, index+1)];
    }
    
    return YES;
}


#pragma mark - SearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.historyView setTagWithTagArray:searchHistory];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.customSearchBar.text.length == 0) {
        [self.tableView reloadData];
        //            self
        self.tableView.hidden = YES;
        [self configHistoryViewHidden:searchHistory.count <= 0];
    }
    else
    {
        [self configHistoryViewHidden:YES];
        [self loadSearchData];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *str = [NSString stringWithFormat:@"%@",searchBar.text];
    [self addHistoryWithString:str];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
    NSString *str = [NSString stringWithFormat:@"%@",searchBar.text];
    [self addHistoryWithString:str];
}


#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.customSearchBar.text.length == 0) {
        return 1;
    }
    else
    {
        if ([self.resultSections count] == 0) {
            return 1;
        }
        else
        {
            return [self.resultSections count];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.customSearchBar.text.length == 0) {
        return 1;
    }
    else
    {
        if ([self.resultSections count] == 0) {
            return 1;
        }
        else
        {
            SearchSectionData *sectionData = self.resultSections[section];
            return [sectionData.items count];
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.customSearchBar.text.length == 0 ||
        [self.resultSections count] == 0) {
        return nil;
    }
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerV.backgroundColor = [UIColor clearColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 60, 20)];
    nameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    SearchSectionData *sectionData = self.resultSections[section];
    nameLabel.text = sectionData.sectionTitle;
    [headerV addSubview:nameLabel];
    return headerV;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.customSearchBar.text.length == 0 ||
        [self.resultSections count] == 0) {
        return CGFLOAT_MIN;
    }else {
    
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
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


- (void)clearHistoryPressed:(id)sender {
    [searchHistory removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"aliveSearchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
    [self.historyView setTagWithTagArray:nil];
    [self configHistoryViewHidden:YES];
}


#pragma mark - 设置本地搜索缓存
- (void)addHistoryWithString:(NSString *)string {
    
    BOOL isAlreadyExist = NO;
    for (NSString *temp in searchHistory) {
        if ([string isEqualToString:temp]) {
            isAlreadyExist = YES;
        }
    }
    
    if (!isAlreadyExist) {
        if (string.length) {
            [searchHistory insertObject:string atIndex:0];
        }
    }
    
    NSArray *array = [NSArray arrayWithArray:searchHistory];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"aliveSearchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

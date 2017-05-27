//
//  AliveSearchSubTypeController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveSearchSubTypeController.h"
#import "YXSearchButton.h"
#import "YXTitleCustomView.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "SearchResultModel.h"
#import "SearchSectionData.h"
#import "AliveSearchUserCell.h"
#import "AliveSearchStockCell.h"
#import "ApplySurveyViewController.h"
#import "StockDetailViewController.h"
#import "ViewPointTableViewCell.h"

@interface AliveSearchSubTypeController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,AliveSearchStockCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UISearchBar *customSearchBar;
@property (strong, nonatomic) SearchSectionData *searchResultData;
@property (nonatomic, strong) NSMutableArray *searchQueue;
@property (assign, nonatomic) BOOL filterBtnSelected;
@end

@implementation AliveSearchSubTypeController

- (void)setTransmitSearchSectionData:(SearchSectionData *)transmitSearchSectionData {

    _transmitSearchSectionData = transmitSearchSectionData;
    self.searchResultData = transmitSearchSectionData;
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.filterBtnSelected = NO;
    self.searchQueue = [NSMutableArray arrayWithCapacity:10];
    [self configTableViewUI];
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

- (void)configTableViewUI {
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.backgroundColor = TDViewBackgrouondColor;
}

- (void)setupWithSearchBar{
    UIView *titleview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-40, 44)];
    titleview.backgroundColor = [UIColor whiteColor];
    
    self.customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 6, kScreenWidth-95, 30)];
    self.customSearchBar.delegate = self;
    self.customSearchBar.placeholder = [self setSearchBarText];
    self.customSearchBar.text = self.searchTextStr;
    self.customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-95, 0, 50, 44)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#646464"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#646464"] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField*searchField = [self.customSearchBar valueForKey:@"_searchField"];
    [searchField setValue:TDDetailTextColor forKeyPath:@"_placeholderLabel.textColor"];
    searchField.textColor= TDTitleTextColor;
    [titleview addSubview:cancelBtn];
    [titleview addSubview:self.customSearchBar];
    self.navigationItem.titleView = titleview;
    
    
}

#pragma mark - loadSearchData
- (void)loadSearchData {
    
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
    
    __weak AliveSearchSubTypeController *wself = self;
    
    [manager POST:API_Search parameters:dic completion:^(id data, NSError *error){
        
        if (![wself needResponseWithNetManager:manager]) {
            return;
        }
        
        if (!error) {
            NSDictionary *dic = data;
            
            wself.searchResultData = [[SearchSectionData alloc] init];
            
            switch (self.searchType) {
                case AliveSearchSubUserType:
                {
                    wself.searchResultData.sectionTitle = @"用户";
                }
                    break;
                case AliveSearchSubStockType:
                {
                    
                    NSArray *stockList = dic[@"stockList"];
                    if (stockList) {
                        
                        wself.searchResultData.sectionTitle = @"股票";
                        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[stockList count]];
                        
                        for (NSDictionary *dict in stockList) {
                            SearchResultModel *result = [[SearchResultModel alloc] initWithStockDict:dict];
                            [marray addObject:result];
                        }
                        
                        if (marray.count > 0) {
                            wself.searchResultData.items = marray;
                            
                        }
                    }
                }
                    break;
                case AliveSearchSubSurveyType:
                    //
                {
                    NSArray *surveyList = dic[@"surveyList"];
                    if (surveyList) {
                        wself.searchResultData.sectionTitle = @"调研";
                        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[surveyList count]];
                        
                        for (NSDictionary *dict in surveyList) {
                            SearchResultModel *result = [[SearchResultModel alloc] initWithSurveyDict:dict];
                            [marray addObject:result];
                        }
                        
                        if (marray.count > 0) {
                            wself.searchResultData.items = marray;
                            
                        }
                    }
                }
                    break;
                case AliveSearchSubTopicType:
                    //
                {
                    
                    wself.searchResultData.sectionTitle = @"话题";
                }
                    break;
                case AliveSearchSubPasteType:
                    //
                {
                    
                    wself.searchResultData.sectionTitle = @"贴单";
                }
                    break;
                case AliveSearchSubViewPointType:
                    //
                {
                    NSArray *viewList = dic[@"viewList"];
                    if (viewList) {
                        wself.searchResultData.sectionTitle = @"观点";
                        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[viewList count]];
                        
                        for (NSDictionary *dict in viewList) {
                            SearchResultModel *result = [[SearchResultModel alloc] initWithViewpointDict:dict];
                            [marray addObject:result];
                        }
                        if (marray.count > 0) {
                            wself.searchResultData.items = marray;
                            
                        }
                    }
                }
                    break;
                    
                    
                default:
                    break;
            }
            
            [wself.tableView reloadData];
            
            if (self.searchResultData.items.count <= 0) {
                self.tableView.hidden = YES;
                self.noDataView.hidden = NO;
            }else {
                self.tableView.hidden = NO;
                self.noDataView.hidden = YES;
            }
            
        } else {
            wself.searchResultData = nil;
            [wself.tableView reloadData];
            self.tableView.hidden = YES;
            self.noDataView.hidden = NO;
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
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.customSearchBar.text.length == 0) {
        self.searchResultData = nil;
        self.tableView.hidden = YES;
        self.noDataView.hidden = YES;
        
    }
    else
    {
        [self loadSearchData];
    }
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
}


#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchResultData.items count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultModel *result = self.searchResultData.items[indexPath.row];
    
    if ([self.searchResultData.sectionTitle isEqualToString:@"用户"]) {
        
        AliveSearchUserCell *userCell = [AliveSearchUserCell loadAliveSearchUserCellWithTableView:tableView];
        return userCell;
    }else if ([self.searchResultData.sectionTitle isEqualToString:@"股票"]) {
        
        AliveSearchStockCell *stockCell = [AliveSearchStockCell loadAliveSearchStockCellWithTableView:tableView];
        stockCell.delegate = self;
        stockCell.stockModel = result;
        return stockCell;
    }else if ([self.searchResultData.sectionTitle isEqualToString:@"观点"]) {
        
        NSString *identifier = @"viewPointCell";
        ViewPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ViewPointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
//        ViewPointListModel *model = self.viewNewArr[indexPath.row];
//        [cell setupViewPointModel:model];
        
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptyCell"];
        return cell;
    }
    
    
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchResultModel *result = self.searchResultData.items[indexPath.row];
    if ([self.searchResultData.sectionTitle isEqualToString:@"股票"]) {
        StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
        vc.stockCode = result.resultId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.customSearchBar.text.length == 0 ||
        [self.self.searchResultData.items count] == 0) {
        return nil;
    }
    
    
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerV.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 60, 20)];
    nameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    nameLabel.text = self.searchResultData.sectionTitle;
    [headerV addSubview:nameLabel];
    
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(kScreenWidth-122, 5, 110, 20);
    filterButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [filterButton setTitle:@" 只看我关注的" forState:UIControlStateNormal];
    [filterButton setTitleColor:TDLightGrayColor forState:UIControlStateNormal];
    [filterButton setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    [filterButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [filterButton addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    filterButton.selected = self.filterBtnSelected;
    [headerV addSubview:filterButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = TDLineColor;
    [headerV addSubview:lineView];
    
    return headerV;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.searchResultData.sectionTitle isEqualToString:@"用户"] || [self.searchResultData.sectionTitle isEqualToString:@"股票"]) {
        return 49;
    }else if ([self.searchResultData.sectionTitle isEqualToString:@"观点"]) {
        return 284;
    }else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.customSearchBar.text.length == 0 ||
        [self.self.searchResultData.items count] == 0) {
        return CGFLOAT_MIN;
    }else {
        return 30;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    
    return 10;
    
}

#pragma mark - AliveSearchStockCellDelegate
/// 加自选
- (void)addChoiceStockWithSearchResultModel:(SearchResultModel *)model {
    
    if (US.isLogIn) {
        NSDictionary *para = @{@"code":model.resultId,
                               @"user_id":US.userId};
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *str = @"";
        
        if (model.isMyStock == YES) {
            hud.labelText = @"取消关注";
            str = API_SurveyDeleteStock;
        }else {
            str = API_SurveyAddStock;
            
        }
        NetworkManager *manager = [[NetworkManager alloc] init];
        [manager POST:str parameters:para completion:^(id data, NSError *error) {
            if (!error) {
                if (model.isMyStock == YES) {
                    hud.labelText = @"取消成功";
                    model.isMyStock = NO;
                }else {
                    hud.labelText = @"添加成功";
                    model.isMyStock = YES;
                    
                }
                [hud hide:YES afterDelay:0.5];
                [self.tableView reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kAddOptionalStockSuccessed  object:nil];
            }
            else
            {
                
                if (model.isMyStock == YES) {
                    hud.labelText = @"取消失败";
                }else {
                    hud.labelText = @"添加失败";
                    
                }
                
                [hud hide:YES afterDelay:0.5];
                
            }
        }];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
    
    
}


/// 特约
- (void)surveyButtonClickWithSearchResultModel:(SearchResultModel *)model{
    
    if (US.isLogIn) {
        NSString *stockName = [model.title stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@)",model.resultId] withString:@""];
        ApplySurveyViewController *vc = [[UIStoryboard storyboardWithName:@"Survey" bundle:nil] instantiateViewControllerWithIdentifier:@"ApplySurveyViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.stockCode = model.resultId;
        vc.stockName = stockName;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}


#pragma mark - 按钮点击事件
// 取消
- (void)cancelBtnPressed:(UIButton *)sender {
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [arrM removeLastObject];
    [arrM removeLastObject];
    [self.navigationController setViewControllers:[arrM mutableCopy] animated:YES];
  
}

// 筛选列表
- (void)filterButtonClick:(UIButton *)sender {
    self.filterBtnSelected = !self.filterBtnSelected;
    [self.tableView reloadData];
}


- (NSString *)setSearchBarText {
    NSString *str = @"";
    switch (self.searchType) {
        case AliveSearchSubUserType:
        {
            str = @"搜索用户";
        }
            break;
        case AliveSearchSubStockType:
        {
            str = @"搜索股票";
        }
            break;
        case AliveSearchSubSurveyType:
        {
            str = @"搜索调研";
        }
            break;
        case AliveSearchSubTopicType:
        {
            str = @"搜索话题";
        }
            
            break;
        case AliveSearchSubPasteType:
        {
            str = @"搜索贴单";
        }
            break;
        case AliveSearchSubViewPointType:
        {
            str = @"搜索观点";
        }
            
            break;
            
            
        default:
            break;
    }
    return str;
}





@end

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
#import "SearchSectionData.h"
#import "AliveSearchUserCell.h"
#import "AliveSearchStockCell.h"
#import "ApplySurveyViewController.h"
#import "StockDetailViewController.h"
#import "AliveSearchResultModel.h"
#import "AliveRoomViewController.h"
#import "MJRefresh.h"
#import "AliveListModel.h"
#import "AliveListTableViewCell.h"
#import "AliveListCellData.h"
#import "AliveSearchSurveyCell.h"
#import "NSString+Ext.h"
#import "AliveDetailViewController.h"
#import "SurveyDetailWebViewController.h"
#import "ViewpointDetailViewController.h"


@interface AliveSearchSubTypeController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,AliveSearchStockCellDelegate,AliveSearchUserCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UISearchBar *customSearchBar;
@property (strong, nonatomic) SearchSectionData *searchResultData;
@property (nonatomic, strong) NSMutableArray *searchQueue;
@property (assign, nonatomic) BOOL filterBtnSelected;
@property (assign, nonatomic) NSInteger currentPage;
@property (copy, nonatomic) NSString *filterStr;
@property (strong, nonatomic) NSArray *saveResultArr;
@property (assign, nonatomic) BOOL isLoadMore;

@end

@implementation AliveSearchSubTypeController

- (void)setTransmitSearchSectionData:(SearchSectionData *)transmitSearchSectionData {
    
    _transmitSearchSectionData = transmitSearchSectionData;
    self.searchResultData = transmitSearchSectionData;
    self.saveResultArr = [transmitSearchSectionData.items mutableCopy];
    
}

- (void)setNeedLoadData:(BOOL)needLoadData {

    _needLoadData = needLoadData;
    self.customSearchBar.text = self.searchTextStr;
    if (needLoadData == YES) {
        
        [self refreshActions];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filterBtnSelected = NO;
    self.currentPage = 1;
    self.filterStr = @"";
    self.isLoadMore = NO;
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

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.customSearchBar resignFirstResponder];
}

- (void)configTableViewUI {
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    
    [self.tableView registerClass:[AliveListTableViewCell class] forCellReuseIdentifier:@"AliveListTableViewCellID"];
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
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:TDTitleTextColor forState:UIControlStateNormal];
    [cancelBtn setTitleColor:TDTitleTextColor forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField*searchField = [self.customSearchBar valueForKey:@"_searchField"];
    [searchField setValue:TDDetailTextColor forKeyPath:@"_placeholderLabel.textColor"];
    searchField.textColor= TDTitleTextColor;
    [titleview addSubview:cancelBtn];
    [titleview addSubview:self.customSearchBar];
    self.navigationItem.titleView = titleview;
}

#pragma mark - loadSearchData
- (void)refreshActions {
    self.currentPage = 1;
    self.isLoadMore = NO;
    [self loadSearchData];
}

- (void)loadMoreActions {
    self.isLoadMore = YES;
    [self loadSearchData];
}


- (void)loadSearchData {
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dic = @{@"keywords":self.customSearchBar.text,@"type":@(self.searchType+1),@"filter":self.filterStr,@"page":@(self.currentPage)};
    
    __weak AliveSearchSubTypeController *wself = self;
    
    [manager POST:API_AliveSearch parameters:dic completion:^(id data, NSError *error){
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];
        if (![wself needResponseWithNetManager:manager]) {
            return;
        }
        
        if (!error) {
            NSArray *arrM = data;
            NSMutableArray *tempArrM = nil;
            if (self.currentPage == 1) {
                
                tempArrM = [NSMutableArray array];
            }else {
                tempArrM = [NSMutableArray arrayWithArray:[wself.saveResultArr mutableCopy]];
            }
            
            wself.searchResultData = [[SearchSectionData alloc] init];
            wself.searchResultData.searchType = wself.searchType;
            
            switch (wself.searchType) {
                case kAliveSearchSubUserType:
                {
                    if (arrM) {
                        wself.searchResultData.sectionTitle = @"用户";
                        
                        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[arrM count]];
                        
                        for (NSDictionary *dict in arrM) {
                            AliveSearchResultModel *result = [[AliveSearchResultModel alloc] initWithUserListDict:dict];
                            result.searchTextStr = self.customSearchBar.text;
                            [marray addObject:result];
                        }
                        
                        if (marray.count > 0) {
                            [tempArrM addObjectsFromArray:marray];
                            
                        }
                    }
                    
                }
                    break;
                case kAliveSearchSubStockType:
                {
                    if (arrM) {
                        wself.searchResultData.sectionTitle = @"股票";
                        
                        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[arrM count]];
                        
                        for (NSDictionary *dict in arrM) {
                            AliveSearchResultModel *result = [[AliveSearchResultModel alloc] initWithStockListDict:dict];
                            result.searchTextStr = self.customSearchBar.text;
                            [marray addObject:result];
                        }
                        
                        if (marray.count > 0) {
                            [tempArrM addObjectsFromArray:marray];
                            
                        }
                    }
                    
                }
                    break;
                case kAliveSearchSubSurveyType:
                    
                {
                    if (arrM) {
                        wself.searchResultData.sectionTitle = @"调研";
                        
                        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[arrM count]];
                        
                        for (NSDictionary *dict in arrM) {
                            AliveSearchResultModel *result = [[AliveSearchResultModel alloc] initWithSurveyListDict:dict];
                            result.searchTextStr = self.customSearchBar.text;
                            [marray addObject:result];
                        }
                        
                        if (marray.count > 0) {
                            [tempArrM addObjectsFromArray:marray];
                            
                        }
                    }
                }
                    break;
                case kAliveSearchSubTopicType:
                {
                    
                    if (arrM) {
                        wself.searchResultData.sectionTitle = @"话题";
                        
                        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[arrM count]];
                        
                        for (NSDictionary *dict in arrM) {
                            AliveListModel *result = [[AliveListModel alloc] initWithDictionary:dict];
                           result.searchTextStr = self.customSearchBar.text;
                            [marray addObject:result];
                        }
                        
                        if (marray.count > 0) {
                            NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:marray.count];
                            for (AliveListModel *model in marray) {
                                AliveListCellData *cellData = [AliveListCellData cellDataWithAliveModel:model];
                                cellData.isShowDetailMessage = NO;
                                cellData.isShowBottomView = NO;
                                [cellData setup];
                                [cellArray addObject:cellData];
                            }
                            
                            [tempArrM addObjectsFromArray:cellArray];
                        }
                    }
                }
                    break;
                case kAliveSearchSubPasteType:
                {
                    if (arrM) {
                        wself.searchResultData.sectionTitle = @"推单";
                        
                        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[arrM count]];
                        
                        for (NSDictionary *dict in arrM) {
                            AliveListModel *result = [[AliveListModel alloc] initWithDictionary:dict];
                            result.searchTextStr = self.customSearchBar.text;
                            [marray addObject:result];
                        }
                        
                        if (marray.count > 0) {
                            NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:marray.count];
                            for (AliveListModel *model in marray) {
                                AliveListCellData *cellData = [AliveListCellData cellDataWithAliveModel:model];
                                cellData.isShowDetailMessage = NO;
                                cellData.isShowBottomView = NO;
                                [cellData setup];
                                [cellArray addObject:cellData];
                            }
                            
                            [tempArrM addObjectsFromArray:cellArray];
                        }
                    }
                }
                    break;
                case kAliveSearchSubViewPointType:
                    //
                {
                    if (arrM) {
                        wself.searchResultData.sectionTitle = @"观点";
                        
                        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[arrM count]];
                        
                        for (NSDictionary *dict in arrM) {
                            AliveListModel *result = [[AliveListModel alloc] initWithDictionary:dict];
                            result.searchTextStr = self.customSearchBar.text;
                            [marray addObject:result];
                        }
                        
                        if (marray.count > 0) {
                            NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:marray.count];
                            for (AliveListModel *model in marray) {
                                AliveListCellData *cellData = [AliveListCellData cellDataWithAliveModel:model];
                                cellData.isShowDetailMessage = NO;
                                cellData.isShowBottomView = NO;
                                [cellData setup];
                                [cellArray addObject:cellData];
                            }
                            
                            [tempArrM addObjectsFromArray:cellArray];
                        }
                    }
                }
                    break;
                    
                    
                default:
                    break;
            }
            
            self.saveResultArr = [NSArray arrayWithArray:[tempArrM mutableCopy]];
            
            NSMutableArray *filterArrM = [NSMutableArray array];
            if (self.filterBtnSelected == YES) {
                // 只看关注
                for (AliveListCellData *cellModel in self.saveResultArr) {
                    AliveListModel *model = cellModel.aliveModel;
                    if (model.isAttend == YES) {
                        [filterArrM addObject:cellModel];
                    }
                }
                self.searchResultData.items = [filterArrM mutableCopy];
            }else {
                self.searchResultData.items = [self.saveResultArr mutableCopy];
                
            }
            
            [wself.tableView reloadData];
            
            if (tempArrM.count <= 0) {
                self.tableView.hidden = YES;
                self.noDataView.hidden = NO;
            }else {
                self.tableView.hidden = NO;
                self.noDataView.hidden = YES;
            }
            self.currentPage++;
            
        }
        else {
            
            if (self.isLoadMore == NO) {
                wself.searchResultData = nil;
                [wself.tableView reloadData];
                self.tableView.hidden = YES;
                self.noDataView.hidden = NO;
            }
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
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
        self.saveResultArr = nil;
        self.tableView.hidden = YES;
        self.noDataView.hidden = YES;
    }
    else
    {
        [self refreshActions];
        
    }
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchType == kAliveSearchSubUserType || self.searchType == kAliveSearchSubStockType) {
        return 1;
    }else {
        if (self.searchType == kAliveSearchSubTopicType || self.searchType == kAliveSearchSubPasteType) {
            
            return MAX([self.searchResultData.items count], 1);
            
        }else {
            
            return [self.searchResultData.items count];
        }
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchType == kAliveSearchSubUserType || self.searchType == kAliveSearchSubStockType) {
        return [self.searchResultData.items count];
    }else {
        return [self.searchResultData.items count]<=0?0:1;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchType == kAliveSearchSubUserType) {
        // 用户
        AliveSearchResultModel *result = self.searchResultData.items[indexPath.row];
        
        AliveSearchUserCell *userCell = [AliveSearchUserCell loadAliveSearchUserCellWithTableView:tableView];
        userCell.delegate = self;
        userCell.tag = indexPath.row;
        userCell.userModel = result;
        return userCell;
    } else if (self.searchType == kAliveSearchSubStockType) {
        // 股票
        AliveSearchResultModel *result = self.searchResultData.items[indexPath.row];
        AliveSearchStockCell *stockCell = [AliveSearchStockCell loadAliveSearchStockCellWithTableView:tableView];
        stockCell.tag = indexPath.row;
        stockCell.delegate = self;
        stockCell.stockModel = result;
        return stockCell;
    } else if (self.searchType == kAliveSearchSubSurveyType) {
        // 调研
        AliveSearchResultModel *result = self.searchResultData.items[indexPath.section];
        AliveSearchSurveyCell *surveyCell = [AliveSearchSurveyCell loadAliveSearchSurveyCellWithTableView:tableView];
        surveyCell.surveyModel = result;
        return surveyCell;
    } else if (self.searchType == kAliveSearchSubPasteType ||
               self.searchType == kAliveSearchSubTopicType ||
               self.searchType == kAliveSearchSubViewPointType) {
        AliveListCellData *model = self.searchResultData.items[indexPath.section];
        AliveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListTableViewCellID"];
        [cell setupAliveListCellData:model];
        cell.aliveHeaderView.arrowButton.hidden = YES;
        cell.tag = indexPath.section;
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptyCell"];
        return cell;
    }
    
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AliveSearchResultModel *result = self.searchResultData.items[indexPath.row];
    if (self.searchType == kAliveSearchSubStockType) {
        StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
        vc.stockCode = result.company_code;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.searchType == kAliveSearchSubUserType) {
        if (result.userID.length<= 0) {
            return;
        }
        AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:result.userID];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.searchType == kAliveSearchSubViewPointType) {
        AliveListCellData *cellModel = self.searchResultData.items[indexPath.section];
        AliveListModel *model = cellModel.aliveModel;
        
        ViewpointDetailViewController *vc = [[ViewpointDetailViewController alloc] initWithAliveId:model.aliveId aliveType:model.aliveType];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.searchType == kAliveSearchSubPasteType ||
              self.searchType == kAliveSearchSubTopicType) {
        AliveListCellData *cellModel = self.searchResultData.items[indexPath.section];
        AliveListModel *model = cellModel.aliveModel;

        AliveDetailViewController *vc = [[AliveDetailViewController alloc] init];
        vc.aliveID = model.aliveId;
        vc.aliveType = (self.searchType == kAliveSearchSubPasteType)?kAlivePosts:kAliveNormal;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (self.searchType == kAliveSearchSubSurveyType){
        // 调研
        AliveSearchResultModel *model = self.searchResultData.items[indexPath.section];
        if (model.isUnlock) {
            SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
            vc.contentId = model.survey_id;
            vc.stockCode = model.company_code;
            vc.stockName = model.company_name;
            vc.surveyType = model.survey_type;
            vc.url = [SurveyDetailContentViewController contenWebUrlWithContentId:model.survey_id withTag:model.survey_type];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
            vc.stockCode = result.company_code;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.customSearchBar.text.length == 0 ||
        [self.self.saveResultArr count] == 0) {
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
    
    if (self.searchType == kAliveSearchSubTopicType || self.searchType == kAliveSearchSubPasteType || self.searchType == kAliveSearchSubViewPointType) {
        filterButton.hidden = NO;
    }else {
        filterButton.hidden = YES;
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = TDLineColor;
    [headerV addSubview:lineView];
    
    if (section == 0) {
        
        return headerV;
    }else {
        
        return nil;
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchType == kAliveSearchSubUserType ||
        self.searchType == kAliveSearchSubStockType) {
        return 49;
    } else if (self.searchType == kAliveSearchSubSurveyType) {
        // 调研
        AliveSearchResultModel *result = self.searchResultData.items[indexPath.section];
        return [AliveSearchSurveyCell heightWithAliveModel:result];
    } else if (self.searchType == kAliveSearchSubPasteType ||
              self.searchType == kAliveSearchSubTopicType ||
              self.searchType == kAliveSearchSubViewPointType) {
        if ([self.searchResultData.items count] <= 0) {
            return CGFLOAT_MIN;
        } else {
            AliveListCellData *cellData = self.searchResultData.items[indexPath.section];
            return cellData.cellHeight;
        }
    } else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.customSearchBar.text.length == 0 ||
        [self.self.saveResultArr count] == 0) {
        return CGFLOAT_MIN;
    }else {
        if (section == 0) {
            
            return 30;
        }else {
            
            return CGFLOAT_MIN;
        }
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
    
}

#pragma mark - AliveSearchStockCellDelegate
/// 加自选
- (void)addChoiceStockWithSearchResultModel:(AliveSearchResultModel *)model andCellIndex:(NSInteger)index {
    
    if (US.isLogIn) {
        
        NSInteger section = index/100;
        NSInteger row = index%100;
        
        NSDictionary *para = @{@"code":model.company_code,
                               @"user_id":US.userId};
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *str = @"";
        
        if (model.isMyStock == YES) {
            hud.label.text = @"取消关注";
            str = API_SurveyDeleteStock;
        }else {
            str = API_SurveyAddStock;
            
        }
        NetworkManager *manager = [[NetworkManager alloc] init];
        [manager POST:str parameters:para completion:^(id data, NSError *error) {
            if (!error) {
                if (model.isMyStock == YES) {
                    hud.label.text = @"取消成功";
                    model.isMyStock = NO;
                }else {
                    hud.label.text = @"添加成功";
                    model.isMyStock = YES;
                    
                }
                [hud hideAnimated:YES afterDelay:0.5];
                
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kAddOptionalStockSuccessed  object:nil];
            }
            else
            {
                
                if (model.isMyStock == YES) {
                    hud.label.text = @"取消失败";
                }else {
                    hud.label.text = @"添加失败";
                    
                }
                
                [hud hideAnimated:YES afterDelay:0.5];
                
            }
        }];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
    
    
}

/// 特约
- (void)surveyButtonClickWithSearchResultModel:(AliveSearchResultModel *)model{
    
    if (US.isLogIn) {
        NSString *stockName = [model.company_name stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@)",model.company_code] withString:@""];
        ApplySurveyViewController *vc = [[UIStoryboard storyboardWithName:@"Survey" bundle:nil] instantiateViewControllerWithIdentifier:@"ApplySurveyViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.stockCode = model.company_code;
        vc.stockName = stockName;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}



#pragma mark - AliveSearchUserCellDelegate 关注／取消关注操作
- (void)addAttendWithAliveSearchResultModel:(AliveSearchResultModel *)userModel andCellIndex:(NSInteger)index {
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    if (userModel.userID.length <= 0) {
        return ;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *str = API_AliveAddAttention;
    if (userModel.isAttend == YES) {
        // 取消关注
        str = API_AliveDelAttention;
        hud.label.text = @"取消关注";
    }
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    [manager POST:str parameters:@{@"user_id":userModel.userID} completion:^(id data, NSError *error){
        
        if (!error) {
            
            if (data && [data[@"status"] integerValue] == 1) {
                
                if (userModel.isAttend == YES) {
                    hud.label.text = @"取消成功";
                }else {
                    hud.label.text = @"添加成功";
                    
                }
                [hud hideAnimated:YES afterDelay:0.5];
                userModel.isAttend = !userModel.isAttend;
                
                for (AliveSearchResultModel *model in self.saveResultArr) {
                    if ([userModel.userID isEqualToString:model.userID]) {
                        model.isAttend = userModel.isAttend;
                    }
                }
                
                
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
                
            }
        } else {
            
            if (userModel.isAttend == YES) {
                hud.label.text = @"取消失败";
            }else {
                hud.label.text = @"添加失败";
            }
            
            [hud hideAnimated:YES afterDelay:0.5];
        }
        
    }];
    
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
    NSMutableArray *arrM = [NSMutableArray array];
    if (self.filterBtnSelected == YES) {
        self.filterStr = @"attend";
        // 只看关注
        for (AliveListCellData *cellModel in self.saveResultArr) {
            AliveListModel *model = cellModel.aliveModel;
            if (model.isAttend == YES) {
                [arrM addObject:cellModel];
            }
        }
        self.searchResultData.items = [arrM mutableCopy];
    }else {
        self.filterStr = @"";
        self.searchResultData.items = [self.saveResultArr mutableCopy];
        
    }
    [self.tableView reloadData];
}


- (NSString *)setSearchBarText {
    NSString *str = @"";
    switch (self.searchType) {
        case kAliveSearchSubUserType:
        {
            str = @"搜索用户";
        }
            break;
        case kAliveSearchSubStockType:
        {
            str = @"搜索股票";
        }
            break;
        case kAliveSearchSubSurveyType:
        {
            str = @"搜索调研";
        }
            break;
        case kAliveSearchSubTopicType:
        {
            str = @"搜索话题";
        }
            
            break;
        case kAliveSearchSubPasteType:
        {
            str = @"搜索推单";
        }
            break;
        case kAliveSearchSubViewPointType:
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

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
#import "AliveSearchUserCell.h"
#import "AliveSearchStockCell.h"
#import "ApplySurveyViewController.h"
#import "AliveSearchSubTypeController.h"
#import "StockDetailViewController.h"


@interface AliveSearchAllTypeViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,AliveSearchStockCellDelegate>
{
    
    NSMutableArray *searchHistory;
}
@property (weak, nonatomic) IBOutlet HistoryView *historyView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyViewLayoutH;
@property (nonatomic,strong) UISearchBar *customSearchBar;
@property (nonatomic, strong) NSArray *resultSections;

@property (nonatomic, strong) NSMutableArray *searchQueue;
@property (weak, nonatomic) IBOutlet UIView *noDataView;

@end

@implementation AliveSearchAllTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchQueue = [NSMutableArray arrayWithCapacity:10];
    
    [self configTableViewUI];
    [self setupWithSearchBar];
    [self setupHistory];
    
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
    self.historyView.historyViewOriginY = 64;
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
        self.historyView.hidden = YES;
        self.historyViewLayoutH.constant = 0;
    }else {
        self.historyView.hidden = NO;
        self.historyViewLayoutH.constant = self.historyView.realViewHeight;
    }
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
                
                if (marray.count > 0) {
                    sectionData.items = marray;
                    [sections addObject:sectionData];
                    
                }
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
                
                if (marray.count > 0) {
                    sectionData.items = marray;
                    [sections addObject:sectionData];
                
                }
            }
            
            NSArray *viewList = dic[@"viewList"];
            if (viewList) {
                SearchSectionData *sectionData = [[SearchSectionData alloc] init];
                sectionData.sectionTitle = @"观点";
                NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[viewList count]];
                
                for (NSDictionary *dict in viewList) {
                    SearchResultModel *result = [[SearchResultModel alloc] initWithViewpointDict:dict];
                    [marray addObject:result];
                }
                if (marray.count > 0) {
                    sectionData.items = marray;
                    [sections addObject:sectionData];
                    
                }
            }
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
            
            if (self.resultSections.count <= 0) {
                self.tableView.hidden = YES;
                self.noDataView.hidden = NO;
            }else {
                self.tableView.hidden = NO;
                self.noDataView.hidden = YES;
            }
            
        } else {
            wself.resultSections = nil;
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
    [self.historyView setTagWithTagArray:searchHistory];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.customSearchBar.text.length == 0) {
        self.resultSections = nil;
        self.tableView.hidden = YES;
        self.noDataView.hidden = YES;
        [self configHistoryViewHidden:searchHistory.count <= 0];
    }
    else
    {
        [self loadSearchData];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    if (searchBar.text.length <= 0) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@",searchBar.text];
    [self addHistoryWithString:str];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
}



#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.resultSections count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SearchSectionData *sectionData = self.resultSections[section];
    
    if ([sectionData.sectionTitle isEqualToString:@"用户"] || [sectionData.sectionTitle isEqualToString:@"股票"]) {
        if ([sectionData.items count] <= 0) {
            return 0;
        }else if ([sectionData.items count] > 2) {
            
            return 3;
        }else {
            
            return [sectionData.items count];
        }
    }else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchSectionData *sectionData = self.resultSections[indexPath.section];
     SearchResultModel *result = sectionData.items[indexPath.row];
    if (indexPath.row == 2) {
        UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"showMoreCell"];
        if (moreCell == nil) {
            
            moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"showMoreCell"];
        }
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 120, 20)];
        nameLabel.textColor = TDTitleTextColor;
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        nameLabel.text = sectionData.sectionTitle;
        [moreCell.contentView addSubview:nameLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-21, 14, 9, 16)];
        arrowImageView.image = [UIImage imageNamed:@"icon_arrow.png"];
        [moreCell.contentView addSubview:arrowImageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
        lineView.backgroundColor = TDLineColor;
        [moreCell.contentView addSubview:lineView];
        if ([sectionData.sectionTitle isEqualToString:@"用户"]) {
            nameLabel.text = @"查看更多用户";
        }else {
            nameLabel.text = @"查看更多股票";
        }
        
        return moreCell;
    }else {
        if ([sectionData.sectionTitle isEqualToString:@"用户"]) {
            
            AliveSearchUserCell *userCell = [AliveSearchUserCell loadAliveSearchUserCellWithTableView:tableView];
            return userCell;
        }else if ([sectionData.sectionTitle isEqualToString:@"股票"]) {
            
            AliveSearchStockCell *stockCell = [AliveSearchStockCell loadAliveSearchStockCellWithTableView:tableView];
            stockCell.delegate = self;
            stockCell.stockModel = result;
            return stockCell;
        }else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptyCell"];
            return cell;
        }
    }
    
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchSectionData *sectionData = self.resultSections[indexPath.section];
    SearchResultModel *result = sectionData.items[indexPath.row];
    
    if (indexPath.row == 2) {
        UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tempButton.tag = indexPath.section;
        [self searchMoreButtonClick:tempButton];
        
    }else {
        if ([sectionData.sectionTitle isEqualToString:@"股票"]) {
            StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
            vc.stockCode = result.resultId;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.customSearchBar.text.length == 0 ||
        [self.resultSections count] == 0) {
        return nil;
    }
    SearchSectionData *sectionData = self.resultSections[section];
    
    CGFloat viewH = 30;
    if ([sectionData.sectionTitle isEqualToString:@"用户"] || [sectionData.sectionTitle isEqualToString:@"股票"]) {
        viewH = 30;
    }else {
        
        viewH = 44;
    }
    
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, viewH)];
    headerV.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, (viewH-20)*0.5, 60, 20)];
    nameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    nameLabel.text = sectionData.sectionTitle;
    [headerV addSubview:nameLabel];
    
    UIButton *searchMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchMoreBtn.frame = CGRectMake(0, 0, kScreenWidth, 30);
    [searchMoreBtn addTarget:self action:@selector(searchMoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    searchMoreBtn.tag = section;
    [headerV addSubview:searchMoreBtn];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-21, (viewH-16)*0.5, 9, 16)];
    arrowImageView.image = [UIImage imageNamed:@"icon_arrow.png"];
    [headerV addSubview:arrowImageView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, viewH-0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = TDLineColor;
    [headerV addSubview:lineView];
    
    if ([sectionData.sectionTitle isEqualToString:@"用户"] || [sectionData.sectionTitle isEqualToString:@"股票"]) {
        searchMoreBtn.userInteractionEnabled = NO;
        arrowImageView.hidden = YES;
    }else {
    
        searchMoreBtn.userInteractionEnabled = YES;
        arrowImageView.hidden = NO;
    }
    
    return headerV;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1) {
        return 44;
    }else {
    
        return 49;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.customSearchBar.text.length == 0 ||
        [self.resultSections count] == 0) {
        return CGFLOAT_MIN;
    }else {
         SearchSectionData *sectionData = self.resultSections[section];
        if ([sectionData.sectionTitle isEqualToString:@"用户"] || [sectionData.sectionTitle isEqualToString:@"股票"]) {
            return 30;
        }else {
        
          return 44;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SearchSectionData *sectionData = self.resultSections[section];
    if ([sectionData.sectionTitle isEqualToString:@"用户"] || [sectionData.sectionTitle isEqualToString:@"股票"]) {
        return 10;
    }else {
    
        return CGFLOAT_MIN;
    }
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
- (IBAction)searchButtonClick:(UIButton *)sender {
    AliveSearchSubTypeController *subSearchVC = [[AliveSearchSubTypeController alloc] init];

    subSearchVC.searchType = sender.tag-1001;

    [self.navigationController pushViewController:subSearchVC animated:YES];
    
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


/// 搜索更多信息
- (void)searchMoreButtonClick:(UIButton *)sender {
    SearchSectionData *sectionData = self.resultSections[sender.tag];
    AliveSearchSubTypeController *subSearchVC = [[AliveSearchSubTypeController alloc] init];
    if ([sectionData.sectionTitle isEqualToString:@"用户"]) {
        
        subSearchVC.searchType = AliveSearchSubUserType;
        
    }else if ([sectionData.sectionTitle isEqualToString:@"股票"]) {
        
        subSearchVC.searchType = AliveSearchSubStockType;
        
    }else if ([sectionData.sectionTitle isEqualToString:@"调研"]) {
        
        subSearchVC.searchType = AliveSearchSubSurveyType;
        
    }else if ([sectionData.sectionTitle isEqualToString:@"话题"]) {
        
        subSearchVC.searchType = AliveSearchSubTopicType;
        
    }else if ([sectionData.sectionTitle isEqualToString:@"贴单"]) {
        
        subSearchVC.searchType = AliveSearchSubPasteType;
    }else {
        subSearchVC.searchType = AliveSearchSubViewPointType;
    }
    
    subSearchVC.searchTextStr = self.customSearchBar.text;
    subSearchVC.transmitSearchSectionData = sectionData;

    [self.navigationController pushViewController:subSearchVC animated:YES];
    
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

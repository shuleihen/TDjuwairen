//
//  SearchViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SearchViewController.h"
#import "HistoryView.h"
#import "SurveyListModel.h"
#import "SearchResultTableViewCell.h"
#import "DetailPageViewController.h"
#import "LoginViewController.h"
#import "HexColors.h"
#import "NSString+Ext.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "LoginState.h"
#import "StockDetailViewController.h"
#import "SearchResultModel.h"
#import "NoResultView.h"
#import "ApplySurveyViewController.h"
#import "NotificationDef.h"
#import "SearchSectionData.h"


@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate, SearchResultCellDelegate>
{
    NSMutableArray *resultArr;
    NSMutableArray *searchHistory;
  
    CGSize titlesize;
    CGSize textsize;
}
@property (nonatomic,strong) UISearchBar *customSearchBar;
@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) NSMutableArray *searchList;
@property (nonatomic,strong) NSMutableArray *allName;

@property (nonatomic,strong) NSMutableArray *tagsFrames;

@property (nonatomic,strong) HistoryView *historyView;
@property (nonatomic, strong) NoResultView *noResultView;

@property (nonatomic,strong) NSMutableArray *surveydata;
@property (nonatomic,strong) NSMutableArray *researchdata;
@property (nonatomic,strong) NSMutableArray *videodata;

@property (nonatomic, strong) NSArray *resultSections;

@property (nonatomic, strong) NSMutableArray *searchQueue;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TDViewBackgrouondColor;
    self.searchQueue = [NSMutableArray arrayWithCapacity:10];
    
    self.surveydata = [NSMutableArray array];
    self.researchdata = [NSMutableArray array];
    self.videodata = [NSMutableArray array];
    
    [self setupWithSearchBar];
    [self setupWithTableview];
    [self setupHistory];
    [self setupNoResultView];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    
    if (self.searchTags != nil) {
        self.customSearchBar.text = self.searchTags;
        [self requestDataWithText];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.customSearchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableview.separatorInset = UIEdgeInsetsZero;
    self.tableview.separatorColor = TDSeparatorColor;
    self.tableview.backgroundColor = TDViewBackgrouondColor;
    [self.view addSubview:self.tableview];
    
    UINib *nib = [UINib nibWithNibName:@"SearchResultTableViewCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"SearchResultCellID"];
}

- (void)setupHistory {
    self.historyView = [[HistoryView alloc] initWithFrame:CGRectZero];
    
    __weak SearchViewController *wself = self;
    self.historyView.clickblock = ^(UIButton *sender){
        NSString *title = sender.titleLabel.text;
        wself.customSearchBar.text = title;
        [wself requestDataWithText];
    };
    
    self.historyView.clearBlock = ^(UIButton *sender){
        [wself clearHistoryPressed:sender];
    };
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"];
    searchHistory = [[NSMutableArray alloc] initWithArray:array];
    [self.historyView setTagWithTagArray:searchHistory];
}

- (void)setupNoResultView {
    self.noResultView = [[NoResultView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    
    __weak SearchViewController *wself = self;
    self.noResultView.buttonClick = ^(UIButton *sender){
        [wself addSurveyPressed:sender];
    };
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (void)requestDataWithText{
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
    
    __weak SearchViewController *wself = self;
    
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
                
                if (marray.count > 0) {
                    
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
                sectionData.items = marray;
                if (marray.count > 0) {
                    
                    [sections addObject:sectionData];
                }
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
            [wself.tableview reloadData];
            
        } else {
            wself.resultSections = nil;
            [wself.tableview reloadData];
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

#pragma mark - SearchResultCellDelegate
- (void)addStockPressedWithResult:(SearchResultModel *)model {
    if (US.isLogIn) {
        NSDictionary *para = @{@"code":model.resultId,
                               @"user_id":US.userId};
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        [manager POST:API_SurveyAddStock parameters:para completion:^(id data, NSError *error) {
            if (!error) {
                hud.labelText = @"添加成功";
                [hud hide:YES afterDelay:0.5];
                
                model.isMyStock = YES;
                [self.tableview reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kAddOptionalStockSuccessed  object:nil];
            }
            else
            {
                hud.labelText = @"添加失败";
                [hud hide:YES afterDelay:0.5];
                
            }
        }];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)invitePressedWithResult:(SearchResultModel *)model {
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

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customSearchBar.text.length == 0) {
        return CGRectGetHeight(self.historyView.frame);
    }
    else
    {
        if ([self.resultSections count] == 0) {
            return CGRectGetHeight(self.noResultView.frame);
        }
        else
        {
            return 44;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.customSearchBar.text.length == 0 ||
        [self.resultSections count] == 0) {
        return 0.001;
    }
    else
    {
        return 36.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.customSearchBar.text.length == 0 ||
        [self.resultSections count] == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 36.0f)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 11, 100, 16)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:14.0f];
    title.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
    [view addSubview:title];
    
    SearchSectionData *sectionData = self.resultSections[section];
    title.text = sectionData.sectionTitle;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customSearchBar.text.length == 0) {
        NSString *identifier = @"HistoryCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.contentView addSubview:self.historyView];
        }
            
        return cell;
    }
    else
    {
        if ([self.resultSections count] == 0) {
            NSString *identifier = @"NoResultCellID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.contentView addSubview:self.noResultView];
            }
            
            return cell;
        }
        else
        {
            SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCellID"];
            SearchSectionData *sectionData = self.resultSections[indexPath.section];
            SearchResultModel *result = sectionData.items[indexPath.row];
            cell.titleLabel.text = result.title;
            cell.searchResult = result;
            cell.isAdd = result.isMyStock;
            cell.delegate = self;
            
            if ([sectionData.sectionTitle isEqualToString:@"股票"]) {
                cell.isStock = YES;
            } else {
                cell.isStock = NO;
            }
            return cell;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];

    if (self.customSearchBar.text.length == 0) {
        
    }
    else
    {
        SearchSectionData *sectionData = self.resultSections[indexPath.section];
        SearchResultModel *result = sectionData.items[indexPath.row];
        if ([sectionData.sectionTitle isEqualToString:@"股票"]) {
            StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
            vc.stockCode = result.resultId;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([sectionData.sectionTitle isEqualToString:@"调研"]) {
            StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
            vc.stockCode = result.resultId;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
//        else if ([sectionData.sectionTitle isEqualToString:@"观点"]) {
//
//            DetailPageViewController *DetailView = [[DetailPageViewController alloc] init];
//            DetailView.view_id = result.resultId;
//            DetailView.pageMode = @"view";
//            [self.navigationController pushViewController:DetailView animated:YES];
//        }
    }
}

#pragma mark - SearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.historyView setTagWithTagArray:searchHistory];
    [self.tableview reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.customSearchBar.text.length == 0) {
        [self.tableview reloadData];
    }
    else
    {
        [self requestDataWithText];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *str = [NSString stringWithFormat:@"%@",searchBar.text];
    [self addHistoryWithString:str];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
//    NSString *str = [NSString stringWithFormat:@"%@",searchBar.text];
//    [self addHistoryWithString:str];
}

#pragma mark - 拖动的时候释放第一响应
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.customSearchBar resignFirstResponder];
}

#pragma mark - Action
- (void)backPressed:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearHistoryPressed:(id)sender {
    [searchHistory removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"searchHistory"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableview reloadData];
    
    [self.historyView setTagWithTagArray:nil];
}

- (void)addSurveyPressed:(id)sender {
    if (US.isLogIn) {
        
        ApplySurveyViewController *vc = [[UIStoryboard storyboardWithName:@"Survey" bundle:nil] instantiateViewControllerWithIdentifier:@"ApplySurveyViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)clickAddOptionalStock:(UIButton *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"关注中";
    
    SurveyListModel *model = self.surveydata[sender.tag-1];
    if (US.isLogIn) {
        NSDictionary *para = @{@"code":model.survey_conpanycode,
                               @"user_id":US.userId};
        if (model.is_mystock) {
            //取消
            NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
            NSString *url = @"Collection/delMyStockCode";
            [manager POST:url parameters:para completion:^(id data, NSError *error) {
                if (!error) {
                    NSLog(@"%@",data);
                    [self requestDataWithText];
                    hud.labelText = @"取消成功";
                    [hud hide:YES afterDelay:0.5];
                }
                else
                {
                    //                    NSLog(@"%@",error);
                    hud.labelText = @"取消失败";
                    [hud hide:YES afterDelay:0.5];
                }
            }];
        }
        else
        {
            //添加
            NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
            [manager POST:API_SurveyAddStock parameters:para completion:^(id data, NSError *error) {
                if (!error) {
                    NSLog(@"%@",data);
                    [self requestDataWithText];
                    hud.labelText = @"添加成功";
                    [hud hide:YES afterDelay:0.5];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAddOptionalStockSuccessed  object:nil];
                }
                else
                {
                    //                    NSLog(@"%@",error);
                    hud.labelText = @"添加失败";
                    [hud hide:YES afterDelay:0.5];
                    
                }
            }];
        }
    }
    else
    {
        [hud hide:YES afterDelay:0.0];
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

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
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"searchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clickSubmit:(UIButton *)sender
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    hud.labelText = @"提交成功";
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud hide:YES afterDelay:0.1f];
    }];
}

- (void)submitClick:(id)sender
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    hud.labelText = @"提交成功";
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud hide:YES afterDelay:0.1f];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
#import "ViewPointListModel.h"
#import "SearchResultTableViewCell.h"
#import "DetailPageViewController.h"
#import "LoginViewController.h"
#import "HexColors.h"
#import "NSString+Ext.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "UIdaynightModel.h"
#import "LoginState.h"
#import "StockDetailViewController.h"
#import "SearchResultModel.h"
#import "NoResultView.h"
#import "ApplySurveyViewController.h"

@interface SearchSectionData : NSObject
@property (nonatomic, strong) NSString *sectionTitle;
@property (nonatomic, strong) NSArray *items;
@end

@implementation SearchSectionData

@end


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


@property (nonatomic,strong) UIdaynightModel *daynightmodel;

@property (nonatomic, strong) NSArray *resultSections;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    
    self.surveydata = [NSMutableArray array];
    self.researchdata = [NSMutableArray array];
    self.videodata = [NSMutableArray array];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
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
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.customSearchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupWithSearchBar{
    UIView *titleview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    titleview.backgroundColor = self.daynightmodel.navigationColor;
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50, 20, 50, 44)];
    back.titleLabel.font = [UIFont systemFontOfSize:14];
    [back setTitle:@"取消" forState:UIControlStateNormal];
    [back dk_setTitleColorPicker:DKColorPickerWithKey(TITLE) forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(6, 20+7, kScreenWidth-6-50, 30)];
    self.customSearchBar.delegate = self;
    self.customSearchBar.placeholder = @"请输入关键字、股票代码";
    self.customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    //获取searchBar里面的TextField
    UITextField*searchField = [self.customSearchBar valueForKey:@"_searchField"];
    //更改searchBar 中PlaceHolder 字体颜色
    [searchField setValue:self.daynightmodel.titleColor forKeyPath:@"_placeholderLabel.textColor"];
    //更改searchBar输入文字颜色
    searchField.textColor= self.daynightmodel.textColor;
    
    
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
    self.tableview.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    self.tableview.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
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
            
            NSArray *viewList = dic[@"viewList"];
            if (viewList) {
                SearchSectionData *sectionData = [[SearchSectionData alloc] init];
                sectionData.sectionTitle = @"观点";
                NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[viewList count]];
                
                for (NSDictionary *dict in viewList) {
                    SearchResultModel *result = [[SearchResultModel alloc] initWithViewpointDict:dict];
                    [marray addObject:result];
                }
                sectionData.items = marray;
                [sections addObject:sectionData];
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
            [wself.tableview reloadData];
        } else {
            wself.resultSections = nil;
            [wself.tableview reloadData];
        }
    }];
}

#pragma mark - SearchResultCellDelegate
- (void)addStockPressedWithResult:(SearchResultModel *)model {
    if (US.isLogIn) {
        NSDictionary *para = @{@"code":model.resultId,
                               @"user_id":US.userId};
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSString *url = @"Survey/addMyStock";
        [manager POST:url parameters:para completion:^(id data, NSError *error) {
            if (!error) {
                hud.labelText = @"添加成功";
                [hud hide:YES afterDelay:0.5];
                
                model.isMyStock = YES;
                [self.tableview reloadData];
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
        ApplySurveyViewController *vc = [[UIStoryboard storyboardWithName:@"Survey" bundle:nil] instantiateViewControllerWithIdentifier:@"ApplySurveyViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.stockId = model.resultId;
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
    title.dk_textColorPicker = DKColorPickerWithKey(DETAIL);
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
            NSString *code = [result.resultId substringWithRange:NSMakeRange(0, 1)];
            NSString *companyCode ;
            if ([code isEqualToString:@"6"]) {
                companyCode = [NSString stringWithFormat:@"sh%@",result.resultId];
            }
            else
            {
                companyCode = [NSString stringWithFormat:@"sz%@",result.resultId];
            }
            
            StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
            vc.stockId = companyCode;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([sectionData.sectionTitle isEqualToString:@"调研"]) {

            NSString *code = [result.resultId substringWithRange:NSMakeRange(0, 1)];
            NSString *companyCode ;
            if ([code isEqualToString:@"6"]) {
                companyCode = [NSString stringWithFormat:@"sh%@",result.resultId];
            }
            else
            {
                companyCode = [NSString stringWithFormat:@"sz%@",result.resultId];
            }
            
            StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
            vc.stockId = companyCode;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([sectionData.sectionTitle isEqualToString:@"观点"]) {

            DetailPageViewController *DetailView = [[DetailPageViewController alloc] init];
            DetailView.view_id = result.resultId;
            DetailView.pageMode = @"view";
            [self.navigationController pushViewController:DetailView animated:YES];
        }
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
            NSString *url = @"Survey/addMyStock";
            [manager POST:url parameters:para completion:^(id data, NSError *error) {
                if (!error) {
                    NSLog(@"%@",data);
                    [self requestDataWithText];
                    hud.labelText = @"添加成功";
                    [hud hide:YES afterDelay:0.5];
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

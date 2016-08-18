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
#import "HeadForSectionTableViewCell.h"
#import "NoResultTableViewCell.h"
#import "SharpDetailsViewController.h"
#import "NSString+Ext.h"
#import "NetworkManager.h"

@interface SearchViewController ()<UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,NoResultTableViewCellDelegate>
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

@property (nonatomic,strong) HistoryView *tagList;

@property (nonatomic,strong) NSMutableArray *surveydata;
@property (nonatomic,strong) NSMutableArray *researchdata;
@property (nonatomic,strong) NSMutableArray *videodata;

@property (nonatomic,strong) NSUserDefaults *defaults;
@property (nonatomic,strong) NSArray *arr;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    
    self.surveydata = [NSMutableArray array];
    self.researchdata = [NSMutableArray array];
    self.videodata = [NSMutableArray array];
    
    [self setupWithSearchBar];
    [self setupWithTableview];
    
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

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

#pragma mark -  根据字段请求数据
- (void)requestDataWithText{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dic = @{@"keywords":self.customSearchBar.text};
    
    [manager POST:API_Search parameters:dic completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            
            NSArray *arr1 = dic[@"sharp_type1"];
            /* 清空数组 */
            [self.surveydata removeAllObjects];
            if ((NSNull *)arr1 != [NSNull null]) {
                for (NSDictionary *d in arr1) {
                    SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                    [self.surveydata addObject:model];
                }
            }
            
            NSArray *arr2 = dic[@"sharp_type2"];
            /* 清空数组 */
            [self.researchdata removeAllObjects];
            
            if ((NSNull *)arr2 != [NSNull null]) {
                for (NSDictionary *d in arr2) {
                    SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                    [self.researchdata addObject:model];
                }
            }
            
            NSArray *arr3 = dic[@"sharp_type3"];
            /* 清空数组 */
            [self.videodata removeAllObjects];
            if ((NSNull *)arr3 != [NSNull null]) {
                for (NSDictionary *d in arr3) {
                    SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                    [self.videodata addObject:model];
                }
            }
            
            [self.tableview reloadData];
        } else {
            
        }
    }];
}

#pragma mark - 设置titleview
- (void)setupWithSearchBar{
    UIView *titleview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    titleview.backgroundColor = [UIColor whiteColor];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50, 20, 50, 44)];
    back.titleLabel.font = [UIFont systemFontOfSize:16];
    [back setTitle:@"取消" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(ClickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    self.customSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(15, 20+7, kScreenWidth-15-50, 30)];
    self.customSearchBar.delegate = self;
    self.customSearchBar.placeholder = @"请输入关键字、股票代码";
    self.customSearchBar.layer.borderColor = [UIColor grayColor].CGColor;
    self.customSearchBar.barTintColor = [UIColor whiteColor];
    self.customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    [self.view addSubview:titleview];
    [titleview addSubview:back];
    [titleview addSubview:self.customSearchBar];
}

#pragma mark - 设置tableview初始化UserDefaults
- (void)setupWithTableview{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableview.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    /* 去掉分割线 */
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableview];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.tagList = [[HistoryView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 1)];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.customSearchBar.text.length == 0) {
        return 1;
    }
    else
    {
//        if (self.surveydata.count == 0 && self.researchdata.count == 0 && self.videodata.count == 0) {
//            return 1;
//        }
//        else
//        {
            return 3;
//        }
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.customSearchBar.text.length == 0) {
        return 3;
    }
    else
    {
//        if (self.surveydata.count == 0 && self.researchdata.count == 0 && self.videodata.count == 0) {
//            return 1;
//        }
//        else
//        {
            if (section == 0) {
                if (self.surveydata.count == 0) {
                    return 2;
                }
                else
                {
                    return self.surveydata.count+1;
                }
            }
            else if (section == 1){
                if (self.researchdata.count == 0) {
                    return 2;
                }
                else
                {
                    return self.researchdata.count+1;
                }
            }
            else
            {
                if (self.videodata.count == 0) {
                    return 2;
                }
                else
                {
                    return self.videodata.count+1;
                }
            }
//        }
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customSearchBar.text.length == 0) {
        if (indexPath.row == 0) {
            NSString *identifier = @"titlecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"搜索历史";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 1) {
            NSString *identifier = @"tagscell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backgroundColor = [UIColor clearColor];
            [self.tagList removeFromSuperview];
            self.tagList = [[HistoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
            self.tagList.signalTagColor = [UIColor clearColor];
            self.tagList.BGColor = [UIColor clearColor];
            [self.tagList setTagWithTagArray:searchHistory];
            
            /* 点击标签 */
            __weak SearchViewController *searchview = self;
            searchview.tagList.clickblock = ^(UIButton *sender){
                NSString *title = sender.titleLabel.text;
                self.customSearchBar.text = title;
                [self requestDataWithText];
                [self.tableview reloadData];
            };
            [cell addSubview:self.tagList];
            
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            NSString *identifier = @"cleancell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"清除搜索记录";
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setTextColor: [UIColor grayColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:18.0]];
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    /* 用户输入文本之后 */
    else
    {
//        if (self.surveydata.count == 0 && self.researchdata.count == 0 && self.videodata.count == 0) {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//            }
//            return cell;
//        }
//        else
//        {
            /* 当搜索栏中有字的时候 */
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    /* 这里是标题 */
                    HeadForSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headcell"];
                    if (cell == nil) {
                        cell = [[HeadForSectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headcell"];
                    }
                    cell.imgview.image = [UIImage imageNamed:@"tab_survey_normal"];
                    cell.headlabel.text = @"调研";
                    
                    /* cell的选中样式为无色 */
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else
                {
                    if (self.surveydata.count == 0) {
                        NSString *identifier = @"cell";
                        NoResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                        if (cell == nil) {
                            cell = [[NoResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                        }
                        cell.delegate = self;
                        NSString *text = [NSString stringWithFormat:@"您搜索的股票 %@ 尚未调研，按提交，我们将尽快为您调研",self.customSearchBar.text];
                        UIFont *font = [UIFont systemFontOfSize:16];
                        cell.label.font = font;
                        cell.label.numberOfLines = 0;
                        textsize = CGSizeMake(kScreenWidth-100, 500.0);
                        textsize = [text calculateSize:textsize font:font];
                        cell.label.text = text;
                        [cell.label setFrame:CGRectMake(50, 10+40+10, kScreenWidth-100, textsize.height)];
                        
                        [cell.submit setFrame:CGRectMake(50, 10+40+10+textsize.height+30, 70, 30)];
                        cell.submit.center = CGPointMake(kScreenWidth/2, 10+40+10+textsize.height+20+20);
                        /* cell的选中样式为无色 */
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
                    else
                    {
                        SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
                        if (cell == nil) {
                            cell = [[SearchResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
                        }
                        SurveyListModel *model = self.surveydata[indexPath.row-1];
                        NSString *text = model.sharp_title;
                        cell.titleLabel.text = text;
                        UIFont *font = [UIFont systemFontOfSize:16];
                        cell.titleLabel.font = font;
                        titlesize = CGSizeMake(kScreenWidth-30, 20000.0f);
                        titlesize = [text calculateSize:titlesize font:font];
                        [cell.titleLabel setFrame:CGRectMake(15, 15, kScreenWidth-30, titlesize.height)];
                        
                        [cell.line setFrame:CGRectMake(15, 15+titlesize.height+14, kScreenWidth-30, 1)];
                        
                        return cell;
                    }
                }
            }
            else if (indexPath.section == 1){
                if (indexPath.row == 0) {
                    /* 这里是标题 */
                    HeadForSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headcell"];
                    if (cell == nil) {
                        cell = [[HeadForSectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headcell"];
                    }
                    cell.imgview.image = [UIImage imageNamed:@"tab_viewPoint_normal"];
                    cell.headlabel.text = @"观点";
                    /* cell的选中样式为无色 */
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else
                {
                    if (self.researchdata.count == 0) {
                        NSString *identifier = @"cell";
                        NoResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                        if (cell == nil) {
                            cell = [[NoResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                        }
                        cell.delegate = self;
                        NSString *text = [NSString stringWithFormat:@"您搜索的股票 %@ 尚未调研，按提交，我们将尽快为您调研",self.customSearchBar.text];
                        UIFont *font = [UIFont systemFontOfSize:16];
                        cell.label.font = font;
                        cell.label.numberOfLines = 0;
                        textsize = CGSizeMake(kScreenWidth-100, 500.0);
                        textsize = [text calculateSize:textsize font:font];
                        cell.label.text = text;
                        [cell.label setFrame:CGRectMake(50, 10+40+10, kScreenWidth-100, textsize.height)];
                        
                        [cell.submit setFrame:CGRectMake(50, 10+40+10+textsize.height+30, 70, 30)];
                        cell.submit.center = CGPointMake(kScreenWidth/2, 10+40+10+textsize.height+20+20);
                        /* cell的选中样式为无色 */
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
                    else
                    {
                        SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
                        if (cell == nil) {
                            cell = [[SearchResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
                        }
                        SurveyListModel *model = self.researchdata[indexPath.row-1];
                        NSString *text = model.sharp_title;
                        cell.titleLabel.text = text;
                        UIFont *font = [UIFont systemFontOfSize:16];
                        cell.titleLabel.font = font;
                        titlesize = CGSizeMake(kScreenWidth-30, 20000.0f);
                        titlesize = [text calculateSize:titlesize font:font];
                        [cell.titleLabel setFrame:CGRectMake(15, 15, kScreenWidth-30, titlesize.height)];
                        
                        [cell.line setFrame:CGRectMake(15, 15+titlesize.height+14, kScreenWidth-30, 1)];
                        
                        return cell;
                    }
                    
                }
            }
            else
            {
                if (indexPath.row == 0) {
                    /* 这里是标题 */
                    HeadForSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headcell"];
                    if (cell == nil) {
                        cell = [[HeadForSectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headcell"];
                    }
                    cell.imgview.image = [UIImage imageNamed:@"tab_video_normal"];
                    cell.headlabel.text = @"视频";
                    /* cell的选中样式为无色 */
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else
                {
                    if (self.videodata.count == 0) {
                        NSString *identifier = @"cell";
                        NoResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                        if (cell == nil) {
                            cell = [[NoResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                        }
                        cell.delegate = self;
                        NSString *text = [NSString stringWithFormat:@"您搜索的股票 %@ 尚未调研，按提交，我们将尽快为您调研",self.customSearchBar.text];
                        UIFont *font = [UIFont systemFontOfSize:16];
                        cell.label.font = font;
                        cell.label.numberOfLines = 0;
                        textsize = CGSizeMake(kScreenWidth-100, 500.0);
                        textsize = [text calculateSize:textsize font:font];
                        cell.label.text = text;
                        [cell.label setFrame:CGRectMake(50, 10+40+10, kScreenWidth-100, textsize.height)];
                        
                        [cell.submit setFrame:CGRectMake(50, 10+40+10+textsize.height+30, 70, 30)];
                        cell.submit.center = CGPointMake(kScreenWidth/2, 10+40+10+textsize.height+20+20);
                        /* cell的选中样式为无色 */
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
                    else
                    {
                        SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
                        if (cell == nil) {
                            cell = [[SearchResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
                        }
                        SurveyListModel *model = self.videodata[indexPath.row-1];
                        NSString *text = model.sharp_title;
                        cell.titleLabel.text = text;
                        UIFont *font = [UIFont systemFontOfSize:16];
                        cell.titleLabel.font = font;
                        titlesize = CGSizeMake(kScreenWidth-30, 20000.0f);
                        titlesize = [text calculateSize:titlesize font:font];
                        [cell.titleLabel setFrame:CGRectMake(15, 15, kScreenWidth-30, titlesize.height)];
                        
                        [cell.line setFrame:CGRectMake(15, 15+titlesize.height+14, kScreenWidth-30, 1)];
                        
                        return cell;
                    }
                }
            }
//        }
    }
    
}

#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customSearchBar.text.length == 0) {
        if (indexPath.row == 1) {
            return self.tagList.frame.size.height;
        }
        else
        {
            return 50;
        }
    }
    else
    {
        if (self.surveydata.count == 0 && self.researchdata.count == 0 && self.videodata.count == 0) {
            return kScreenWidth-64;
        }
        else
        {
            if (indexPath.row == 0) {
                return 44;
            }
            else
            {
                if (indexPath.section == 0) {
                    if (self.surveydata.count == 0) {
                        return 10+40+10+textsize.height+30+40;
                    }
                    else
                    {
                        return 15 + titlesize.height + 15;
                    }
                }
                else if (indexPath.section == 1)
                {
                    if (self.researchdata.count == 0) {
                        return 10+40+10+textsize.height+30+40;
                    }
                    else
                    {
                        return 15 + titlesize.height + 15;
                    }
                }
                else
                {
                    if (self.videodata.count == 0) {
                        return 10+40+10+textsize.height+30+40;
                    }
                    else
                    {
                        return 15 + titlesize.height + 15;
                    }
                }
                
            }
        }
        
    }
    
}

#pragma mark - section头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* 取消选中状态 */
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *str = [NSString stringWithFormat:@"%@",self.customSearchBar.text];
    self.arr = [[NSArray alloc]init];
    //读取用户搜索历史
    self.arr = [[self.defaults objectForKey:@"searchHistory"] mutableCopy];
    self.arr = [[self.arr reverseObjectEnumerator]allObjects];
    searchHistory = [[NSMutableArray alloc]initWithArray:self.arr];
    BOOL isAlreadyExist = NO;
    for (NSString *temp in searchHistory) {
        if ([str isEqualToString:temp]) {
            isAlreadyExist = YES;
        }
    }
    if (!isAlreadyExist) {
        if (![self.customSearchBar.text isEqualToString:@""]) {
            [searchHistory addObject:self.customSearchBar.text];
        }
    }
    self.arr = [[NSArray alloc]initWithArray:searchHistory];
    self.arr = [[self.arr reverseObjectEnumerator]allObjects];
    //替换掉set valuefor key ，因为会报错
    [self.defaults arrayForKey:@"searchHistory"];
    [self.defaults synchronize];
    /* 判断当前是历史页面还是搜索列表页面 */
    if (self.customSearchBar.text.length == 0) {
        if (indexPath.row == 2) {
            //点击清空的时候清空搜索历史
            [searchHistory removeAllObjects];
            self.arr = [[NSArray alloc]initWithArray:searchHistory];
            [self.defaults arrayForKey:@"searchHistory"];
            [self.defaults synchronize];
            [self.tableview reloadData];
        }
    }
    /* 搜索列表页 */
    else
    {
        /* 跳转至详情页 */
        if (indexPath.section == 0) {
            if (self.surveydata.count != 0) {
                if (indexPath.row != 0) {
                    /* 跳转至详情页 */
                    SurveyListModel *model = self.surveydata[indexPath.row-1];
                    SharpDetailsViewController *DetailView = [[SharpDetailsViewController alloc] init];
                    DetailView.sharp_id = model.sharp_id;
                    DetailView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                    [self.navigationController pushViewController:DetailView animated:YES];
                }
            }
        }
        else if(indexPath.section == 1){
            if (self.researchdata.count != 0) {
                if (indexPath.row != 0) {
                    /* 跳转至详情页 */
                    SurveyListModel *model = self.researchdata[indexPath.row-1];
                   SharpDetailsViewController *DetailView = [[SharpDetailsViewController alloc] init];
                    DetailView.sharp_id = model.sharp_id;
                    
                    DetailView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                    [self.navigationController pushViewController:DetailView animated:YES];
                }
            }
        }
        else
        {
            if (self.videodata.count != 0) {
                if (indexPath.row != 0) {
                    
                    /* 跳转至详情页 */
                    SurveyListModel *model = self.videodata[indexPath.row-1];
                    SharpDetailsViewController *DetailView = [[SharpDetailsViewController alloc] init];
                    DetailView.sharp_id = model.sharp_id;
                    DetailView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                    [self.navigationController pushViewController:DetailView animated:YES];
                }
            }
        }
    }
}

#pragma mark - 点击取消
- (void)ClickBack:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 谓词搜索...
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    NSString *searchString = [self.customSearchBar text];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[c] %@",searchString];
//    if (self.searchList) {
//    [self.searchList removeAllObjects];
//    }
//    //得到搜索结果
//    self.searchList = [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:predicate]];
//    //刷新tableview
//    [self.tableview reloadData];
}
#pragma mark - 搜索栏开始编辑中状态时
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.arr = [[NSArray alloc]init];
    //读取用户搜索历史
    /* */
    self.arr = [self.defaults objectForKey:@"searchHistory"];
    searchHistory = [[NSMutableArray alloc]initWithArray:self.arr];
    
    [self.tableview reloadData];
}

#pragma mark - 搜索框内发生改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.customSearchBar.text.length == 0) {
        searchHistory = [[NSMutableArray alloc]initWithArray:self.arr];
        [self.tableview reloadData];
    }
    else
    {
        [searchHistory removeAllObjects];
        /* 这里每改变一次都继续请求 */
        [self requestDataWithText];
        [self.tableview reloadData];
    }
}

#pragma mark - 点击搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *str = [NSString stringWithFormat:@"%@",searchBar.text];
    self.arr = [[NSArray alloc]init];
    //读取用户搜索历史
    self.arr = [self.defaults objectForKey:@"searchHistory"];
    self.arr = [[self.arr reverseObjectEnumerator]allObjects];
    searchHistory = [[NSMutableArray alloc]initWithArray:self.arr];
    BOOL isAlreadyExist = NO;
    for (NSString *temp in searchHistory) {
        if ([str isEqualToString:temp]) {
            isAlreadyExist = YES;
        }
    }
    if (!isAlreadyExist) {
        if (![searchBar.text isEqualToString:@""]) {
            [searchHistory addObject:searchBar.text];
        }
    }
    self.arr = [[NSArray alloc]initWithArray:searchHistory];
    self.arr = [[self.arr reverseObjectEnumerator]allObjects];
    [self.defaults arrayForKey:@"searchHistory"];
    [self.defaults synchronize];
}

#pragma mark - 页面出现时
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /* 成为第一响应者 */
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.customSearchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 拖动的时候释放第一响应
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.customSearchBar resignFirstResponder];
}

#pragma mark - 点击提交
- (void)clickSubmit:(UIButton *)sender
{
    NSLog(@"提交");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
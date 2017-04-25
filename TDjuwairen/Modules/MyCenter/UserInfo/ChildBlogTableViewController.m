//
//  ChildBlogTableViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ChildBlogTableViewController.h"
#import "UserSurveyModel.h"
#import "ViewPointListModel.h"
#import "NewTableViewCell.h"
#import "ViewPointTableViewCell.h"
#import "NothingTableViewCell.h"
#import "DetailPageViewController.h"
#import "CommentManagerModel.h"
#import "CommentsTableViewCell.h"
#import "StockDetailViewController.h"
#import "UIdaynightModel.h"
#import "LoginState.h"

#import "NSString+Ext.h"
#import "UIImageView+WebCache.h"
#import "NetworkManager.h"

@interface ChildBlogTableViewController ()
{
    CGSize commentsize;
    CGSize floorviewsize;
}
@property (nonatomic,assign) int typeID;

@property (nonatomic,assign) CGSize titlesize;

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) NSMutableArray *surveyListDataArray;
@property (nonatomic,strong) NSMutableArray *viewListDataArray;
@property (nonatomic,strong) NSMutableArray *userCommentArray;

@end

@implementation ChildBlogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    self.surveyListDataArray = [NSMutableArray array];
    self.viewListDataArray = [NSMutableArray array];
    self.userCommentArray = [NSMutableArray array];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"NothingTableViewCell" bundle:nil] forCellReuseIdentifier:@"NothingCell"];
    [self.tableView registerClass:[NewTableViewCell class] forCellReuseIdentifier:@"newcell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentsCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestShowList:(int)typeID WithID:(NSString *)user_id
{
    self.typeID = typeID;
    __weak ChildBlogTableViewController *wself = self;
    if (typeID == 0) {
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        NSString *urlString = [NSString stringWithFormat:@"Blog/blogNewSurveyList"];
        NSDictionary *dic = @{
                              @"user_id":user_id,
                              @"page":[NSString stringWithFormat:@"%d",self.page],
                              };
        [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
            if (!error) {
                NSArray *dataArray = data;
                
                if (dataArray.count > 0) {
                    NSMutableArray *list = nil;
                    if (wself.page == 1) {
                        list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                    } else {
                        list = [NSMutableArray arrayWithArray:wself.surveyListDataArray];
                    }
                    
                    for (NSDictionary *d in dataArray) {
                        UserSurveyModel *model = [UserSurveyModel getInstanceWithDic:d];
                        [list addObject:model];
                    }
                    
                    wself.surveyListDataArray = [NSMutableArray arrayWithArray:list];
                }
                
                [self.tableView reloadData];
            }
            else
            {
                nil;
            }
        }];
    }
    else if (typeID == 1)
    {
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        NSString *urlString = [NSString stringWithFormat:@"index.php/Blog/blogViewLists"];
        NSDictionary *dic = @{
                              @"user_id":user_id,
                              @"page":[NSString stringWithFormat:@"%d",self.page],
                              };
        [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
            if (!error) {
                
                NSArray *dataArray = data;
                if (dataArray.count > 0) {
                    NSMutableArray *list = nil;
                    
                    if (wself.page == 1) {
                        list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                    } else {
                        list = [NSMutableArray arrayWithArray:self.viewListDataArray];
                    }
                    for (NSDictionary *d in dataArray) {
                        ViewPointListModel *model = [ViewPointListModel getInstanceWithDictionary:d];
                        [list addObject:model];
                    }
                    wself.viewListDataArray = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
                }
                
                [self.tableView reloadData];
            }
            else
            {
                nil;
            }
        }];
    }
    else
    {
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        NSString *urlString = [NSString stringWithFormat:@"index.php/User/getUserComment2_1"];
        NSDictionary *dic = @{
                              @"userid":user_id,
                              @"module_id":@"2",
                              @"page":[NSString stringWithFormat:@"%d",self.page],
                              };
        [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
            if (!error) {
                NSArray *dataArray = data;
                
                if (dataArray.count > 0) {
                    NSMutableArray *list = nil;
                    if (wself.page == 1) {
                        list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                    } else {
                        list = [NSMutableArray arrayWithArray:wself.userCommentArray];
                    }
                    
                    for (NSDictionary *d in dataArray) {
                        CommentManagerModel *model = [CommentManagerModel getInstanceWithDictionary:d];
                        [list addObject:model];
                    }
                    wself.userCommentArray = [NSMutableArray arrayWithArray:list];
                }
                [wself.tableView reloadData];
                
            } else {
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.typeID == 0) {
        if (self.surveyListDataArray.count > 0) {
            return self.surveyListDataArray.count;
        }
        else
        {
            return 1;
        }
    }
    else if (self.typeID == 1){
        if (self.viewListDataArray.count > 0) {
            return self.viewListDataArray.count;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (self.userCommentArray.count > 0) {
            return self.userCommentArray.count;
        }
        else
        {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.typeID == 0) {
        if (self.surveyListDataArray.count > 0) {
            NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newcell" forIndexPath:indexPath];
            UserSurveyModel *model = self.surveyListDataArray[indexPath.row];
            
            [cell.userHead sd_setImageWithURL:[NSURL URLWithString:model.survey_authorid]];
            
            cell.nickname.text = [NSString stringWithFormat:@"%@",model.survey_addtime];
            
            NSString *text = model.survey_title;
            
            UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            cell.titleLabel.font = font;
            cell.titleLabel.numberOfLines = 0;
            self.titlesize = CGSizeMake(kScreenWidth-16-90-15, 20000.0f);
            self.titlesize = [text calculateSize:self.titlesize font:font];
            cell.titleLabel.text = text;
            [cell.titleLabel setFrame:CGRectMake(15, 55, kScreenWidth-16-90-15, self.titlesize.height)];
            cell.descLabel.frame = CGRectMake(15, 55+self.titlesize.height+10, kScreenWidth-16-90-15, 55);
            cell.descLabel.font = [UIFont systemFontOfSize:14];
            cell.descLabel.numberOfLines = 3;
            cell.descLabel.text = model.survey_desc;
            cell.descLabel.textColor = [UIColor grayColor];
            
            cell.titleimg.frame = CGRectMake(kScreenWidth-8-90, 15+25+15, 90, 90);
            [cell.titleimg sd_setImageWithURL:[NSURL URLWithString:model.survey_cover]];
            
            cell.lineLabel.frame = CGRectMake(0, 15+25+15+self.titlesize.height+10+55+17, kScreenWidth, 0.5);
            
            cell.nickname.textColor = self.daynightmodel.titleColor;
            cell.titleLabel.textColor = self.daynightmodel.textColor;
            cell.descLabel.textColor = self.daynightmodel.titleColor;
            cell.backgroundColor = self.daynightmodel.navigationColor;
            cell.lineLabel.layer.borderColor = self.daynightmodel.lineColor.CGColor;
            return cell;
        }
        else
        {
            NothingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NothingCell"];
            cell.backgroundColor = self.daynightmodel.backColor;
            cell.label.text = @"该用户还没有发布调研";
            cell.label.textColor = self.daynightmodel.textColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    else if (self.typeID == 1)
    {
        if (self.viewListDataArray.count > 0) {
            NSString *identifier = @"cell";
            ViewPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[ViewPointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            ViewPointListModel *model = self.viewListDataArray[indexPath.row];
            [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.user_facemin]];
            NSString *isoriginal;
            if ([model.view_isoriginal isEqualToString:@"0"]) {
                isoriginal = @"";
            }else
            {
                isoriginal = @"原创";
            }
            cell.nicknameLabel.text = [NSString stringWithFormat:@"%@  %@",model.view_wtime,isoriginal];
            
            
            UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            cell.titleLabel.font = font;
            cell.titleLabel.numberOfLines = 0;
            self.titlesize = CGSizeMake(kScreenWidth-30, 500.0);
            self.titlesize = [model.view_title calculateSize:self.titlesize font:font];
            cell.titleLabel.text = model.view_title;
            [cell.titleLabel setFrame:CGRectMake(15, 15+25+10, kScreenWidth-30, self.titlesize.height)];
            [cell.lineLabel setFrame:CGRectMake(0, 15+25+10+self.titlesize.height+14, kScreenWidth, 1)];
            
            
            cell.nicknameLabel.textColor = self.daynightmodel.titleColor;
            cell.titleLabel.textColor = self.daynightmodel.textColor;
            cell.backgroundColor = self.daynightmodel.navigationColor;
            cell.lineLabel.layer.borderColor = self.daynightmodel.lineColor.CGColor;
            return cell;
        }
        else
        {
            NothingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NothingCell"];
            cell.backgroundColor = self.daynightmodel.backColor;
            cell.label.text = @"该用户还没有发布观点";
            cell.label.textColor = self.daynightmodel.textColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    else
    {
        if (self.userCommentArray.count > 0) {
            CommentManagerModel *model = self.userCommentArray[indexPath.row];
            CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
            [cell setCellWithDic:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NothingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NothingCell"];
            cell.backgroundColor = self.daynightmodel.backColor;
            cell.label.text = @"该用户还没有发表评论";
            cell.label.textColor = self.daynightmodel.textColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.typeID == 0) {
        if (self.surveyListDataArray.count > 0) {
            return 15+25+15+self.titlesize.height+10+55+18;
        }
        else
        {
            return kScreenHeight-64;
        }
        
    }
    else if (self.typeID == 1){
        if (self.viewListDataArray.count > 0) {
            return 15+25+10+self.titlesize.height+15;
        }
        else
        {
            return kScreenHeight-64;
        }
    }
    else
    {
        if (self.userCommentArray.count > 0) {
            return 136;
        }
        else
        {
            return kScreenHeight-64;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.typeID == 0) {
        if (self.surveyListDataArray.count > 0) {
            //跳转调研详情
            UserSurveyModel *model = self.surveyListDataArray[indexPath.row];
            
            StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
            vc.stockCode = model.company_code;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (self.typeID == 1){
        if (self.viewListDataArray.count > 0) {
            //跳转观点详情
            
            DetailPageViewController *DetailView = [[DetailPageViewController alloc]init];
            ViewPointListModel *model = self.viewListDataArray[indexPath.row];
            DetailView.view_id = model.view_id;
            DetailView.pageMode = @"view";
            [self.navigationController pushViewController:DetailView animated:YES];
        }
    }
    else
    {
        if (self.userCommentArray.count > 0) {
            CommentManagerModel *model = self.userCommentArray[indexPath.row];

            StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
            vc.stockCode = model.company_code;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end

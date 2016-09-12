//
//  ChildBlogTableViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ChildBlogTableViewController.h"
#import "SurveyListModel.h"
#import "ViewPointListModel.h"
#import "NewTableViewCell.h"
#import "ViewPointTableViewCell.h"
#import "NothingTableViewCell.h"

#import "UIdaynightModel.h"

#import "NSString+Ext.h"
#import "UIImageView+WebCache.h"
#import "NetworkManager.h"

@interface ChildBlogTableViewController ()

@property (nonatomic,assign) int typeID;
@property (nonatomic,assign) int page;
@property (nonatomic,assign) CGSize titlesize;

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) NSMutableArray *surveyListDataArray;
@property (nonatomic,strong) NSMutableArray *viewListDataArray;

@end

@implementation ChildBlogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    self.tableView.scrollEnabled = NO;
    self.surveyListDataArray = [NSMutableArray array];
    self.viewListDataArray = [NSMutableArray array];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"NothingTableViewCell" bundle:nil] forCellReuseIdentifier:@"NothingCell"];
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
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:kAPI_bendi];
        NSString *urlString = [NSString stringWithFormat:@"index.php/Blog/blogSurveyList"];
        NSDictionary *dic = @{
                              @"user_id":user_id,
                              @"page":@"1",
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
                        SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                        [list addObject:model];
                    }
                    
                    wself.surveyListDataArray = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
                }
                [self.tableView reloadData];
            }
            else
            {
                NSLog(@"%@",error);
            }
        }];
    }
    else if (typeID == 1)
    {
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:kAPI_bendi];
        NSString *urlString = [NSString stringWithFormat:@"index.php/Blog/blogViewLists"];
        NSDictionary *dic = @{
                              @"user_id":user_id,
                              @"page":@"1",
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
                NSLog(@"%@",error);
            }
        }];
    }
    else
    {
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:kAPI_bendi];
        NSString *urlString = [NSString stringWithFormat:@"index.php/Blog/blogViewLists"];
        NSDictionary *dic = @{
                              @"user_id":user_id,
                              @"page":@"1",
                              };
        [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
            if (!error) {
                NSLog(@"%@",data);
            }
            else
            {
                NSLog(@"%@",error);
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
        return 20;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.typeID == 0) {
        if (self.surveyListDataArray.count > 0) {
            NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newcell"];
            if (cell == nil) {
                cell = [[NewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newcell"];
            }
            SurveyListModel *model = self.surveyListDataArray[indexPath.row];
            
            [cell.userHead sd_setImageWithURL:[NSURL URLWithString:model.user_facemin]];
            
            cell.nickname.text = [NSString stringWithFormat:@"%@",model.sharp_wtime];
            
            NSString *text = model.sharp_title;
            
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
            cell.descLabel.text = model.sharp_desc;
            cell.descLabel.textColor = [UIColor grayColor];
            
            cell.titleimg.frame = CGRectMake(kScreenWidth-8-90, 15+25+15, 90, 90);
            [cell.titleimg sd_setImageWithURL:[NSURL URLWithString:model.sharp_imgurl]];
            
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
        NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = @"苍茫的天涯是我的爱";
        return cell;
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
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

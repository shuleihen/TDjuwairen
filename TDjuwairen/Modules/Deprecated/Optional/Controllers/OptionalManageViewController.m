//
//  OptionalManageViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "OptionalManageViewController.h"
#import "OptionalManageHeadView.h"
#import "OptionalManageTableViewCell.h"
#import "NoOrderTableViewCell.h"
#import "AlertHintView.h"
#import "SurveyModel.h"
#import "SearchViewController.h"
#import "LoginViewController.h"

#import "UIdaynightModel.h"
#import "LoginState.h"

#import "NetworkManager.h"
#import "Masonry.h"

@interface OptionalManageViewController ()<UITableViewDelegate,UITableViewDataSource,ManageCellDelegate>
@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) OptionalManageHeadView *headView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation OptionalManageViewController

- (OptionalManageHeadView *)headView{
    if (!_headView) {
        _headView = [[OptionalManageHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.backgroundColor = [UIColor whiteColor];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    self.dataArr = [NSMutableArray array];
    self.stockArr = [NSMutableArray array];
    
    [self setupWithNavigation];
    [self setupWithTableView];
    [self requestWithList];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    self.title = @"管理";
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addBtn:)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    UIImage *image = [[UIImage imageNamed:@"nav_back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickGoBack:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.estimatedRowHeight = 250;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    [self.tableview registerClass:[OptionalManageTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
}

- (void)requestWithList{
    
    __weak OptionalManageViewController *wself = self;
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSString *url ;
    if (US.isLogIn) {
        url = [NSString stringWithFormat:@"Collection/myStockList?user_id=%@",US.userId];
    }
    else
    {
        url = [NSString stringWithFormat:@"Collection/myStockList?user_id="];
    }
    [manager GET:url parameters:nil completion:^(id data, NSError *error) {
        if (!error) {
            //
            NSArray *arr = data;
            self.dataArr = [NSMutableArray arrayWithArray:arr];
            
            for (NSDictionary *dic in self.dataArr) {
                SurveyModel *model = [SurveyModel getInstanceWithDictionary:dic];
                [wself.stockArr addObject:model];
            }
            [wself.tableview reloadData];
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else
    {
        if (self.stockArr.count > 0) {
            return self.stockArr.count;
        }
        else
        {
            return 5;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.stockArr.count > 0) {
        OptionalManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.delegate = self;
        SurveyModel *model = self.stockArr[indexPath.row];
        cell.nameLab.text = [model.companyName substringWithRange:NSMakeRange(0, model.companyName.length-8)];
        cell.codeLab.text = model.companyCode;
        cell.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NoOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noOrderCell"];
        if (cell == nil) {
            cell = [[NoOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noOrderCell"];
            UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAddStock)];
            cell.imgView.userInteractionEnabled = YES;
            
            [cell.imgView addGestureRecognizer:tapGesturRecognizer];
        }
        cell.imgView.image = [UIImage imageNamed:@"btn_tianjia_nor"];
        cell.titLab.text = @"暂无股票，点击添加";
        
        CGFloat imgX = (kScreenHeight-64-55-50)/6;
        [cell.titLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell).with.offset(-(kScreenHeight-64-imgX-90-25-40));
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    else
    {
        return self.headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    else
    {
        return 45;
    }
}

#pragma mark - goback
- (void)clickGoBack:(UIButton *)sender{
    NSDictionary *dictionary = nil;
    [dictionary setValue:self.dataArr forKey:@"data"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:self.dataArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    __weak OptionalManageViewController *wself = self;
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSString *url = @"Collection/changeMyStockOrder";
    NSDictionary *para = @{@"order_list":jsonStr};
    [manager POST:url parameters:para completion:^(id data, NSError *error) {
        if (!error) {
            NSLog(@"%@",data);
            [wself.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"%@",error);
            [wself.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark - 添加自选股
- (void)addBtn:(UIButton *)sender{
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    [self.navigationController pushViewController:searchView animated:YES];
}

#pragma mark - manageCell delegate
- (void)delectThisCell:(UIButton *)sender
{
    OptionalManageTableViewCell *cell = (OptionalManageTableViewCell *)sender.superview;
    
    __weak OptionalManageViewController *wself = self;
    AlertHintView *alertView = [AlertHintView alterViewWithTitle:[NSString stringWithFormat:@"%@ (%@)",cell.nameLab.text,cell.codeLab.text] content:@"是否删除该支自选股" cancel:@"取消" sure:@"删除" cancelBtClcik:^(AlertHintView *view) {
        [view removeFromSuperview];
    } sureBtClcik:^(AlertHintView *view) {
        SurveyModel *model = self.stockArr[cell.tag];
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        NSString *url = @"Collection/cancelMyStock";
        NSDictionary *para = @{@"collect_id":model.collection_id};
        [manager POST:url parameters:para completion:^(id data, NSError *error) {
            if (!error) {
                [view removeFromSuperview];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:1];
                [wself.stockArr removeObjectAtIndex:cell.tag];
                [wself.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
            else
            {
                //
            }
        }];
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
}

- (void)clickAddStock{
    if (US.isLogIn) {
        SearchViewController *searchView = [[SearchViewController alloc] init];
        searchView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:searchView animated:YES];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

#pragma mark - 置顶
- (void)topPan:(UIGestureRecognizer *)recognizer
{
    UITapGestureRecognizer *longPress = (UITapGestureRecognizer *)recognizer;
    
    CGPoint location = [longPress locationInView:self.tableview];
    NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:location];
    [self.dataArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
    [self.stockArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
    [self.tableview moveRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section] toIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];
}

#pragma mark - 拖动
- (void)longPress:(UIGestureRecognizer *)recognizer
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)recognizer;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableview];
    NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:location];
    //这里是网上找的一段代码，还没完全看明白，
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];

                snapshot = [self customSnapshoFromView:cell];

                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableview addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;

            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [self.dataArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.stockArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];

                [self.tableview moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:sourceIndexPath];
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            break;
        }
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {

    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

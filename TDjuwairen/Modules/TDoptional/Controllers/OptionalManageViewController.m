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

#import "UIdaynightModel.h"
#import "LoginState.h"

#import "NetworkManager.h"
#import "Masonry.h"

@interface OptionalManageViewController ()<UITableViewDelegate,UITableViewDataSource,ManageCellDelegate>
{
    // 用于赋值CGPoint
    CGPoint valuePoint;
}

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) OptionalManageHeadView *headView;

@property (nonatomic,strong) NSArray *dataArr;

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
    self.daynightModel = [UIdaynightModel sharedInstance];
    self.dataArr = [NSArray array];
    self.stockArr = [NSMutableArray array];
    
    [self setupWithNavigation];
    [self setupWithTableView];
    [self requestWithList];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    NSDictionary *dictionary = nil;
    [dictionary setValue:self.dataArr forKey:@"data"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:self.dataArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr==%@",jsonStr);
    
//    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:kAPI_songsong];
//    NSString *url = @"Collection/changeMyStockOrder";
//    
//    manager POST:<#(NSString *)#> parameters:<#(id)#> completion:<#^(id data, NSError *error)completion#>
}

- (void)setupWithNavigation{
    self.title = @"管理";
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addBtn:)];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
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
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:kAPI_songsong];
    NSString *url = @"Collection/myStockList";
    NSDictionary *para = nil;
    if (US.isLogIn) {
        para = @{@"user_id":US.userId};
    }
    else
    {
        para = nil;
    }
    [manager POST:url parameters:para completion:^(id data, NSError *error) {
        if (!error) {
            //
            self.dataArr = data[@"data"];
            
            for (NSDictionary *dic in self.dataArr) {
                SurveyModel *model = [SurveyModel getInstanceWithDictionary:dic];
                [wself.stockArr addObject:model];
            }
            [wself.tableview reloadData];
        }
        else
        {
            //
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
        cell.nameLab.text = model.companyName;
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

#pragma mark - 添加自选股
- (void)addBtn:(UIButton *)sender{
    
}

#pragma mark - manageCell delegate
- (void)delectThisCell:(UIButton *)sender
{
    OptionalManageTableViewCell *cell = (OptionalManageTableViewCell *)sender.superview;
    
    __weak OptionalManageViewController *wself = self;
    AlertHintView *alertView = [AlertHintView alterViewWithTitle:[NSString stringWithFormat:@"%@ (%@)",cell.nameLab.text,cell.codeLab.text] content:@"是否删除该支自选股" cancel:@"取消" sure:@"删除" cancelBtClcik:^(AlertHintView *view) {
        [view removeFromSuperview];
    } sureBtClcik:^(AlertHintView *view) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:1];
        [wself.stockArr removeObjectAtIndex:cell.tag];
        [wself.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
}

- (void)clickAddStock{
    NSLog(@"嘿嘿嘿");
}

#pragma mark - 置顶
- (void)topPan:(UIGestureRecognizer *)recognizer
{
    UITapGestureRecognizer *longPress = (UITapGestureRecognizer *)recognizer;
    
    CGPoint location = [longPress locationInView:self.tableview];
    NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:location];
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

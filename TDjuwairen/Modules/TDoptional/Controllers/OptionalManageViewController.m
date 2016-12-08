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

#import "UIdaynightModel.h"

@interface OptionalManageViewController ()<UITableViewDelegate,UITableViewDataSource,ManageCellDelegate>
{
    // 用于赋值CGPoint
    CGPoint valuePoint;
}

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) OptionalManageHeadView *headView;

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
    NSArray *arr = @[@"平安银行",@"平安中国",@"平安保险",@"保险平安",@"一路平安"];
    self.stockArr = [NSMutableArray arrayWithArray:arr];
    [self setupWithNavigation];
    [self setupWithTableView];
    // Do any additional setup after loading the view.
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
    OptionalManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.nameLab.text = self.stockArr[indexPath.row];
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:1];
    [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
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
                NSLog(@"1");
                UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableview addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
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
            NSLog(@"2");
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.stockArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableview moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            NSLog(@"3");
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
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
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

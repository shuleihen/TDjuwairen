//
//  CollectionViewController.m
//  TDjuwairen
//
//  Created by tuanda on 16/6/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionTableViewCell.h"
#import "ViewPointTableViewCell.h"
#import "ViewPointListModel.h"
#import "LoginState.h"
#import "EditView.h"
#import "DetailPageViewController.h"
#import "NSString+Ext.h"
#import "NSString+TimeInfo.h"
#import "UIImageView+WebCache.h"
#import "NetworkManager.h"
#import "UIdaynightModel.h"
#import "UIImage+Color.h"
#import "AliveListTableViewCell.h"
#import "AliveListBottomTableViewCell.h"


@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGSize titlesize;
    BOOL edit;
}
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *categoryArr;


@property (nonatomic,strong) NSMutableArray *CollectionArray;
@property (nonatomic,strong) NSMutableArray *ViewCollectArray;
@property (nonatomic,strong) NSMutableArray *delArray;
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (strong, nonatomic) UIView *noMoreView;
@property (nonatomic,assign) NSInteger typeID;
@property (strong, nonatomic) NSMutableDictionary *collectionDictM;


@end

@implementation CollectionViewController
- (NSArray *)categoryArr
{
    if (!_categoryArr) {
        //        _categoryArr = @[@"视频",@"观点"];
        _categoryArr = @[@"观点",@"调研",@"热点"];
        
    }
    return _categoryArr;
}

- (UIView *)noMoreView {
    
    if (!_noMoreView) {
        _noMoreView = [[UIView alloc] init];
        CGRect rect = CGRectMake(0, 44-TDPixel, kScreenWidth, kScreenHeight-44-TDPixel);
        _noMoreView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noRecord"]];
        imageView.frame = CGRectMake((kScreenWidth-50)/2, (CGRectGetHeight(rect)-50-20)/2, 50, 50);
        [_noMoreView addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(12, CGRectGetMaxY(imageView.frame)+15, kScreenWidth-24, 20);
        nameLabel.text = @"暂无收藏";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        nameLabel.textColor = TDDetailTextColor;
        [_noMoreView addSubview:nameLabel];
        
        
    }
    return _noMoreView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TDViewBackgrouondColor;
    self.title = @"我的收藏";
    [self.view addSubview:self.noMoreView];
    self.typeID = 1;
    self.collectionDictM = [NSMutableDictionary dictionary];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.CollectionArray = [[NSMutableArray alloc]init];
    self.ViewCollectArray = [[NSMutableArray alloc]init];
    [self requestCollection];
    [self requestAuthentication];
    [self setupWithCollectionFilterBtn];
    [self setupWithTableView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupWithCollectionFilterBtn{
    
    UIImage *normal = [UIImage imageWithSize:CGSizeMake(60, 28) withColor:[UIColor whiteColor]];
    UIImage *pressed = [UIImage imageWithSize:CGSizeMake(60, 28) withColor:[UIColor whiteColor]];
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"观点",@"调研",@"热点"]];
    segmented.tintColor = [UIColor whiteColor];
    segmented.layer.cornerRadius = 0.0f;
    segmented.layer.borderWidth = 1.0f;
    segmented.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [segmented addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#666666"]}
                             forState:UIControlStateNormal];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#3371E2"]}
                             forState:UIControlStateHighlighted];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#3371E2"]}
                             forState:UIControlStateSelected];
    segmented.frame = CGRectMake(0, 0, kScreenWidth, 44-TDPixel);
    [segmented setBackgroundImage:normal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:normal forState:UIControlStateSelected|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [segmented setSelectedSegmentIndex:0];
    [self.view addSubview:segmented];
    
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44-TDPixel+0.5, kScreenWidth, kScreenHeight-44+TDPixel-0.5) style:UITableViewStylePlain];
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    self.tableview.allowsMultipleSelectionDuringEditing = YES;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.separatorInset = UIEdgeInsetsZero;
    self.tableview.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"CollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectionCell"];
    self.tableview.backgroundColor = self.daynightmodel.navigationColor;
    
    [self.tableview registerClass:[AliveListTableViewCell class] forCellReuseIdentifier:@"AliveListTableViewCellID"];
    UINib *nib1 = [UINib nibWithNibName:@"AliveListBottomTableViewCell" bundle:nil];
    [self.tableview registerNib:nib1 forCellReuseIdentifier:@"AliveListBottomTableViewCellID"];
    
}


-(void)Delete:(UIButton*)sender
{
    NSMutableArray *sharpId = [NSMutableArray array];
    NSArray *selectArray = self.tableview.indexPathsForSelectedRows;
    
    if (selectArray.count) {
        self.delArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in selectArray) {
            NSDictionary *dic = [self.CollectionArray objectAtIndex:indexPath.row];
            [self.delArray addObject:dic];
            [sharpId addObject:dic[@"sharp_id"]];
        }
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary*para=@{@"authenticationStr":US.userId,
                            @"encryptedStr":self.str,
                            @"delete_ids":sharpId,
                            @"module_id":@"2",
                            @"userid":US.userId};
        
        [manager POST:API_DelCollection parameters:para completion:^(id data, NSError *error){}];
        
        [self.CollectionArray removeObjectsInArray:self.delArray];
        
        [self.tableview deleteRowsAtIndexPaths:selectArray withRowAnimation:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.tableview.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        } completion:^(BOOL finished) {
            
        }];
        
        edit = NO;
        [self.tableview setEditing:NO animated:YES];
    }
}

//身份验证
-(void)requestAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para=@{@"validatestring":US.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary*dic = data;
            self.str = dic[@"str"];
        } else {
            
        }
    }];
}

#pragma mark - 获取收藏列表的请求
-(void)requestCollection
{
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *paras = @{@"userid":US.userId};
    
    [manager POST:API_GetCollectionList parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            NSArray *array = data;
            NSDictionary *VideoDic = array[1];
            NSDictionary *viewPointDic = array[2];
            
            NSArray *videoArr = VideoDic[@"List"];
            NSArray *viewArr = viewPointDic[@"List"];
            
            if (videoArr.count > 0) {
                NSMutableArray *tempArrM = [NSMutableArray array];
                for (NSDictionary *dic in videoArr) {
                    [tempArrM addObject:dic];
                }
                [self.collectionDictM setObject:tempArrM forKey:@(4)];
            }
            
            /// 观点
            if (viewArr.count > 0) {
                NSMutableArray *tempArrM = [NSMutableArray array];
                for (NSDictionary *dic in viewArr) {
                    ViewPointListModel *model = [ViewPointListModel getInstanceWithDictionary:dic];
                    [tempArrM addObject:model];
                }
                [self.collectionDictM setObject:tempArrM forKey:@(1)];
            }
            
            NSMutableArray *arrM = [NSMutableArray arrayWithArray:[self.collectionDictM objectForKey:@(self.typeID)]];
            
            if (arrM.count <= 0) {
                self.tableview.hidden = YES;
            }else {
                
                self.tableview.hidden = NO;
            }
            
            [self.tableview reloadData];
        } else {
            [self.tableview reloadData];
            self.tableview.hidden = NO;
        }
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
//    return [[self.collectionDictM objectForKey:@(self.typeID)] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 2;
    return [[self.collectionDictM objectForKey:@(self.typeID)] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.typeID == 1) {
//        if (indexPath.row == 0) {
//            AliveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListTableViewCellID"];
//            cell.tag = indexPath.section;
////            cell.delegate = self;
//            
//            return cell;
//        } else {
//            AliveListBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListBottomTableViewCellID"];
////            cell.delegate = self;
//            
//            return cell;
//        }
//    }else {
    
        NSString *identifier = @"cell";
        ViewPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ViewPointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSMutableArray *arrM = [self.collectionDictM objectForKey:@(self.typeID)];
        ViewPointListModel *model = arrM[indexPath.row];
        
        [cell setupViewPointModel:model];
        
        return cell;
//    }
}



#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arrM = [self.collectionDictM objectForKey:@(self.typeID)];
    ViewPointListModel *model = arrM[indexPath.row];
    return [ViewPointTableViewCell heightWithViewpointModel:model];

    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        if (self.typeID == 0) {
            NSDictionary *dic = [self.CollectionArray objectAtIndex:indexPath.row];
            NSMutableArray *delarr = [NSMutableArray array];
            [delarr addObject:dic[@"sharp_id"]];
            
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary*para = @{@"authenticationStr":US.userId,
                                  @"encryptedStr":self.str,
                                  @"delete_ids":delarr,
                                  @"module_id":@"2",
                                  @"userid":US.userId};
            
            [manager POST:API_DelCollection parameters:para completion:^(id data, NSError *error){}];
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.CollectionArray];
            [arr removeObjectAtIndex:indexPath.row];
            self.CollectionArray = [NSMutableArray arrayWithArray:arr];
            
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            NSDictionary *dic = [self.ViewCollectArray objectAtIndex:indexPath.row];
            NSMutableArray *delarr = [NSMutableArray array];
            [delarr addObject:dic[@"view_id"]];
            
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary*para = @{@"authenticationStr":US.userId,
                                  @"encryptedStr":self.str,
                                  @"delete_ids":delarr,
                                  @"module_id":@"3",
                                  @"userid":US.userId};
            
            [manager POST:API_DelCollection parameters:para completion:^(id data, NSError *error){}];
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.ViewCollectArray];
            [arr removeObjectAtIndex:indexPath.row];
            self.ViewCollectArray = [NSMutableArray arrayWithArray:arr];
            
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (edit == NO) {
        if (self.typeID == 0){
            if (self.ViewCollectArray.count > 0) {
                ViewPointListModel *model = self.ViewCollectArray[indexPath.row];
                DetailPageViewController *view = [[DetailPageViewController alloc] init];
                view.view_id = model.view_id;
                view.pageMode = @"view";
                [self.navigationController pushViewController:view animated:YES];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            if (self.CollectionArray.count > 0) {
                NSDictionary *dic = self.CollectionArray[indexPath.row];
                DetailPageViewController *sharp = [[DetailPageViewController alloc] init];
                sharp.sharp_id = dic[@"sharp_id"];
                sharp.pageMode = @"sharp";
                [self.navigationController pushViewController:sharp animated:YES];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }
}

#pragma mark - 按钮点击事件
- (void)segmentValueChanged:(UISegmentedControl *)segment {
    NSInteger index = segment.selectedSegmentIndex+1;
    self.typeID = index;
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:[self.collectionDictM objectForKey:@(index)]];
    if (arrM.count <= 0) {
        self.tableview.hidden = YES;
    }else {
        
        self.tableview.hidden = NO;
    }
    [self.tableview reloadData];
}

@end

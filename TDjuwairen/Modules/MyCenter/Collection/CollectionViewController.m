//
//  CollectionViewController.m
//  TDjuwairen
//
//  Created by tuanda on 16/6/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionTableViewCell.h"
#import "NoCollectionTableViewCell.h"
#import "LoginState.h"
#import "EditView.h"
#import "SharpDetailsViewController.h"
#import "NSString+TimeInfo.h"
#import "NetworkManager.h"

@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    
    BOOL edit;
    BOOL haveCollection;
    BOOL haveSelect;
}
@property (nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) EditView *editView;
@property (nonatomic,strong) UIBarButtonItem *editItem;
@property (nonatomic, strong) UIBarButtonItem *cancelItem;
@property (nonatomic,strong) NSMutableArray *CollectionArray;
@property (nonatomic,strong) NSMutableArray *delArray;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self setupWithTableView];
    
    [self setupEditToolView];
    haveSelect = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self requestCollection];
    [self requestAuthentication];
}

-(void)setNavigation
{

    self.title = @"收藏管理";

    //编辑button
    self.editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    
    self.navigationItem.rightBarButtonItem = self.editItem;
    edit=NO;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    self.tableview.allowsMultipleSelectionDuringEditing = YES;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableview.separatorInset = UIEdgeInsetsZero;
    self.tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableview];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"CollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectionCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"NoCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoCollectionCell"];
    
}

- (void)setupEditToolView
{
    self.editView = [[EditView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 50)];
    [self.editView.selectBtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView.deleteBtn addTarget:self action:@selector(Delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editView];
}


//编辑button点击事件
-(void)editClick
{
    
    if (edit == NO) {
        [UIView animateWithDuration:0.3 animations:^{
            self.editView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)-50, CGRectGetWidth(self.view.bounds), 50);
        } completion:^(BOOL finished) {
            self.tableview.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-50);
        }];
        
        edit = YES;
        self.navigationItem.rightBarButtonItem = self.cancelItem;
        [self.tableview setEditing:YES animated:YES];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableview.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
            self.editView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 50);
        } completion:^(BOOL finished) {
            
        }];
        
        [self.editView.selectBtn setTitle:@"全选" forState:UIControlStateNormal];
        
        edit = NO;
        haveSelect = NO;
        self.navigationItem.rightBarButtonItem = self.editItem;
        [self.tableview setEditing:NO animated:YES];
    }
}

-(void)allSelect:(UIButton*)sender
{
    if (haveSelect==NO) {
        for (int i=0; i<self.CollectionArray.count; i++) {
            NSIndexPath*indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        [self.editView.selectBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        haveSelect=YES;
    } else {
        for (int i=0; i<self.CollectionArray.count; i++) {
            NSIndexPath*indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
        }
        
        [self.editView.selectBtn setTitle:@"全选" forState:UIControlStateNormal];
        haveSelect=NO;
    }
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
            self.editView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 50);
        } completion:^(BOOL finished) {
            
        }];
        
        edit = NO;
        self.navigationItem.rightBarButtonItem = self.editItem;
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
    self.CollectionArray = [[NSMutableArray alloc]init];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *paras = @{@"userid":US.userId};
    
    [manager POST:API_GetCollectionList parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            haveCollection=YES;
            NSArray*array = data;
            NSDictionary*dic = array[1];
            NSArray*arr = dic[@"List"];
            
            for (NSDictionary*dic in arr) {
                [self.CollectionArray addObject:dic];
            }
            [self.tableview reloadData];
        } else {
            if (error.code == 300) {
                haveCollection=NO;
            }
            
            [self.tableview reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (haveCollection) {
        return self.CollectionArray.count;
    }
    else
    {
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (haveCollection) {
        NSDictionary *dic = self.CollectionArray[indexPath.row];
        
        CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionCell"];
        [cell setCellWithDic:dic];
        
        return cell;
    }
    else
    {
        
        NoCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoCollectionCell"];

        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)ttableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (haveCollection) {
        return 90;
    }
    else
    {
        return 568;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
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
    NSDictionary *dic = self.CollectionArray[indexPath.row];
    SharpDetailsViewController *sharp = [[SharpDetailsViewController alloc] init];
    sharp.sharp_id = dic[@"sharp_id"];
    [self.navigationController pushViewController:sharp animated:YES];
    }
}

@end

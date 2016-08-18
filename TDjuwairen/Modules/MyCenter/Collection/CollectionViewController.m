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
    NSMutableArray*CollectionArray;
    NSMutableArray*delArray;
    UIBarButtonItem*editBtn;
    BOOL edit;
    BOOL haveCollection;
    BOOL haveSelect;
}
@property (nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong)EditView*editView;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self setupWithTableView];
    
    //全选，删除的view视图
    _editView=[[EditView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 50)];
    //全选button
    [_editView.selectBtn addTarget:self action:@selector(Select:) forControlEvents:UIControlEventTouchUpInside];
    haveSelect=NO;
    //删除button
    [_editView.deleteBtn addTarget:self action:@selector(Delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editView];
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.allowsMultipleSelectionDuringEditing = YES;//多行编辑
    [self.view addSubview:self.tableview];
    
}

-(void)Select:(UIButton*)sender
{
    if (haveSelect==NO) {
        for (int i=0; i<CollectionArray.count;i++ ) {
            NSIndexPath*indexPath=[NSIndexPath indexPathForItem:i inSection:0];
            [self.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        [_editView.selectBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        haveSelect=YES;
    }
    else
    {
        for (int i=0; i<CollectionArray.count; i++) {
            NSIndexPath*indexPath=[NSIndexPath indexPathForItem:i inSection:0];
            [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
        }
        [_editView.selectBtn setTitle:@"全选" forState:UIControlStateNormal];
        haveSelect=NO;
    }
}

-(void)Delete:(UIButton*)sender
{
    NSMutableArray*sharpId=[NSMutableArray array];
    NSArray*selectArray=self.tableview.indexPathsForSelectedRows;
    if (selectArray.count) {
        delArray=[NSMutableArray array];
        for (NSIndexPath*indexPath in selectArray) {
            NSDictionary*dic=[CollectionArray objectAtIndex:indexPath.row];
            [delArray addObject:dic];
            [sharpId addObject:dic[@"sharp_id"]];
        }
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary*para=@{@"authenticationStr":US.userId,
                            @"encryptedStr":self.str,
                            @"delete_ids":sharpId,
                            @"module_id":@"2",
                            @"userid":US.userId};
        
        [manager POST:API_DelCollection parameters:para completion:^(id data, NSError *error){}];
        
        [CollectionArray removeObjectsInArray:delArray];
        
        [self.tableview deleteRowsAtIndexPaths:selectArray withRowAnimation:YES];
        [UIView animateWithDuration:0.5 animations:^{
            _editView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-518);
        } completion:^(BOOL finished) {
            nil;
        }];
        edit=NO;
        editBtn.title=@"编辑";
        [self.tableview setEditing:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestCollection];
    [self requestAuthentication];
}

-(void)setNavigation
{
    self.title = @"收藏管理";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //编辑button
    editBtn=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.navigationItem.rightBarButtonItem=editBtn;
    edit=NO;
}

//编辑button点击事件
-(void)editClick
{
    
    if (edit==NO) {
        [UIView animateWithDuration:0.5 animations:^{
            _editView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50);
        } completion:^(BOOL finished) {
            nil;
        }];
        edit=YES;
        editBtn.title=@"取消";
        [self.tableview setEditing:YES animated:YES];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _editView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 50);
        } completion:^(BOOL finished) {
            nil;
        }];
        edit=NO;
        editBtn.title=@"编辑";
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

-(void)requestCollection
{
    CollectionArray=[[NSMutableArray alloc]init];

    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras = @{@"userid":US.userId};
    
    [manager POST:API_GetCollectionList parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            haveCollection=YES;
            NSArray*array = data;
            NSDictionary*dic = array[1];
            NSArray*arr = dic[@"List"];
            
            for (NSDictionary*dic in arr) {
                [CollectionArray addObject:dic];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (haveCollection) {
        return CollectionArray.count;
    }
    else
    {
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (haveCollection) {
        NSDictionary*dic=CollectionArray[indexPath.row];
        [tableView registerNib:[UINib nibWithNibName:@"CollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectionCell"];
        CollectionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CollectionCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setCellWithDic:dic];
        editBtn.enabled=YES;
        return cell;
    }
    else
    {
        [tableView registerNib:[UINib nibWithNibName:@"NoCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoCollectionCell"];
        NoCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoCollectionCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        editBtn.enabled=NO;
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
        NSDictionary *dic = [CollectionArray objectAtIndex:indexPath.row];
        NSMutableArray *delarr = [NSMutableArray array];
        [delarr addObject:dic[@"sharp_id"]];
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary*para = @{@"authenticationStr":US.userId,
                            @"encryptedStr":self.str,
                            @"delete_ids":delarr,
                            @"module_id":@"2",
                            @"userid":US.userId};
        
        [manager POST:API_DelCollection parameters:para completion:^(id data, NSError *error){}];
        
        NSMutableArray*arr=[NSMutableArray arrayWithArray:CollectionArray];
        [arr removeObjectAtIndex:indexPath.row];
        CollectionArray=[NSMutableArray arrayWithArray:arr];
        
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消收藏";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone|UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (edit==NO) {
    NSDictionary*dic=CollectionArray[indexPath.row];
    SharpDetailsViewController *sharp = [[SharpDetailsViewController alloc] init];
    sharp.sharp_id=dic[@"sharp_id"];
    [self.navigationController pushViewController:sharp animated:YES];
    }
}

@end
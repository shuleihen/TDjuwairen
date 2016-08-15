//
//  BrowserViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/27.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "BrowserViewController.h"
#import "BrowserTableViewCell.h"
#import "NoBrowserTableViewCell.h"
#import "LoginState.h"
#import "AFNetworking.h"
#import "EditView.h"
#import "SharpDetailsViewController.h"
#import "NSString+TimeInfo.h"
#import "NetworkManager.h"

@interface BrowserViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL haveBrowser;
    BOOL haveSelect;
    BOOL edit;
}
//@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *BrowserArray;
@property (nonatomic,strong) NSMutableArray *delArray;
@property (nonatomic,strong) UIBarButtonItem *editBtn;
@property(nonatomic,strong) LoginState *loginstate;
@property(nonatomic,strong) EditView *editView;
@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    [self setupWithTableView];

    self.loginstate = [LoginState addInstance];
    
    //全选，删除的view视图
    _editView = [[EditView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 50)];
    //全选button
    [_editView.selectBtn addTarget:self action:@selector(Select:) forControlEvents:UIControlEventTouchUpInside];
    haveSelect=NO;
    //删除button
    [_editView.deleteBtn addTarget:self action:@selector(Delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editView];
}
-(void)setNavigation
{
    self.edgesForExtendedLayout = UIRectEdgeNone;    //iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方
    self.title = @"浏览记录";
    
    //编辑button
    self.editBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.navigationItem.rightBarButtonItem = self.editBtn;
    edit = NO;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    self.tableview.allowsMultipleSelectionDuringEditing=YES;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    
}
#pragma mark-全选button的点击事件
-(void)Select:(UIButton*)sender
{
    if (haveSelect==NO) {
    for (int i=0; i<self.BrowserArray.count; i++) {
        NSIndexPath*indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        [self.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
        [_editView.selectBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        haveSelect=YES;
    }
    else
    {
        for (int i=0; i<self.BrowserArray.count; i++) {
        NSIndexPath*indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    }
        [_editView.selectBtn setTitle:@"全选" forState:UIControlStateNormal];
        haveSelect=NO;
    }
}
#pragma mark-删除button的点击事件
-(void)Delete:(UIButton*)sender
{
    NSMutableArray *sharpId = [NSMutableArray array];
    NSArray *selectArr = self.tableview.indexPathsForSelectedRows;
    if (selectArr.count) {
        self.delArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in selectArr) {
            NSDictionary *dic = [self.BrowserArray objectAtIndex:indexPath.row];
            [self.delArray addObject:dic];
            [sharpId addObject:dic[@"sharp_id"]];
        }
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *para = @{@"authenticationStr":self.loginstate.userId,
                               @"encryptedStr":self.str,
                               @"delete_ids":sharpId,
                               @"module_id":@"2",
                               @"userid":self.loginstate.userId};
        
        [manager POST:API_DelBrowseHistory parameters:para completion:^(id data, NSError *error){}];
        
        [self.BrowserArray removeObjectsInArray:self.delArray];
        
        [self.tableview deleteRowsAtIndexPaths:selectArr withRowAnimation:YES];
        [UIView animateWithDuration:0.5 animations:^{
            _editView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-518);
        } completion:^(BOOL finished) {
            nil;
        }];
        edit=NO;
        self.editBtn.title=@"编辑";
        [self.tableview setEditing:NO animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self requestBrowser];
    
    [self requestAuthentication];
}



//编辑button点击事件
-(void)editClick
{
    
    if (edit==NO) {
    [UIView animateWithDuration:0.5 animations:^{
        _editView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50);
    } completion:^(BOOL finished) {
        nil;
    }];
        edit = YES;
        self.editBtn.title = @"取消";
        [self.tableview setEditing:YES animated:YES];
        
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _editView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 50);
        } completion:^(BOOL finished) {
            nil;
        }];
        edit = NO;
        self.editBtn.title = @"编辑";
        [self.tableview setEditing:NO animated:YES];
        
        
    }
}

//身份验证
-(void)requestAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para=@{@"validatestring":self.loginstate.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary*dic = data;
            self.str=dic[@"str"];
        } else {
            
        }
    }];
}

#pragma mark-获取浏览记录的网络请求
-(void)requestBrowser
{
    self.BrowserArray=[[NSMutableArray alloc]init];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras = @{@"userid":self.loginstate.userId};
    
    [manager POST:API_GetBrowseHistory parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            haveBrowser=YES;
            NSArray*array = data;
            NSDictionary*dic = array[1];
            NSArray*arr = dic[@"List"];
            
            for (NSDictionary*dic in arr) {
                
                [self.BrowserArray insertObject:dic atIndex:0];
            }
            [self.tableview reloadData];
        } else {
            haveBrowser=NO;
            [self.tableview reloadData];
        }
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (haveBrowser) {
    return self.BrowserArray.count;
    }
    else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (haveBrowser) {
        NSDictionary*dic = self.BrowserArray[indexPath.row];
    [tableView registerNib:[UINib nibWithNibName:@"BrowserTableViewCell" bundle:nil] forCellReuseIdentifier:@"BrowserCell"];
    BrowserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrowserCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.editBtn.enabled = YES;
    [cell setCellWithDic:dic];
    
        return cell;
    }
    else
    {
        [tableView registerNib:[UINib nibWithNibName:@"NoBrowserTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoBrowserCell"];
        BrowserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoBrowserCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.editBtn.enabled = NO;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (haveBrowser) {

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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = [self.BrowserArray objectAtIndex:indexPath.row];
        NSMutableArray *delarr = [NSMutableArray array];
        [delarr addObject:dic[@"sharp_id"]];
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *para = @{@"authenticationStr":self.loginstate.userId,
                               @"encryptedStr":self.str,
                               @"delete_ids":delarr,
                               @"module_id":@"2",
                               @"userid":self.loginstate.userId};
        
        [manager POST:API_DelBrowseHistory parameters:para completion:^(id data, NSError *error){}];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.BrowserArray];
        [arr removeObjectAtIndex:indexPath.row];
        self.BrowserArray = [NSMutableArray arrayWithArray:arr];
        
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        
            }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone|UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (edit==NO) {
    NSDictionary *dic = self.BrowserArray[indexPath.row];
    SharpDetailsViewController *sharp = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    sharp.sharp_id = dic[@"sharp_id"];
    [self.navigationController pushViewController:sharp animated:YES];
    }
}

@end

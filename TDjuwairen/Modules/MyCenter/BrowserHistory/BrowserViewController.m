//
//  BrowserViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/27.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "BrowserViewController.h"
#import "BrowserTableViewCell.h"
#import "NothingTableViewCell.h"

#import "LoginState.h"
#import "EditView.h"
#import "SharpDetailsViewController.h"
#import "NSString+TimeInfo.h"
#import "NetworkManager.h"
#import "UIdaynightModel.h"

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
@property (nonatomic,strong) UIBarButtonItem *editItem;
@property (nonatomic, strong) UIBarButtonItem *cancelItem;
@property(nonatomic,strong) EditView *editView;
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    haveSelect = NO;
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
    [self setNavigation];
    [self setupWithTableView];
    [self setupEditToolView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self requestBrowser];
    [self requestAuthentication];
}

-(void)setNavigation
{
    self.title = @"浏览记录";
    
    //编辑button
    self.editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    
    self.navigationItem.rightBarButtonItem = self.editItem;
    edit = NO;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    self.tableview.allowsMultipleSelectionDuringEditing = YES;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.separatorInset = UIEdgeInsetsZero;
    self.tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableview];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"BrowserTableViewCell" bundle:nil] forCellReuseIdentifier:@"BrowserCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"NothingTableViewCell" bundle:nil] forCellReuseIdentifier:@"NothingCell"];
    
    self.tableview.backgroundColor = self.daynightmodel.navigationColor;
}

- (void)setupEditToolView
{
    self.editView = [[EditView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 50)];
    [self.editView.selectBtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView.deleteBtn addTarget:self action:@selector(Delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editView];
}

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
        for (int i=0; i<self.BrowserArray.count; i++) {
            NSIndexPath*indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        [self.editView.selectBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        haveSelect=YES;
    } else {
        for (int i=0; i<self.BrowserArray.count; i++) {
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
    NSArray *selectArr = self.tableview.indexPathsForSelectedRows;
    
    if (selectArr.count) {
        self.delArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in selectArr) {
            NSDictionary *dic = [self.BrowserArray objectAtIndex:indexPath.row];
            [self.delArray addObject:dic];
            [sharpId addObject:dic[@"sharp_id"]];
        }
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *para = @{@"authenticationStr":US.userId,
                               @"encryptedStr":self.str,
                               @"delete_ids":sharpId,
                               @"module_id":@"2",
                               @"userid":US.userId};
        
        [manager POST:API_DelBrowseHistory parameters:para completion:^(id data, NSError *error){}];
        
        [self.BrowserArray removeObjectsInArray:self.delArray];
        [self.tableview deleteRowsAtIndexPaths:selectArr withRowAnimation:UITableViewRowAnimationLeft];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.tableview.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
            self.editView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 50);
        } completion:^(BOOL finished) {
            
        }];
        
        edit=NO;
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
            self.str=dic[@"str"];
        } else {
            
        }
    }];
}

#pragma mark-获取浏览记录的网络请求
-(void)requestBrowser
{
    self.BrowserArray=[[NSMutableArray alloc]init];
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary*paras = @{@"userid":US.userId};
    
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
        
        BrowserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrowserCell"];
        [cell setCellWithDic:dic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NothingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NothingCell"];
        cell.backgroundColor = self.daynightmodel.backColor;
        cell.label.text = @"你还没有浏览过文章，快去看看吧~";
        cell.label.textColor = self.daynightmodel.textColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        return kScreenHeight-64;
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
        NSDictionary *para = @{@"authenticationStr":US.userId,
                               @"encryptedStr":self.str,
                               @"delete_ids":delarr,
                               @"module_id":@"2",
                               @"userid":US.userId};
        
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
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (edit == NO) {
        if (self.BrowserArray.count > 0) {
            NSDictionary *dic = self.BrowserArray[indexPath.row];
            SharpDetailsViewController *sharp = [[SharpDetailsViewController alloc] init];
            sharp.sharp_id = dic[@"sharp_id"];
            [self.navigationController pushViewController:sharp animated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end

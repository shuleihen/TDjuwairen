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

@interface BrowserViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray*BrowserArray;
    NSMutableArray*delArray;
    UIBarButtonItem*editBtn;
    BOOL haveBrowser;
    BOOL haveSelect;
    BOOL edit;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)LoginState*loginstate;
@property(nonatomic,strong)EditView*editView;
@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    self.tableview.contentInset=UIEdgeInsetsMake(-99, 0, 0, 0);
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.loginstate=[LoginState addInstance];
    self.tableview.allowsMultipleSelectionDuringEditing=YES;

    //全选，删除的view视图
    _editView=[[EditView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 50)];
    //全选button
    [_editView.selectBtn addTarget:self action:@selector(Select:) forControlEvents:UIControlEventTouchUpInside];
    haveSelect=NO;
    //删除button
    [_editView.deleteBtn addTarget:self action:@selector(Delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editView];
}
#pragma mark-全选button的点击事件
-(void)Select:(UIButton*)sender
{
    if (haveSelect==NO) {
    for (int i=0; i<BrowserArray.count; i++) {
        NSIndexPath*indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        [self.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
        [_editView.selectBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        haveSelect=YES;
    }
    else
    {
        for (int i=0; i<BrowserArray.count; i++) {
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
    NSMutableArray*sharpId=[NSMutableArray array];
    NSArray*selectArr=self.tableview.indexPathsForSelectedRows;
    if (selectArr.count) {
        delArray=[NSMutableArray array];
        for (NSIndexPath*indexPath in selectArr) {
            NSDictionary*dic=[BrowserArray objectAtIndex:indexPath.row];
            [delArray addObject:dic];
            [sharpId addObject:dic[@"sharp_id"]];
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/index.php/Public/delBrowseHistory"];
        NSDictionary*para=@{@"authenticationStr":self.loginstate.userId,
                            @"encryptedStr":self.str,
                            @"delete_ids":sharpId,
                            @"module_id":@"2",
                            @"userid":self.loginstate.userId};
        
        [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString*code=[responseObject objectForKey:@"code"];
            NSLog(@"%@",responseObject);
            if ([code isEqualToString:@"200"]) {
                NSArray*arr=responseObject[@"data"];
                NSLog(@"%@",arr);
                NSLog(@"删除成功");
            }
            else {
                NSLog(@"删除失败");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"1");
        }];
        
        [BrowserArray removeObjectsInArray:delArray];
        
        [self.tableview deleteRowsAtIndexPaths:selectArr withRowAnimation:YES];
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self requestBrowser];
    [self setNavigation];
    [self requestAuthentication];
}

-(void)setNavigation
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    label.text=@"浏览记录";
    self.navigationItem.titleView=label;
    
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
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Public/getapivalidate/"];
    NSDictionary*para=@{@"validatestring":self.loginstate.userId};
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary*dic=responseObject[@"data"];
            self.str=dic[@"str"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark-获取浏览记录的网络请求
-(void)requestBrowser
{
    BrowserArray=[[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/index.php/Public/getBrowseHistory"];
    NSDictionary*paras=@{@"userid":self.loginstate.userId};
    [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            haveBrowser=YES;
            NSArray*array=responseObject[@"data"];
            NSDictionary*dic=array[1];
            NSArray*arr=dic[@"List"];
            
            for (NSDictionary*dic in arr) {
                [BrowserArray addObject:dic];
            }
            [self.tableview reloadData];
        }
        else if ([code isEqualToString:@"300"])
        {
            haveBrowser=NO;
            [self.tableview reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (haveBrowser) {
    return BrowserArray.count;
    }
    else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (haveBrowser) {
        NSDictionary*dic=BrowserArray[indexPath.row];
    [tableView registerNib:[UINib nibWithNibName:@"BrowserTableViewCell" bundle:nil] forCellReuseIdentifier:@"BrowserCell"];
    BrowserTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"BrowserCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        editBtn.enabled=YES;
    [cell setCellWithDic:dic];
    
        return cell;
    }
    else
    {
        [tableView registerNib:[UINib nibWithNibName:@"NoBrowserTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoBrowserCell"];
        BrowserTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"NoBrowserCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        editBtn.enabled=NO;
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
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSDictionary*dic=[BrowserArray objectAtIndex:indexPath.row];
        NSMutableArray*delarr=[NSMutableArray array];
        [delarr addObject:dic[@"sharp_id"]];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/index.php/Public/delBrowseHistory"];
        NSDictionary*para=@{@"authenticationStr":self.loginstate.userId,
                            @"encryptedStr":self.str,
                            @"delete_ids":delarr,
                            @"module_id":@"2",
                            @"userid":self.loginstate.userId};
        NSLog(@"%@",para);
        [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString*code=[responseObject objectForKey:@"code"];
            NSLog(@"%@",responseObject);
            if ([code isEqualToString:@"200"]) {
                NSArray*arr=responseObject[@"data"];
                NSLog(@"删除成功");
            }
            else {
                NSLog(@"删除失败");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        NSMutableArray*arr=[NSMutableArray arrayWithArray:BrowserArray];
        [arr removeObjectAtIndex:indexPath.row];
        BrowserArray=[NSMutableArray arrayWithArray:arr];
        
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
    NSDictionary*dic=BrowserArray[indexPath.row];
    SharpDetailsViewController*sharp=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    sharp.sharp_id=dic[@"sharp_id"];
    [self.navigationController pushViewController:sharp animated:YES];
    }
}

@end

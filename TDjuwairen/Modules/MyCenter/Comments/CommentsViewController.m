//
//  CommentsViewController.m
//  TDjuwairen
//
//  Created by tuanda on 16/6/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CommentsViewController.h"
#import "CategoryView.h"
#import "CommentsChildTableViewController.h"

#import "UIdaynightModel.h"

@interface CommentsViewController ()<CategoryDeletate,CommentsChildDelegate,UIScrollViewDelegate>
{
    int num;
}
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSArray *categoryArr;
@property (nonatomic,strong) CategoryView *cateview;

@property (nonatomic,strong) UIScrollView *contentScroll;
@property (nonatomic,strong) NSMutableArray *tableviewsArr;
@end

@implementation CommentsViewController

- (NSArray *)categoryArr
{
    if (!_categoryArr) {
        _categoryArr = @[@"调研",@"观点"];
    }
    return _categoryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.tableviewsArr = [NSMutableArray array];
    self.page = 1;
    
    
    [self setNavigation];
    [self setupWithCategoryScroll];  //设置选择滚动条
    [self setupWithContentScroll];
    [self addChildViewController];
    
    [self ClickBtn:self.cateview.selectBtn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setNavigation
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"评论管理";
}

#pragma mark - 设置分类滑动条
- (void)setupWithCategoryScroll{
    self.cateview = [[CategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) andTitleArr:self.categoryArr];
    self.cateview.delegate = self;
    self.cateview.backgroundColor = self.daynightmodel.navigationColor;
    self.cateview.scrollview.backgroundColor = self.daynightmodel.navigationColor;
    self.cateview.line1.layer.backgroundColor = self.daynightmodel.lineColor.CGColor;
    self.cateview.line2.layer.backgroundColor = self.daynightmodel.lineColor.CGColor;
    [self.view addSubview:self.cateview];
    
}

#pragma mark - 设置内容滑动条
- (void)setupWithContentScroll{
    self.contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-104)];
    self.contentScroll.delegate = self;
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = NO;
    self.contentScroll.pagingEnabled = YES;
    self.contentScroll.backgroundColor = self.daynightmodel.navigationColor;
    
    [self.view addSubview:self.contentScroll];
    self.contentScroll.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, kScreenHeight-104);
}

- (void)addChildViewController{
    
    self.tableviewsArr = [NSMutableArray array];
    for (int i = 0; i<self.categoryArr.count; i++) {
        CommentsChildTableViewController *vc  = [[CommentsChildTableViewController alloc] init];
        vc.delegate = self;
        vc.title  =  self.categoryArr[i];
        vc.view.backgroundColor = self.daynightmodel.navigationColor;
        
        [self.tableviewsArr addObject:vc];
        [self addChildViewController:vc];
    }
}

//代理点击方法
- (void)ClickBtn:(UIButton *)sender
{
    self.cateview.selectBtn.selected = NO;
    sender.selected = YES;
    self.cateview.selectBtn = sender;
    
    self.cateview.selectLab.frame = CGRectMake(sender.frame.origin.x, 38, 70, 2);
    
    NSInteger i = sender.tag;
    CGFloat x = i*kScreenWidth;
    num = (int)i;
    self.contentScroll.contentOffset = CGPointMake(x, 0);
    CommentsChildTableViewController *vc = self.tableviewsArr[num];
    [vc requestComment:num];
    
    [self setUpOneChildController:i];
}

- (void)setUpOneChildController:(NSInteger)index {
    
    CGFloat x  = index * kScreenWidth;
    UIViewController *vc  =  self.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, kScreenWidth, kScreenHeight-104);//50:TabBar高度
    
    [self.contentScroll addSubview:vc.view];
    
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = self.contentScroll.contentOffset.x / kScreenWidth;
    
    self.cateview.selectBtn.selected = NO;
    UIButton *btn = self.cateview.btnsArr[i];
    btn.selected = YES;
    self.cateview.selectBtn = btn;
    self.cateview.selectLab.frame = CGRectMake(70*i, 38, 70, 2);
    
    num = (int)i;
    CommentsChildTableViewController *vc = self.tableviewsArr[num];
    [vc requestComment:num];
    [self setUpOneChildController:i];
}
/*
- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"CommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentsCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"NothingTableViewCell" bundle:nil] forCellReuseIdentifier:@"NothingCell"];
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    [self.view addSubview:self.tableview];
}

-(void)requestComments
{
    __weak CommentsViewController *wself = self;
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras = @{@"userid":US.userId,
                         @"module_id":@"2",
                         @"page":[NSString stringWithFormat:@"%d",self.page]};
    
    [manager POST:API_GetUserComment parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArray = data;
            
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;
                if (wself.page == 1) {
                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                } else {
                    list = [NSMutableArray arrayWithArray:wself.CommentsArray];
                }
                
                for (NSDictionary *d in dataArray) {
                    CommentManagerModel *model = [CommentManagerModel getInstanceWithDictionary:d];
                    [list addObject:model];
                }
                wself.CommentsArray = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
            }
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
            [wself.tableview reloadData];

        } else {
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
            [self.tableview reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.CommentsArray.count > 0) {
        return self.CommentsArray.count;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.CommentsArray.count > 0) {
        CommentManagerModel *model = self.CommentsArray[indexPath.row];
        CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
        [cell setCellWithDic:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        
        NothingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NothingCell"];
        cell.backgroundColor = self.daynightmodel.backColor;
        cell.label.text = @"暂无评论，快去发表吧~";
        cell.label.textColor = self.daynightmodel.textColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.CommentsArray.count > 0) {
        return 136;
    }
    else{
        return kScreenHeight-64;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.CommentsArray.count > 0) {
        CommentManagerModel *model = self.CommentsArray[indexPath.row];
        SharpDetailsViewController *sharp = [[SharpDetailsViewController alloc] init];
        sharp.sharp_id = model.sharpcomment_sharpid;
        [self.navigationController pushViewController:sharp animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
*/
@end

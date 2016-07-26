//
//  ViewPointViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ViewPointViewController.h"
#import "CategoryView.h"
#import "NetworkManager.h"
#import "ViewPointListModel.h"
#import "ViewPointTableViewCell.h"
#import "ViewSpecialTableViewCell.h"

#import "NSString+Ext.h"
#import "UIImageView+WebCache.h"
#import "NetworkManager.h"
@interface ViewPointViewController ()<UIScrollViewDelegate,CategoryDeletate,UITableViewDelegate,UITableViewDataSource>
{
    int num;
    CGSize titlesize;
}

@property (nonatomic,strong) CategoryView *cateview;

@property (nonatomic,strong) UIScrollView *contentScroll;

@property (nonatomic,strong) NSArray *categoryArr;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSMutableArray *tableviewsArr;

@property (nonatomic,assign) int page;
@property (nonatomic,strong) NSMutableArray *viewRecArr;
@property (nonatomic,strong) NSMutableArray *viewNewArr;
@property (nonatomic,strong) NSMutableArray *viewSpeArr;
@property (nonatomic,strong) NSArray *dataArr;


@end

@implementation ViewPointViewController

- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSArray *)categoryArr
{
    if (!_categoryArr) {
        _categoryArr = @[@"推荐",@"最新",@"专题"];
    }
    return _categoryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    num = 0;
    self.tableviewsArr = [NSMutableArray array];
    self.viewRecArr = [NSMutableArray array];
    self.viewNewArr = [NSMutableArray array];
    self.viewSpeArr = [NSMutableArray array];
    self.dataArr = @[self.viewRecArr,self.viewNewArr,self.viewSpeArr];
    [self setupWithNavigation];
    [self setupWithCategoryScroll];
    [self setupWithContentScroll];
    [self requestDataWithNumber:num];
    // Do any additional setup after loading the view.
}

- (void)requestDataWithNumber:(int)n{
    __weak ViewPointViewController *wself = self;
    NSString *urlPath;
    if (n == 0) {
        urlPath = [NSString stringWithFormat:@"http://appapi.juwairen.net/index.php/View/recLists1_2/page/%d",self.page];
    }
    else if (n == 1){
        urlPath = [NSString stringWithFormat:@"http://appapi.juwairen.net/index.php/View/newLists1_2/page/%d",self.page];
    }
    else
    {
        urlPath = [NSString stringWithFormat:@"http://192.168.1.100/tuanda_web/Appapi/index.php/Subject/newLists1_2/page/%d",self.page];//接口暂无
    }
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:urlPath parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArray = data;
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;

                if (wself.page == 1) {
                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                } else {
                    list = [NSMutableArray arrayWithArray:wself.dataArr[num]];
                }
                NSMutableArray *arr = wself.dataArr[num];
                
                for (NSDictionary *d in dataArray) {
                    ViewPointListModel *model = [ViewPointListModel getInstanceWithDictionary:d];
                    [list addObject:model];
                    [arr addObject:model];
                }
            }
            UITableView *tableview = wself.tableviewsArr[num];
            [tableview reloadData];
        } else {
            NSLog(@"请求失败");
        }
    }];
    
}

- (void)setupWithNavigation{
    self.edgesForExtendedLayout = UIRectEdgeNone;    //iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方
    //设置navigation背景色
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"观点";
    // 设置标题颜色，和大小,如果标题是使用titleView方式定义不行
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    UIBarButtonItem *publish = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_publish@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(GoPublish:)];
    UIBarButtonItem *search = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_search@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(GoSearch:)];
    
    self.navigationItem.rightBarButtonItems = @[publish,search];
}

#pragma mark - 设置分类滑动条
- (void)setupWithCategoryScroll{
    self.cateview = [[CategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 40) andTitleArr:self.categoryArr];
    self.cateview.delegate = self;
    [self.view addSubview:self.cateview];
    
}

#pragma mark - 设置内容滑动条
- (void)setupWithContentScroll{
    self.contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-64-64)];
    self.contentScroll.delegate = self;
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = NO;
    self.contentScroll.pagingEnabled = YES;
    [self.view addSubview:self.contentScroll];
    

    for (int i = 0; i<self.categoryArr.count; i++) {
        UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight-64-64) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;

        [self.tableviewsArr addObject:tableview];
        [self.contentScroll addSubview:tableview];
    }
    self.contentScroll.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, kScreenHeight-64-64);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = self.dataArr[num];
    if (tableView == self.tableviewsArr[0] || tableView == self.tableviewsArr[1]) {
        return arr.count;
    }
    else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSMutableArray *arr = self.dataArr[num];
    if (tableView == self.tableviewsArr[0] || tableView == self.tableviewsArr[1]) {
        NSString *identifier = @"cell";
        ViewPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ViewPointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        ViewPointListModel *model = arr[indexPath.row];
//        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.user_facemin]];
        NSString *isoriginal;
        if ([model.view_isoriginal isEqualToString:@"0"]) {
            isoriginal = @"转载";
        }else
        {
            isoriginal = @"原创";
        }
        cell.nicknameLabel.text = [NSString stringWithFormat:@"%@  %@  %@",model.user_nickname,model.view_wtime,isoriginal];

        UIFont *font = [UIFont systemFontOfSize:16];
        cell.titleLabel.font = font;
        cell.titleLabel.numberOfLines = 0;
        titlesize = CGSizeMake(kScreenWidth-30, 500.0);
        titlesize = [model.view_title calculateSize:titlesize font:font];
        cell.titleLabel.text = model.view_title;
        [cell.titleLabel setFrame:CGRectMake(15, 15+25+10, kScreenWidth-30, titlesize.height)];
        return cell;
    }
    else
    {
        NSString *identifier = @"ce";
        ViewSpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ViewSpecialTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableviewsArr[0] || tableView == self.tableviewsArr[1]) {
        return 15+25+10+titlesize.height+15;
    }
    else
    {
        return kScreenWidth/2+40+10;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int x = self.contentScroll.contentOffset.x/kScreenWidth;
    num = x;
    self.cateview.selectBtn.selected = NO;
    UIButton *btn = self.cateview.btnsArr[x];
    btn.selected = YES;
    self.cateview.selectBtn = btn;
    
    self.cateview.selectLab.frame = CGRectMake(70*x, 38, 70, 2);
    [self requestDataWithNumber:num];
    
}

- (void)GoPublish:(UIButton *)sender{
    
}

- (void)GoSearch:(UIButton *)sender{
    
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
    [self requestDataWithNumber:num];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  SharpDetailsViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>

#import "SharpDetailsViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "BackCommentView.h"
#import "NSString+TimeInfo.h"
#import "NSString+Ext.h"


//刷新
#import "FCXRefreshFooterView.h"
#import "FCXRefreshHeaderView.h"
#import "UIScrollView+FCXRefresh.h"

#import "LoginState.h"
#import "TitlesTableViewCell.h"
#import "AddCollectionTableViewCell.h"
#import "ShowTableViewCell.h"
#import "CommentsModel.h"
#import "SharpTags.h"
#import "LoginTableViewController.h"
#import "CollectionViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

//测试
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
/* loading */
#import "FSSyncSpinner.h"
@import WebKit;

@interface SharpDetailsViewController ()<WKNavigationDelegate,WKUIDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate>
{
    int page;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
    
    CGSize commentsize;
    CGSize originalsize;
    
    NSString *typeid;
    NSString *encryptedStr;
    NSString *title;
    NSString *nickname;
    NSString *facesmall;
    NSString *time;
    NSString *iscollect;
    NSString *isoriginal;   //是否原创0是1不是
    NSString *commentNum;
    NSString *desc;
    NSString *sharpimg;
    UIView *bgView;    //点击放大图片背景
    
    UILabel *label;
    UIButton *button;
    UIView *view;
    NSTimer *myTimer;
    BOOL firstClickComment;
    
}

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) WKWebView *webview;
@property (nonatomic) BOOL scalesPageToFit;
/* 评论条 */
@property (nonatomic,strong) BackCommentView *backcommentview;
/* 加载页 */
@property (nonatomic,strong) UIView *loadingBackView;
/* 设置加载控件 */
@property (nonatomic,strong) FSSyncSpinner *indicator;
/* 设置加载图片 */
@property (nonatomic,strong) UIImageView *loadingImgView;
@property (nonatomic,strong) UILabel *loading1;
@property (nonatomic,strong) UILabel *loading2;

@property (nonatomic,strong) NSMutableArray *commentsDataArray;
@property (nonatomic,strong) NSArray *sharpTagsArray;

@property (nonatomic,strong) SharpTags *tagList;

@property (nonatomic,strong) LoginState *loginstate;

/* 点击放大图片 */
@property (nonatomic,strong) UIImageView *imgView;
/* 文章中的所有图片 */
@property (nonatomic,strong) NSMutableArray *imageViews;

@end

@implementation SharpDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.commentsDataArray = [NSMutableArray array];
    self.sharpTagsArray = [NSMutableArray array];
    self.loginstate = [LoginState addInstance];
    page = 1;
    [self setupWithTableView];
    
    [self setupWithStatusBar];             //设置状态栏
    
//    [self requestDataWithComments];
    
    //    [self setupWithCommentView];           //设置评论栏
    
    [self addRefreshView];           //设置刷新
    [self refreshAction];
    // Do any additional setup after loading the view.
}
- (void)setNavigation{
    //设置返回button
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage* image = [UIImage imageNamed:@"back"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}

#pragma mark - 添加刷新
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [self.tableview addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshAction];
    }];
    
    //上拉加载更多
    footerView = [self.tableview addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf loadMoreAction];
    }];
    
//    [self.tableview reloadData];
    //自动刷新
    //    footerView.autoLoadMore = self.autoLoadMore;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableview reloadData];
//    });
}

- (void)refreshAction {
    __weak UITableView *weakTableView = self.tableview;
    __weak FCXRefreshHeaderView *weakHeaderView = headerView;
    //数据表页数为1
    page = 1;
    [self requestDataWithUrl];
    [self requestDataWithComments];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakHeaderView endRefresh];
        [weakTableView reloadData];
    });
}

- (void)loadMoreAction {
    __weak UITableView *weakTableView = self.tableview;
    __weak FCXRefreshFooterView *weakFooterView = footerView;
    page++;
    //继续请求
    [self requestDataWithComments];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakFooterView endRefresh];
        [weakTableView reloadData];
    });
}

#pragma mark - 请求评论数据
- (void)requestDataWithComments{
    
    NSString *string = [NSString stringWithFormat:@"%@getSharpComnment/id/%@/page/%d",kAPI_Sharp,self.sharp_id,page];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (page == 1) {
            [self.commentsDataArray removeAllObjects];
        }
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            NSArray *arr = responseObject[@"data"];
            for (NSDictionary *d in arr) {
                /* 转模型 */
                CommentsModel *model = [CommentsModel getInstanceWithDictionary:d];
                [self.commentsDataArray addObject:model];
            }
        }
        else
        {
            NSLog(@"没有更多了");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
            [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

#pragma mark - 请求数据
- (void)requestDataWithUrl{
    self.loadingBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.loadingBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loadingBackView];
    
    self.loadingImgView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-kScreenWidth/4)/2+10, kScreenHeight/736*298, kScreenWidth/4, kScreenWidth/10)];
    self.loadingImgView.image = [UIImage imageNamed:@"loadingLogo.png"];
    [self.loadingBackView addSubview:self.loadingImgView];
    
    self.loading1 = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeight/2-5, kScreenWidth, 20)];
    self.loading1.text = @"投资看公司";
    self.loading1.font = [UIFont systemFontOfSize:16];
    self.loading1.textColor = [UIColor lightGrayColor];
    self.loading1.textAlignment = NSTextAlignmentCenter;
    [self.loadingBackView addSubview:self.loading1];
    
    self.loading2 = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeight/2+20, kScreenWidth, 20)];
    self.loading2.text = @"分享有价值的信息";
    self.loading2.font = [UIFont systemFontOfSize:16];
    self.loading2.textColor = [UIColor lightGrayColor];
    self.loading2.textAlignment = NSTextAlignmentCenter;
    [self.loadingBackView addSubview:self.loading2];
    
    self.indicator = [[FSSyncSpinner alloc]initWithFrame:CGRectMake(-30, 0, 30, 30)];
    [self.loadingImgView addSubview:self.indicator];
    [self.indicator startAnimating];
    NSString *url;
    if (self.loginstate.isLogIn) {
        url = [NSString stringWithFormat:@"%@show/id/%@/userid/%@",kAPI_Sharp,self.sharp_id,self.loginstate.userId];
        
    }
    else
    {
        url = [NSString stringWithFormat:@"%@show/id/%@",kAPI_Sharp,self.sharp_id];
        
    }
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        self.sharpTagsArray = data[@"tags"];
        NSString *string = data[@"sharp_content"];
        typeid = data[@"sharp_typeid"];
        title = data[@"sharp_title"];
        desc = data[@"sharp_desc"];
        nickname = data[@"user_nickname"];
        facesmall = data[@"userinfo_facesmall"];
        time = data[@"sharp_wtime"];
        commentNum = data[@"sharpcommentNumbers"];
        iscollect = data[@"sharp_iscollect"];
        isoriginal = data[@"sharp_isoriginal"];
        sharpimg = data[@"sharp_pic280"];
        if ([commentNum intValue] > 0) {
            NSString *text;
            if ([commentNum intValue] >999) {
                text = @"999+";
            }else
            {
                text = [NSString stringWithFormat:@"%@",commentNum];
            }
            CGSize size = CGSizeMake(50, 200.0f);
            UIFont *font = [UIFont systemFontOfSize:11];
            CGSize btnsize = [text calculateSize:size font:font];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-100+28, 8, btnsize.width+10, btnsize.height)];
            btn.titleLabel.font = [UIFont systemFontOfSize: 11];
            btn.layer.cornerRadius = btnsize.height/2;
            [btn setBackgroundColor:[UIColor colorWithRed:27/255.0 green:105/255.0 blue:177/255.0 alpha:1.0]];
            [btn setTitle:text forState:UIControlStateNormal];
            //新增点击滑动
            [btn addTarget:self action:@selector(ClickComments:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.backcommentview addSubview:btn];
        }
     
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img\\ssrc[^>]*/>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
//        NSArray *result = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
//        
//        NSMutableDictionary *urlDicts = [[NSMutableDictionary alloc] init];
//        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        
//        for (NSTextCheckingResult *item in result) {
//            NSString *imgHtml = [string substringWithRange:[item rangeAtIndex:0]];
//            
//            NSArray *tmpArray = nil;
//            if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
//                tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
//            } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
//                tmpArray = [imgHtml componentsSeparatedByString:@"src="];
//            }
//            
//            if (tmpArray.count >= 2) {
//                NSString *src = tmpArray[1];
//                
//                NSUInteger loc = [src rangeOfString:@"\""].location;
//                if (loc != NSNotFound) {
//                    src = [src substringToIndex:loc];
//                    if (src.length > 0) {
//                        NSString *localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
//                        // 先将链接取个本地名字，且获取完整路径
//                        [urlDicts setObject:localPath forKey:src];
//                    }
//                }
//            }
//        }
        if ([typeid isEqualToString:@"3"]) {
            //测试替换iframe标签宽高
            NSString *s = @"iframe";
//            NSRange range = [string rangeOfString:s];
            if ([string rangeOfString:s].location != NSNotFound) {
                //
                NSString *oldiframe = @"height=\"500\" width=\"600\"";
                NSString *newIframe = @"height=\"40%\" width=\"100%\"";
                string = [string stringByReplacingOccurrencesOfString:oldiframe withString:newIframe];
            }
        }
        else {
            //测试替换iframe标签宽高
            NSString *s = @"iframe";
            //            NSRange range = [string rangeOfString:s];
            if ([string rangeOfString:s].location != NSNotFound) {
                //
                NSString *oldiframe = @"height=\"500\" width=\"600\"";
                NSString *newIframe = @"height=\"250\" width=\"100%\"";
                string = [string stringByReplacingOccurrencesOfString:oldiframe withString:newIframe];
            }
        }
        
        // iOS webkit preload 没有预加载视频导致视频背景为白色，使用autoplay替换
        string = [string stringByReplacingOccurrencesOfString:@"preload" withString:@"autoplay"];
        
//        NSString *newstring ;
//         遍历所有的URL，替换成本地的URL，并异步获取图片
//        for (NSString *src in urlDicts.allKeys) {
//            
//            NSString *localPath = [urlDicts objectForKey:src];
//            newstring = [string stringByReplacingOccurrencesOfString:src withString:localPath];
//            // 如果已经缓存过，就不需要重复加载了。
//            if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
//                [self downloadImageWithUrl:src];
//            }
//        }
//        if (result.count == 0) {
//        self.webview.allowsLinkPreview = YES;
            [self.webview loadHTMLString:string baseURL:nil];
//        }
//        else
//        {
//            [self.webview loadHTMLString:newstring baseURL:nil];
//        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{

            /* 数据请求完成后刷新tableview */
            [self.tableview reloadData];
//        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}



- (void)downloadImageWithUrl:(NSString *)src {
    // 注意：这里并没有写专门下载图片的代码，就直接使用了AFN的扩展，只是为了省麻烦而已。
    UIImageView *imgView = [[UIImageView alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
    
    imgView.image = [UIImage imageNamed:src];
    [imgView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        NSData *data = UIImagePNGRepresentation(image);
        
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        NSString *localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
        
        [data writeToFile:localPath atomically:YES];
        
        
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"下载图像失败: %@", src);
    }];
    
    if (self.imageViews == nil) {
        self.imageViews = [[NSMutableArray alloc] init];
    }
    [self.imageViews addObject:imgView];
}

- (NSString *)md5:(NSString *)sourceContent {
    if (self == nil || [sourceContent length] == 0) {
        return nil;
    }
    
    unsigned char digest[16], i;
    CC_MD5([sourceContent UTF8String], (int)[sourceContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < 16; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}
/* 同步请求
 - (void)requestDataWithWebView{
 //同步请求
 NSString *string = [NSString stringWithFormat:@"http://appapi.juwairen.net/index.php/Sharp/show/id/%@",self.sharp_id];
 NSURL *url = [NSURL URLWithString:string];
 //通过URL创建网络请求
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 [request setHTTPMethod:@"GET"];
 NSURLResponse *response = nil;
 NSError *error = nil;
 
 //创建链接对象，并发送请求，获取结果
 NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
 NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
 NSObject *object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
 NSDictionary *dic = (NSDictionary *)object;
 
 NSDictionary *d = dic[@"data"];
 NSString *content = d[@"sharp_content"];
 NSLog(@"%@",content);
 [self.webview loadHTMLString:content baseURL:nil];
 [self.tableview reloadData];
 
 }
 */

#pragma mark - 设置tableview
- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableview];
}

#pragma mark - create tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    else
    {
        /* 判断评论数组中是否有数据 */
        if (self.commentsDataArray.count == 0) {
            //没有
            return 2;
        }
        else
        {
            return self.commentsDataArray.count + 1;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TitlesTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            if (titleCell == nil) {
                titleCell = [[TitlesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
            }
            titleCell.titleLabel.text = title;
            NSString *custime = [NSString prettyDateWithReference:time];
            titleCell.usernickname.text = [NSString stringWithFormat:@"%@ · %@",nickname,custime];
            [titleCell.userheadImage sd_setImageWithURL:[NSURL URLWithString:facesmall]];
            return titleCell;
        }
        else if(indexPath.row == 1){
            NSString *identifier = @"webcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            if (!self.webview) {
                self.webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight)];
                self.webview.UIDelegate = self;
                self.webview.navigationDelegate = self;
                /* 禁止滚动 */
                self.webview.scrollView.scrollEnabled = NO;
                
                [cell.contentView addSubview:self.webview];
//                FIXME: 在cell显示回调里不要去请求数据，你在请求结果有刷新tableview，这样很容易就出现循环
//                [self requestDataWithUrl];
            }
            return cell;
        }
        else if (indexPath.row == 2){
            AddCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addcollectioncell"];
            if (cell == nil) {
                cell = [[AddCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addcollectioncell"];
            }
            if ([iscollect intValue] == 0) {
                [cell.addCollection setBackgroundImage:[UIImage imageNamed:@"收藏.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.addCollection setBackgroundImage:[UIImage imageNamed:@"收藏成功.png"] forState:UIControlStateNormal];
            }
            [cell.addCollection addTarget:self action:@selector(ClickAdd:) forControlEvents:UIControlEventTouchUpInside];
            //设置三秒内不可重复点击
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        
        else if(indexPath.row == 3){
            /* 这里是文章标签 */
            NSString *identifier = @"tagscell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backgroundColor = [UIColor clearColor];
            [self.tagList removeFromSuperview];
            self.tagList = [[SharpTags alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth, 1)];
            self.tagList.signalTagColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
            self.tagList.BGColor = [UIColor clearColor];
            
            /* 判断sharpTagsArray是否为空 */
            if ((NSNull *)self.sharpTagsArray != [NSNull null]) {
                NSArray *arr = [NSArray array];
                if (self.sharpTagsArray.count > 4) {
                    arr = [self.sharpTagsArray subarrayWithRange:NSMakeRange(0, 4)];
                }else
                {
                    arr = self.sharpTagsArray;
                }
                [self.tagList setTagWithTagArray:arr];
            }
            [cell addSubview:self.tagList];
            
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 4){
            NSString *identifier = @"isoriginal";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSString *text;
            if ([isoriginal isEqualToString:@"1"]) {
                if ([typeid isEqualToString:@"1"]) {
                    text = @"该篇调研文章是实地调查取材，仅供用户阅读，版权归局外人网站所有，不得擅自以其他媒体等公共形式流传，违者需赔偿我方版权损失， 我方并将保留法律诉讼的权利。";
                }
                else
                {
                    text = @"文章原创，禁止恶意转载，转载请注明出处和作者!";
                }
            }
            else
            {
                text = @" 本文文章内容从互联网转载，最终版权归原作者所有。";
            }
            

            UIFont *font = [UIFont systemFontOfSize:16];
            cell.textLabel.font = font;
            cell.textLabel.numberOfLines = 0;
            originalsize = CGSizeMake(kScreenWidth-16, 20000.0f);
            originalsize = [text calculateSize:originalsize font:font];
            cell.textLabel.text = text;
            cell.textLabel.textColor = [UIColor colorWithRed:56/255.0 green:115/255.0 blue:178/255.0 alpha:1.0];
            [cell.textLabel setFrame:CGRectMake(8, 15, kScreenWidth-16, originalsize.height)];
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NSString *identifier = @"spacecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    /* 这里是·列表展示 */
    else
    {
        if (indexPath.row == 0) {
            NSString *identifier = @"aboutcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text = @"相关评论";
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            /* 当前没有评论时 */
            if (self.commentsDataArray.count == 0) {
                NSString *identifier = @"cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.textLabel.text = @"当前文章还没有评论";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                /* cell的选中样式为无色 */
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"showcell"];
                if (cell == nil) {
                    cell = [[ShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"showcell"];
                }
                CommentsModel *model = self.commentsDataArray[indexPath.row-1];
                
                [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.user_headImg]];
                cell.nicknameLabel.text = model.user_nickName;
                
                NSString *currenttime = [NSString prettyDateWithReference:model.commentTime];
                cell.timeLabel.text = currenttime;
                NSString *text = model.comment;
                cell.commentsLabel.text = text;
                UIFont *font = [UIFont systemFontOfSize:15];
                cell.commentsLabel.font = font;
                commentsize = CGSizeMake(kScreenWidth-55-15, 20000.0f);
                commentsize = [text calculateSize:commentsize font:font];
                [cell.commentsLabel setFrame:CGRectMake(15+30+10, 10+15+5+12+10, kScreenWidth-55-15, commentsize.height)];
                
                return cell;
            }
        }
    }
}

#pragma mark - 滚动tableview时键盘消失
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.backcommentview.commentview resignFirstResponder];
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 设置状态栏
- (void)setupWithStatusBar{
    UIView *status = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    status.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:status];
}

// 类似 UIWebView的 -webView: shouldStartLoadWithRequest: navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if([strRequest isEqualToString:@"about:blank"]) {//主页面加载内容
        decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
    } else {//截获页面里面的链接点击
        //do something you want
        decisionHandler(WKNavigationActionPolicyCancel);//不允许跳转
    }
}


#pragma mark - 计算webview的contentsize
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (webView.isLoading) {
        return;
    }
    if (![typeid isEqualToString:@"3"]) {
        //减小段落间距
        NSString *s1 = @"var pNode=document.getElementsByTagName('p');\
        for(var i in pNode){\
        pNode[i].style.margin=0;\
        if(pNode[i].innerHTML=='&nbsp;'){\
        pNode[i].innerHTML='';\
        }\
        }";
        
        NSString *s2 = @"var spanNode=document.getElementsByTagName('span');\
        for(var x in spanNode){\
        if(spanNode[x].innerHTML=='&nbsp;'){\
        spanNode[x].innerHTML='';\
        }\
        }";
        
        //br标签高度，
        NSString *s3 = @"var brNode=document.getElementsByTagName('br');\
        for(var j in brNode){\
        brNode[j].className='';\
        brNode[j].style.lineHeight='1';\
        var brparentNode=brNode[j].parentNode;\
        if(brparentNode.innerHTML=='<br>'){\
            brNode[j].parentNode.style.lineHeight='4px';\
            \
        }\
        }";
        
        /* 修改图片和字之间的距离 */
        NSString *s4 = @"var labelNode=document.getElementsByClassName('article_photo_label');\
        for(var z=0; z<labelNode.length;z++){\
        labelNode[z].style.lineHeight=1.6;\
        labelNode[z].style.fontFamily='AmericanTypewriter-CondensedLight';\
        }";
        
        NSString *s5 = @"var emphasisNode=document.getElementsByClassName('article_emphasis');\
        for(var k=0; k<labelNode.length;k++){\
        emphasisNode[k].style.lineHeight=1.6;\
        }";
        
        //调整字号
        NSString *s6 = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
        
        NSString *s7 = @"var detail_contentNode=document.getElementsByClassName('detail_content');\
        for(var i=0;i<detail_contentNode.length;i++){\
            detail_contentNode[i].style.padding=0;\
        }";
        
        //更改行间距
        NSString *s8 = @"var descriptionsNode=document.getElementsByClassName('article_descriptions');\
        for(var p=0; p<descriptionsNode.length;p++){\
            descriptionsNode[p].style.lineHeight=1.7;\
        }";
        
        //让视频铺满屏幕自适应
        NSString *s9 = @"var videoNode=document.getElementsByTagName('video');\
        for(var i=0;i<videoNode.length;i++){\
        videoNode[i].style.width='100%';\
        videoNode[i].style.maxHeight='100%';\
        }";
        
        [webView evaluateJavaScript:s1 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
        
        [webView evaluateJavaScript:s2 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
        
        [webView evaluateJavaScript:s3 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
        
        [webView evaluateJavaScript:s4 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
        
        [webView evaluateJavaScript:s5 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
        
        [webView evaluateJavaScript:s6 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //字体大小
            //        CGFloat TextSize = [result doubleValue];
        }];
        
        [webView evaluateJavaScript:s7 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
        
        [webView evaluateJavaScript:s8 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
        
        [webView evaluateJavaScript:s9 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
    }
    
    //获取内容高度
    //延时1秒。。。加了两秒是为了解决因为线程冲突引起的白屏现象。。5s没有。6sp有
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //获取页面高度，并重置webview的frame
            CGFloat documentHeight = [result doubleValue];
            CGRect frame = webView.frame;
            frame.size.height = documentHeight + 10/*显示不全*/;
            webView.frame = frame;
            //主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
                //停止加载样式
                [_indicator startAnimating];
                self.loadingImgView.alpha = 0.0;
                [self.loadingImgView removeFromSuperview];
                self.loading1.alpha = 0.0;
                [self.loading1 removeFromSuperview];
                self.loading2.alpha = 0.0;
                [self.loading2 removeFromSuperview];
                self.loadingBackView.alpha = 0.0;
                [self.loadingBackView removeFromSuperview];

            });
        }];
    });
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation;{
    NSLog(@"页面加载失败");
}


#pragma mark 显示大图片
-(void)showBigImage:(NSString *)imageUrl{
    //创建黑色背景，使其背后内容不可操作
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [bgView setBackgroundColor:[UIColor colorWithRed:0.0
                                               green:0.0
                                                blue:0.0
                                               alpha:1.0]];
    [self.view addSubview:bgView];
    
    //创建显示图像视图
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-240)/2, kScreenWidth, 240)];
    self.imgView.userInteractionEnabled = YES;
    self.imgView.center = self.view.center;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    [bgView addSubview:self.imgView];
    
    //添加点击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapbgView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;//连续点击次数
    tapGestureRecognizer.numberOfTouchesRequired = 1;//touch数量
    [bgView addGestureRecognizer:tapGestureRecognizer];//把手势加到图片上
    
    //添加捏合手势
    [_imgView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)]];
    
}
//关闭按钮
-(void)removeBigImage
{
    bgView.hidden = YES;
    //    [bgView removeFromSuperview];
}
#pragma mark - 单击手势
- (void)TapbgView:(UITapGestureRecognizer*) recognizer{
    bgView.hidden = YES;
    //    [bgView removeFromSuperview];
}

#pragma mark - 捏合手势
- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    //缩放:设置缩放比例
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

#pragma mark - 设置tableviewcell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 115;
        }
        else if(indexPath.row == 1){
            return self.webview.frame.size.height+10;
        }
        else if (indexPath.row == 2){
            return 80;
        }
        else if (indexPath.row == 3)
        {
            /* 这里是标签栏的高度 */
            //也要做自适应
            return 10+self.tagList.frame.size.height+10;
        }
        else if(indexPath.row == 4){
            return 15+originalsize.height+15;
        }
        else
        {
            return 20;
        }
    }
    else
    {
        if (indexPath.row == 0) {
            return 44;
        }
        /* 设置高度自适应 */
        return 10+15+5+12+10+commentsize.height+10;
    }
    
}

#pragma mark - 设置评论条
- (void)setupWithCommentView{
    self.backcommentview = [[BackCommentView alloc]initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    [self.backcommentview.backback addTarget:self action:@selector(ClickGOBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.backcommentview.backButton addTarget:self action:@selector(ClickGOBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backcommentview.backComment addTarget:self action:@selector(ClickComments:) forControlEvents:UIControlEventTouchUpInside];
    [self.backcommentview.ClickComment addTarget:self action:@selector(ClickComments:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backcommentview.backShare addTarget:self action:@selector(ClickShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.backcommentview.ClickShare addTarget:self action:@selector(ClickShare:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backcommentview.commentview.delegate = self;
    
    [self.view addSubview:self.backcommentview];
}

#pragma mark - 点击收藏或取消收藏
- (void)ClickAdd:(UIButton *)sender{
    //点击之后三秒内不可再次点击
    [sender setEnabled:NO];
    int64_t delayInSeconds = 2.0 * 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender setEnabled:YES];
    });
    
    if (self.loginstate.isLogIn) {
        if ([iscollect intValue] == 0) {
            iscollect = @"1";
            [sender setBackgroundImage:[UIImage imageNamed:@"收藏成功.png"] forState:UIControlStateNormal];
            
            NSString *string = @"http://appapi.juwairen.net/index.php/Collection/addCollect";
            NSDictionary *dic = @{@"userid":self.loginstate.userId,@"module_id":@2,@"item_id":self.sharp_id};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"code"] isEqualToString:@"200"]) {
                    //收藏成功 弹出提示框
                    [self PopSuccessPrompts];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"请求失败");
            }];
        }
        else
        {
            iscollect = @"0";
            [sender setBackgroundImage:[UIImage imageNamed:@"收藏.png"] forState:UIControlStateNormal];
            
            NSMutableArray *sharpID = [NSMutableArray array];
            [sharpID addObject:self.sharp_id];
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer=[AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/index.php/Collection/delCollect"];
            NSDictionary *para = @{@"authenticationStr":self.loginstate.userId,
                                   @"encryptedStr":encryptedStr,
                                   @"delete_ids":sharpID,
                                   @"module_id":@"2",
                                   @"userid":self.loginstate.userId};
            [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString*code=[responseObject objectForKey:@"code"];
                if ([code isEqualToString:@"200"]) {
                    //取消成功 弹出提示框
                    [self PopFailPrompts];
                }
                else {
                    NSLog(@"取消失败");
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"请求失败");
            }];
        }
    }
    else
    {
        //如果没登录，就跳转到登录页面
        LoginTableViewController *loginview = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:loginview animated:YES];
    }
}

#pragma mark - 点击返回
- (void)ClickGOBack:(UIButton *)sender{
//    self.webview.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击评论
- (void)ClickComments:(UIButton *)sender{
    
    //滑动到评论
    
    if (firstClickComment) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
        firstClickComment = NO;
    }
    else
    {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - 点击分享
- (void)ClickShare:(UIButton *)sender{
    NSLog(@"分享");
    //1、创建分享参数
    //  （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:desc
                                     images:@[sharpimg]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.juwairen.net/Sharp/show/sid/%@",self.sharp_id]]
                                      title:title
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"分享成功" preferredStyle:UIAlertControllerStyleAlert];
                           [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                           [self presentViewController:alert animated:YES completion:nil];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"分享失败" preferredStyle:UIAlertControllerStyleAlert];
                           [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                           [self presentViewController:alert animated:YES completion:nil];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 页面出现时加载
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self setupWithCommentView];
    
    if (self.loginstate.isLogIn) {
        //进行身份验证
        [self requestAuthentication];
    }
    [self registerForKeyboardNotifications];
    firstClickComment = YES;
}

#pragma mark - 监听键盘
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden) name:UIKeyboardWillHideNotification object:nil];
}

//当键盘出现时计算键盘的高度大小，用于输入框显示
- (void)keyboardWasShown:(NSNotification *)aNotification{
    NSDictionary *info = [aNotification userInfo];
    //kbSize为键盘尺寸
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘高度
    [self beginMoveUpAnimation:kbSize.height];
    
}

//当键盘隐藏时
- (void)keyboardWillBeHidden{
    [self restoreAnimation];
}

#pragma mark-身份验证
-(void)requestAuthentication
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"http://appapi.juwairen.net/Public/getapivalidate/"];
    NSDictionary *para = @{@"validatestring":self.loginstate.userId};
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code = [responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary*dic = responseObject[@"data"];
            encryptedStr = dic[@"str"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}


#pragma mark - 点击键盘上的发送按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    /* 添加评论 */
    NSString *string = [NSString stringWithFormat:@"%@addSharpComnment",kAPI_Sharp];
    NSDictionary *dic = @{@"id":self.sharp_id,@"userid":self.loginstate.userId,@"sharpcomment":self.backcommentview.commentview.text,@"authenticationStr":self.loginstate.userId,@"encryptedStr":encryptedStr};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"]  isEqualToString:@"200"]) {
            //收藏成功 弹出提示框
            [self PopSuccess];
            //请求评论数据
            [self requestDataWithComments];
            
            //滑动到评论
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
            [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            /* 释放第一响应并清空输入的信息 */
            self.backcommentview.commentview.text = @"";
            [self.backcommentview.commentview resignFirstResponder];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    return YES;
}

#pragma mark - 开始编辑时
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //判断当前是否为登录状态,不是则去登录
    if (!self.loginstate.isLogIn) {
        [self.backcommentview removeFromSuperview];
        LoginTableViewController *loginview = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:loginview animated:YES];
    }
    return YES;
}
#pragma mark - 开始动画
- (void)beginMoveUpAnimation:(CGFloat )height{
    [UIView animateWithDuration:0.1 animations:^{
        self.backcommentview.transform = CGAffineTransformMakeTranslation(0, -height);
        self.tableview.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
}
#pragma mark - 还原动画
- (void)restoreAnimation{
    [UIView animateWithDuration:0.1 animations:^{
        self.backcommentview.transform = CGAffineTransformIdentity;
        self.tableview.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - 弹出成功提示框
- (void)PopSuccess{
    view = [[UIView alloc]init];
    //取消成功
    label = [[UILabel alloc]init];
    NSString *text = @"评论成功";
    label.text = text;
    label.textColor = [UIColor whiteColor];
    UIFont *font = [UIFont systemFontOfSize:16];
    label.font = font;
    CGSize size = CGSizeMake(300, 20000.0f);
    CGSize labsize = [text calculateSize:size font:font];
    label.frame = CGRectMake(15, 15, labsize.width, labsize.height);
    
    view.frame = CGRectMake(0, 0, 15+labsize.width+15, 50);
    view.backgroundColor = [UIColor blackColor];
    view.center = self.view.center;
    
    [view addSubview:label];
    [self.view addSubview:view];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];
}
- (void)PopSuccessPrompts{
    view = [[UIView alloc]init];
    //收藏成功
    label = [[UILabel alloc]init];
    NSString *text = @"收藏成功  |";
    label.text = text;
    label.textColor = [UIColor whiteColor];
    UIFont *font = [UIFont systemFontOfSize:16];
    label.font = font;
    CGSize size = CGSizeMake(300, 20000.0f);
    CGSize labelsize = [text calculateSize:size font:font];
    label.frame = CGRectMake(15, 15, labelsize.width, labelsize.height);
    //查看按钮
    button = [[UIButton alloc]init];
    NSString *btntext = @"  查看";
    [button setTitle:btntext forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:92/255.0 green:168/255.0 blue:229/255.0 alpha:1.0] forState:UIControlStateNormal];
    UIFont *btnfont = [UIFont systemFontOfSize:16];
    button.titleLabel.font = font;
    CGSize buttonsize = [btntext calculateSize:size font:btnfont];
    button.frame = CGRectMake(15+labelsize.width, 15, buttonsize.width, buttonsize.height);
    
    [button addTarget:self action:@selector(ClickSee:) forControlEvents:UIControlEventTouchUpInside];
    
    view.frame = CGRectMake(0, 0, 15+labelsize.width+buttonsize.width+15, 50);
    view.backgroundColor = [UIColor blackColor];
    view.center = self.view.center;
    
    [view addSubview:label];
    [view addSubview:button];
    
    [self.view addSubview:view];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];
}

- (void)PopFailPrompts{
    view = [[UIView alloc]init];
    //取消成功
    label = [[UILabel alloc]init];
    NSString *text = @"已取消收藏";
    label.text = text;
    label.textColor = [UIColor whiteColor];
    UIFont *font = [UIFont systemFontOfSize:16];
    label.font = font;
    CGSize size = CGSizeMake(300, 20000.0f);
    CGSize labsize = [text calculateSize:size font:font];
    label.frame = CGRectMake(15, 15, labsize.width, labsize.height);
    
    view.frame = CGRectMake(0, 0, 15+labsize.width+15, 50);
    view.backgroundColor = [UIColor blackColor];
    view.center = self.view.center;
    
    [view addSubview:label];
    [self.view addSubview:view];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];
}

- (void)scrollTimer{
    [UIView animateWithDuration:1.0f animations:^{
        label.alpha = 0.0f;
        button.alpha = 0.0f;
        view.alpha = 0.0f;
    }completion:^(BOOL finished) {
        [label removeFromSuperview];
        [button removeFromSuperview];
        [view removeFromSuperview];
    }];
}
- (void)ClickSee:(UIButton *)sender{
    //跳转到收藏页
    CollectionViewController *collection = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionView"];
    [self.navigationController pushViewController:collection animated:YES];
}

@end


//  SurveyDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailViewController.h"
#import "StockHeaderView.h"
#import "SurveyDetailSegmentView.h"
#import "SurveyDetailWebViewController.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "HexColors.h"

@interface SurveyDetailViewController ()<SurveyDetailSegmentDelegate, SurveyDetailContenDelegate>

@property (weak, nonatomic) IBOutlet StockHeaderView *stockHeaderView;
@property (nonatomic, strong) SurveyDetailSegmentView *segment;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat contentHeight;
@end

@implementation SurveyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addContentChildController];
    self.segment.selectedIndex = 3;
    [self.segment setLocked:YES withIndex:1];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segment;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"heightForRowAtIndexPath = %lf", self.contentHeight)
    return MAX(self.contentHeight, 100);
}


#pragma mark 
- (void)getDetailWebBaseUrlWithTag:(NSInteger)tag {
    NetworkManager *ma = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSString *code = [self.stockId substringFromIndex:2];
    NSDictionary *para;
    if (US.isLogIn) {
        para = @{@"code": code,
                 @"tag": @(tag),
                 @"userid": US.userId};
    }
    else
    {
        para = @{@"code": code,
                 @"tag": @(tag)};
    }
    
    [ma POST:@"Survey/survey_show_tag" parameters:para completion:^(id data, NSError *error){
        if (!error && data) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *baseUrl = data[@"url"];
                [self loadContentWithBaseUrl:baseUrl witTag:tag];
            } else {
                
            }
            NSLog(@"survey_show_tag with data=%@",data)
            
        } else {
            
        }
    }];
}

- (void)loadContentWithBaseUrl:(NSString *)baseUrl witTag:(NSInteger)tag{
    NSString *code = [self.stockId substringFromIndex:2];
    NSString *urlString = nil;
    if (!US.isLogIn) {
        urlString = [NSString stringWithFormat:@"%@/code/%@/tag/%ld/mode/%@",baseUrl,code,(long)tag,@"0"];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@/code/%@/tag/%ld/userid/%@/mode/%@",baseUrl,code,(long)tag,US.userId,@"0"];
    }
    
    NSLog(@"Content web url= %@",urlString);
    SurveyDetailWebViewController *content = self.childViewControllers[tag];
    [content loadWebWithUrl:urlString];
}

#pragma mark - SurveyDetailContenDelegate
- (void)contentWebView:(WKWebView *)webView withHeight:(CGFloat)height {
    self.contentHeight = height;
    [self.scrollView addSubview:webView];
    
    [self.tableView reloadData];
}

#pragma mark - SurveyDetailSegmentDelegate
- (void)didSelectedSegment:(SurveyDetailSegmentView *)segmentView withIndex:(NSInteger)index {
    SurveyDetailSegmentItem *item = segmentView.segments[index];
    if (item.locked) {
        
    } else {
        [self getDetailWebBaseUrlWithTag:index];
    }
}

#pragma mark - Private 
- (void)addContentChildController {
    for (int i=0; i<7; i++) {
        SurveyDetailWebViewController *content = [[SurveyDetailWebViewController alloc] init];
        content.delegate = self;
        [self addChildViewController:content];
    }
}

- (SurveyDetailSegmentView *)segment {
    if (!_segment) {
        _segment = [[SurveyDetailSegmentView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        _segment.delegate = self;
        
        SurveyDetailSegmentItem *shidi = [[SurveyDetailSegmentItem alloc] initWithTitle:@"实地篇"
                                                                                  image:[UIImage imageNamed:@"btn_shidi_nor"]
                                                                       highlightedImage:[UIImage imageNamed:@"btn_shidi_select"]
                                                                   highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#FF9E05"]];
        SurveyDetailSegmentItem *duihua = [[SurveyDetailSegmentItem alloc] initWithTitle:@"对话录"
                                                                                  image:[UIImage imageNamed:@"btn_duihua_nor"]
                                                                       highlightedImage:[UIImage imageNamed:@"btn_duihua_select"]
                                                                    highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#EA4344"]];
        SurveyDetailSegmentItem *niuxiong = [[SurveyDetailSegmentItem alloc] initWithTitle:@"牛熊说"
                                                                                   image:[UIImage imageNamed:@"btn_niuxiong_nor"]
                                                                        highlightedImage:[UIImage imageNamed:@"btn_niuxiong_select"]
                                                                      highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#00C9EE"]];
        SurveyDetailSegmentItem *redian = [[SurveyDetailSegmentItem alloc] initWithTitle:@"热点篇"
                                                                                   image:[UIImage imageNamed:@"btn_redian_nor"]
                                                                        highlightedImage:[UIImage imageNamed:@"btn_redian_select"]
                                                                    highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#FF875B"]];
        SurveyDetailSegmentItem *chanpin = [[SurveyDetailSegmentItem alloc] initWithTitle:@"产品篇"
                                                                                   image:[UIImage imageNamed:@"btn_chanpin_nor"]
                                                                        highlightedImage:[UIImage imageNamed:@"btn_chanpin_select"]
                                                                     highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#43A6F3"]];
        SurveyDetailSegmentItem *wenda = [[SurveyDetailSegmentItem alloc] initWithTitle:@"问答篇"
                                                                                   image:[UIImage imageNamed:@"btn_wenda_nor"]
                                                                        highlightedImage:[UIImage imageNamed:@"btn_wenda_select"]
                                                                   highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#26D79F"]];
        _segment.segments = @[shidi,duihua,niuxiong,redian,chanpin,wenda];
        
    }
    
    return _segment;
}

//- (UIScrollView *)scrollView {
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-140-60)];
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        self.tableView.tableFooterView = _scrollView;
//        _scrollView.contentSize = CGSizeMake(kScreenWidth*6, kScreenHeight-64-60);
//    }
//    return _scrollView;
//}
@end

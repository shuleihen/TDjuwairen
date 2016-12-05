
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
#import "CocoaLumberjack.h"
#import "SurveyDetailCommentViewController.h"
#import "SurveyDetailStockCommentViewController.h"
#import "StockCommentModel.h"

@interface SurveyDetailViewController ()<SurveyDetailSegmentDelegate, SurveyDetailContenDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet StockHeaderView *stockHeaderView;
@property (nonatomic, strong) SurveyDetailSegmentView *segment;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *contentControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, weak) UIViewController *pageWillToController;
@end

@implementation SurveyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.segment.selectedIndex = 1;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segment;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MAX(self.contentHeight, kScreenHeight-64-140-60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContentCellID"];
        [cell.contentView addSubview:self.pageViewController.view];
    }
    
    return cell;
}


#pragma mark - SurveyDetailSegmentDelegate
- (void)didSelectedSegment:(SurveyDetailSegmentView *)segmentView withIndex:(NSInteger)index {
    DDLogInfo(@"Survey detail content selected tag = %ld",index);
    
    SurveyDetailSegmentItem *item = segmentView.segments[index];
    if (item.locked) {
        
    } else {
        [self changePageControllerWithIndex:index];
    }
}

#pragma mark - ChangePageController
- (void)changePageControllerWithIndex:(NSInteger)tag {
    SurveyDetailContentViewController *vc = self.contentControllers[tag];
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

#pragma mark - SurveyDetailContenDelegate
- (void)contentDetailController:(UIViewController *)controller withHeight:(CGFloat)height {
    self.contentHeight = height;//MAX(height, self.contentHeight);
    [self.tableView reloadData];
}


#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    NSInteger before = (index - 1)%[self.contentControllers count];
//    NSLog(@"current index=%ld,will to Before=%ld",index,before);
    SurveyDetailSegmentItem *item = self.segment.segments[index];
    if (item.locked) {
        return nil;
    } else {
        return self.contentControllers[before];
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    NSInteger after = (index + 1)%[self.contentControllers count];
//    NSLog(@"current index=%ld,will to After=%ld",index,after);
    SurveyDetailSegmentItem *item = self.segment.segments[index];
    if (item.locked) {
        return nil;
    } else {
        return self.contentControllers[after];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    UIViewController *vc = [pendingViewControllers firstObject];
    self.pageWillToController = vc;
//    NSInteger index = [self.contentControllers indexOfObject:vc];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    if (!finished) {
        return;
    }
    
    if (self.pageWillToController) {
        NSInteger index = [self.contentControllers indexOfObject:self.pageWillToController];
        [self.segment changedSelectedIndex:index executeDelegate:NO];
    }
    
}

#pragma mark - Private
- (NSArray *)stockCommentsFromArray:(NSArray *)array {
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSDictionary *dict in array) {
        StockCommentModel *content = [StockCommentModel getInstanceWithDictionary:dict];
        [comments addObject:content];
    }
    return comments;
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

- (NSMutableArray *)contentControllers {
    if (!_contentControllers) {
        _contentControllers = [NSMutableArray arrayWithCapacity:7];
        for (int i=0; i<6; i++) {
            if (i == 2) {
                SurveyDetailStockCommentViewController *niuxiongvc = [[SurveyDetailStockCommentViewController alloc] init];
                niuxiongvc.stockId = self.stockId;
                niuxiongvc.tag = i;
                niuxiongvc.delegate = self;
                [_contentControllers addObject:niuxiongvc];
            } else if (i == 5) {
                SurveyDetailCommentViewController *askvc = [[SurveyDetailCommentViewController alloc] init];
                askvc.stockId = self.stockId;
                askvc.tag = i;
                askvc.delegate = self;
                [_contentControllers addObject:askvc];
            } else {
                SurveyDetailWebViewController *content = [[SurveyDetailWebViewController alloc] init];
                content.stockId = self.stockId;
                content.tag = i;
                content.delegate = self;
                [_contentControllers addObject:content];
            }
        }
    }
    
    return _contentControllers;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                           forKey: UIPageViewControllerOptionSpineLocationKey];
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;

    }
    return _pageViewController;
}
@end

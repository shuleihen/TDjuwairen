//
//  PlayIndividualStockViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayIndividualStockViewController.h"
#import "UIViewController+Login.h"
#import "LoginState.h"
#import "MyWalletViewController.h"
#import "MyGuessViewController.h"
#import "TDWebViewController.h"
#import "PushMessageViewController.h"
#import "HMSegmentedControl.h"
#import "PlayIndividualStockContentViewController.h"

@interface PlayIndividualStockViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) NSArray *contentControllers;
@property (strong, nonatomic) UIScrollView *pageScrollView;
@property (assign, nonatomic) NSInteger pageIndex;

@end

@implementation PlayIndividualStockViewController

- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] init];
        _segmentControl.backgroundColor = [UIColor clearColor];
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.titleTextAttributes =@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                               NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#666666"]};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                                        NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#FD9E0A"]};
        _segmentControl.selectionIndicatorHeight = 3.0f;
        _segmentControl.selectionIndicatorColor = [UIColor hx_colorWithHexRGBAString:@"#FD9E0A"];
        _segmentControl.sectionTitles = @[@"最新",@"最热"];
        self.segmentControl.frame = CGRectMake(0, 0, 100, 45);
        [_segmentControl addTarget:self action:@selector(segmentPressed:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segmentControl;
}


- (NSArray *)contentControllers {
    if (!_contentControllers) {
        PlayIndividualStockContentViewController *one = [[PlayIndividualStockContentViewController alloc] init];
        one.view.frame = CGRectMake(0, 0, kScreenWidth, 300);
        one.view.backgroundColor = [UIColor redColor];
        
        PlayIndividualStockContentViewController *two = [[PlayIndividualStockContentViewController alloc] init];
        two.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, 700);
        two.view.backgroundColor = [UIColor yellowColor];
        _contentControllers = @[one,two];
    }
    
    return _contentControllers;
}

- (UIScrollView *)pageScrollView {
    
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _pageScrollView.contentSize = CGSizeMake(kScreenWidth*2, 0);
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.backgroundColor = [UIColor clearColor];
        _pageScrollView.bounces = NO;
        _pageScrollView.backgroundColor = [UIColor blueColor];
        for (PlayIndividualStockContentViewController *vc in self.contentControllers) {
            
            [_pageScrollView addSubview:vc.view];
        }
        
        _pageScrollView.delegate = self;
        
    }
    return _pageScrollView;
}


- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
    PlayIndividualStockContentViewController *vc = self.contentControllers[self.pageIndex];
    self.pageScrollView.frame = CGRectMake(0, 0, kScreenWidth, vc.viewHeight);
    [self.pageScrollView setContentOffset:CGPointMake(kScreenWidth*self.pageIndex, 0) animated:YES];
    [self.segmentControl setSelectedSegmentIndex:self.pageIndex];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 0;
    
}

#pragma mark - Action
- (IBAction)walletPressed:(id)sender {
    if (!US.isLogIn) {
        [self pushLoginViewController];
    } else {
        MyWalletViewController *myWallet = [[MyWalletViewController alloc] init];
        [self.navigationController pushViewController:myWallet animated:YES];
    }
}

- (IBAction)myGuessPressed:(id)sender {
    if (!US.isLogIn) {
        [self pushLoginViewController];
    } else {
        MyGuessViewController *vc = [[MyGuessViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)rulePressed:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://appapi.juwairen.net/Page/index/p/jingcaiguize"];
    TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messagePressed:(id)sender {
    if (US.isLogIn==NO) {
        [self pushLoginViewController];
    } else {
        PushMessageViewController *messagePush = [[PushMessageViewController alloc]init];
        messagePush.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messagePush animated:YES];
    }
}

- (void)commentPressed:(id)sender {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayStockCommentViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)segmentPressed:(HMSegmentedControl *)sender {
    self.pageIndex = sender.selectedSegmentIndex;
}


#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    }
    
    [cell.contentView addSubview:self.pageScrollView];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *hv = [[UIView alloc] init];
    hv.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#191A1F"];
    
    [hv addSubview:self.segmentControl];
    return hv;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.pageScrollView.frame.size.height;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
}


#pragma mark - UISCroolView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView != self.pageScrollView) {
        return;
    }
    
    if(!decelerate)
    {   //OK,真正停止了，do something}
        [self scrollViewDidEndDecelerating:scrollView];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self.pageScrollView) {
        return;
    }
    
    int currentPage = self.pageScrollView.contentOffset.x/kScreenWidth;
    
    if (currentPage == self.pageIndex) {
        return;
    }else {
        self.pageIndex = currentPage;
    }
}



@end

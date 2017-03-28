//
//  PlayIndividualStockContentViewController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayIndividualStockContentViewController.h"
#import "PlayIndividualContentCell.h"
//#import "GuessAddPourViewController.h"
#import "STPopupController.h"
#import "PlayIndividualStockViewController.h"
#import "PlayGuessViewController.h"
#import "GuessAddPourViewController.h"
#import "UIViewController+STPopup.h"

@interface PlayIndividualStockContentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end
static NSString *KPlayIndividualContentCell = @"PlayIndividualContentCell";

@implementation PlayIndividualStockContentViewController

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
//        UINib *nib = [UINib nibWithNibName:KPlayIndividualContentCell bundle:nil];
//        [_tableView registerNib:nib forCellReuseIdentifier:KPlayIndividualContentCell];
        [_tableView registerClass:[PlayIndividualContentCell class] forCellReuseIdentifier:KPlayIndividualContentCell];
        
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (CGFloat)viewHeight {

    return self.tableView.contentSize.height;
}


#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PlayIndividualContentCell *cell = [PlayIndividualContentCell loadCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.guessBlock = ^(UIButton *btn){
//        GuessAddPourViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"GuessAddPourViewController"];
        PlayGuessViewController *vc = [[PlayGuessViewController alloc] init];
        vc.view.frame = CGRectMake(0, 0, kScreenWidth, 275);
//        vc.userKeyNum = self.keyNum;
//        vc.nowPri = stock.nowPriValue;
//        vc.guessId = guess.guessId;
//        vc.delegate = self;

        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth, 275);
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:_superVC];
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 141;
}
#pragma mark -



#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//[tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

#pragma mark -


@end

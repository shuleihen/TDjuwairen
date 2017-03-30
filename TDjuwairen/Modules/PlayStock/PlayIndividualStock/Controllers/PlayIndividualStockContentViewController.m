//
//  PlayIndividualStockContentViewController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayIndividualStockContentViewController.h"
#import "PlayIndividualContentCell.h"
#import "STPopupController.h"
#import "PlayIndividualStockViewController.h"
#import "PlayGuessViewController.h"
#import "UIViewController+STPopup.h"
#import "PlayEnjoyPeopleViewController.h"
#import "GuessAddPourViewController.h"
#import "PlayListModel.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "PlayGuessIndividua.h"

@interface PlayIndividualStockContentViewController ()<UITableViewDelegate,UITableViewDataSource,GuessAddPourDelegate>
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
        _tableView.scrollEnabled = NO;
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

- (void)setListArr:(NSArray *)listArr{
    _listArr = listArr;
    [self.tableView reloadData];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PlayListModel *model = _listArr[indexPath.section];
    PlayIndividualContentCell *cell = [PlayIndividualContentCell loadCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
#pragma mark - 参与竞猜
    cell.guessBlock = ^(UIButton *btn){
        
        GuessAddPourViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"GuessAddPourViewController"];
        vc.userKeyNum = [_guessModel.user_keynum integerValue];
        vc.nowPri = 0;
        vc.guessId = [NSString stringWithFormat:@"%@",model.guess_id];
        vc.delegate = self;
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:_superVC];
    };
    
#pragma mark - 参与人数
    cell.enjoyBlock = ^(){
        PlayEnjoyPeopleViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayEnjoyPeopleViewController"];
        //        vc.userKeyNum = self.keyNum;
        //        vc.nowPri = stock.nowPriValue;
        //        vc.guessId = guess.guessId;
        //        vc.delegate = self;
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth-80, 220);
        popupController.style = STPopupTransitionStyleSlideVertical;
        [popupController presentInViewController:_superVC];
        
    };
#pragma mark - 奖励
    cell.moneyBlock = ^(){
        
    };
    
    return cell;
}



#pragma mark - GuessAddPourDelegate
- (void)addWithGuessId:(NSString *)guessId pri:(float)pri keyNum:(NSInteger)keyNum {
    /*
     __weak StockIndexViewController *wself = self;
     for (int i=0;i < [self.guessList count];i++) {
     StockGuessModel *guess = self.guessList[i];
     if ([guess.guessId isEqualToString:guessId]) {
     
     [wself addAnimationWithGuessId:guessId withPri:pri];
     [wself queryGuessStock];
     [wself playAudio];
     }
     
     }
     
     return;
     
     */
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSString *point = [NSString stringWithFormat:@"%.2f",pri];
    
    NSDictionary *dict = @{@"guess_id": guessId, @"keynum": @(keyNum), @"points": point};
    if (US.isLogIn) {
        dict = @{@"user_id": US.userId, @"guess_id": guessId, @"keynum": @(keyNum), @"points": point};
    }
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    view.hidesWhenStopped = YES;
    [view startAnimating];
    
    __weak PlayIndividualStockContentViewController *wself = self;
    [ma POST:API_GuessAddJoin parameters:dict completion:^(id data, NSError *error){
        
        [view stopAnimating];
        
        void (^errorBlock)(NSString *) = ^(NSString *title){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"竞猜失败";
            [hud hide:YES afterDelay:0.5];
        };
        
        if (!error && data) {
            BOOL status = [data[@"status"] boolValue];
            if (status) {
               
            } else {
                errorBlock(@"竞猜失败");
            }
        } else {
            errorBlock(@"竞猜失败");
        }
        
        
    }];
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

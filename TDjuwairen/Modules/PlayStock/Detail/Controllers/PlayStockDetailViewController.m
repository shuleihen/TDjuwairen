//
//  PlayStockDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayStockDetailViewController.h"
#import "PSIndividualDetailModel.h"
#import "NetworkManager.h"
#import "UILabel+StockCode.h"
#import "PSIndividualUserListCell.h"
#import "MBProgressHUD.h"
#import "UIImage+Create.h"
#import "NSString+Util.h"
#import "PlayStockHnadler.h"
#import "StockDetailViewController.h"
#import "STPopupController.h"
#import "AddIndividualViewController.h"
#import "UIView+Toast.h"
#import "ShareHandler.h"
#import "AlivePublishViewController.h"

@interface PlayStockDetailViewController ()
<UITableViewDelegate, UITableViewDataSource,
StockManagerDelegate, PlayGuessViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *winKeyLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rewardImageView;
@property (nonatomic, strong) PSIndividualDetailModel *individualModel;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) NSArray *userList;
@property (nonatomic, strong) StockInfo *stockInfo;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation PlayStockDetailViewController

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self.stockManager stopThread];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"竞猜详情";
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(sharePressed:)];
    [item1 setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15],NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item1;
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70.0f;
    
    self.tableView.tableFooterView.hidden = YES;
    
    UINib *nib = [UINib nibWithNibName:@"PSIndividualUserListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PSIndividualUserListCellID"];
    
    // 开启股票刷新
    self.stockManager = [[StockManager alloc] init];
    self.stockManager.interval = 10;
    self.stockManager.delegate = self;
    
    [self queryGuessInfo];
}

- (void)queryGuessInfo {
    __weak PlayStockDetailViewController *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *parmark = @{@"guess_id": self.guessId};
    
    [ma GET:API_GetGuessDetail parameters:parmark completion:^(id data, NSError *error) {
        if (!error) {
            PSIndividualDetailModel *model = [[PSIndividualDetailModel alloc] initWithDictionary:data];
            [wself reloadViewWithGuessInfo:model];
        }
    }];
}

- (void)reloadViewWithGuessInfo:(PSIndividualDetailModel *)mode {
    self.individualModel = mode;
    
    if (mode.status == kPSGuessFinish && mode.result == kPSWinNoFinish) {
        // 已经结束的未参与的，不显示我的最佳排名
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 160);
    } else {
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 210);
    }
    
    // 查询股票
    NSString *stockId = [mode.stockCode queryStockCode];
    [self.stockManager queryStockId:stockId];
    
    // 股票名称
    self.stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",mode.stockName,mode.stockCode];
    
    // 是否为后台发起的悬赏
    self.rewardImageView.hidden = !mode.isReward;
    
    // 奖池钥匙数量
    NSString *winKey = [NSString stringWithFormat:@"%ld把钥匙",(long)mode.guessKeyNum];
    self.winKeyLabel.text = winKey;
    
    NSString *season = [PlayStockHnadler stringWithSeason:mode.season];
    self.sectionLabel.text = [NSString stringWithFormat:@"竞猜场次：%@%@",mode.date,season];
    self.joinLabel.text = [NSString stringWithFormat:@"参与人数：%ld",(long)mode.joinNum];
    
    // 收盘价格
    if (mode.status == kPSGuessExecuting) {
        self.endPriceLabel.text = @"收盘价：--";
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        [self timerFire:self.timer];
    } else if (mode.status == kPSGuessStop) {
        self.statusLabel.text = [NSString stringWithFormat:@"状   态：%@",[mode statusString]];
        self.endPriceLabel.text = @"收盘价：--";
    } else {
        self.endPriceLabel.text = [NSString stringWithFormat:@"收盘价：%.02f",mode.endPrice.floatValue];
        self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        self.statusLabel.text = [NSString stringWithFormat:@"状   态：%@",[mode statusString]];
    }
    
    // 最佳排名
    if (mode.rate == 0) {
        self.orderLabel.text = @"--";
    } else {
        self.orderLabel.text = [NSString stringWithFormat:@"%ld",(long)mode.rate];
    }
    
    if (mode.status == kPSGuessExecuting) {
        // 竞猜中
        UIImage *normalImage = [UIImage imageWithSize:CGSizeMake(80, 30)
                                       backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#FFAE00"]
                                          borderColor:[UIColor hx_colorWithHexRGBAString:@"#FFAE00"]
                                         cornerRadius:4.0f];
        
        [self.joinBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        self.joinBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightMedium];
        [self.joinBtn setTitle:@"参与竞猜" forState:UIControlStateNormal];
        [self.joinBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3E1000"] forState:UIControlStateNormal];
        self.joinBtn.enabled = YES;
    } else if (mode.status == kPSGuessStop) {
        // 封盘
        self.joinBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.joinBtn setTitle:@"待开奖" forState:UIControlStateNormal];
        [self.joinBtn setTitle:@"待开奖" forState:UIControlStateDisabled];
        [self.joinBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateNormal];
        self.joinBtn.enabled = NO;
    } else {
        // 已结束
        self.joinBtn.enabled = NO;
        
        switch (mode.result) {
            case kPSWinNoFinish: {
                
            }
                break;
            case kPSWinNo: {
                self.joinBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
                [self.joinBtn setTitle:@"未获胜" forState:UIControlStateNormal];
                [self.joinBtn setTitle:@"未获胜" forState:UIControlStateDisabled];
                [self.joinBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateNormal];
            }
                break;
            case kPSWinYes:{
                self.joinBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
                [self.joinBtn setTitle:@"获胜" forState:UIControlStateNormal];
                [self.joinBtn setTitle:@"获胜" forState:UIControlStateDisabled];
                [self.joinBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3371E2"] forState:UIControlStateNormal];
            }
                break;
            case kPSWinEntirely:{
                NSMutableAttributedString *attr;
                if (mode.extra_keyNum != 0) {
                    NSString *string = [NSString stringWithFormat:@"完全猜中\n额外获得%ld把钥匙",(long)mode.extra_keyNum];
                    attr = [[NSMutableAttributedString alloc] initWithString:string];
                    [attr setAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#3371E2"]} range:NSMakeRange(0, 4)];
                    [attr setAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#9F9FA1"]} range:NSMakeRange(4, string.length-4)];
                    
                } else {
                    attr = [[NSMutableAttributedString alloc] initWithString:@"完全猜中" attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#3371E2"]}];
                }

                [self.joinBtn setAttributedTitle:attr forState:UIControlStateNormal];
                [self.joinBtn setAttributedTitle:attr forState:UIControlStateDisabled];
            }
                break;
            default:
                break;
        }
    }

    
    self.userList = mode.joinList;
    self.tableView.tableFooterView.hidden = mode.joinList.count;
    [self.tableView reloadData];
}

- (void)timerFire:(NSTimer *)timer {
    if (self.individualModel) {
        NSString *remaining = [NSString intervalNowDateWithDateInterval:self.individualModel.endTime];
        NSString *string = [NSString stringWithFormat:@"状   态：竞猜中...(%@)", remaining];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#666666"]} range:NSMakeRange(0, 6)];
        [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#3371E2"]} range:NSMakeRange(6, string.length-6)];
        self.statusLabel.attributedText = attr;
    }
}

- (void)sharePressed:(id)sender {
    
    if (!self.individualModel) {
        return;
    }
    
    [ShareHandler shareWithTitle:self.individualModel.shareTitle image:@[self.individualModel.shareImg] url:self.individualModel.shareUrl selectedBlock:^(NSInteger index){
        if (index == 0) {
            // 分享到直播
            NetworkManager *ma = [[NetworkManager alloc] init];
            NSDictionary *parmark = @{@"guess_id": self.guessId};
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"分享中";
            
            [ma POST:API_AddShareGuessToAlive parameters:parmark completion:^(id data, NSError *error) {
                if (!error) {
                    hud.label.text = @"分享成功";
                } else {
                    hud.label.text = @"分享失败";
                }
                [hud hideAnimated:YES afterDelay:0.7];
            }];
        }
    }  shareState:^(BOOL state) {
        if (state) {
        }
    }];

    
    
    
}

- (IBAction)stockPressed:(id)sender {
    StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
    vc.stockCode = self.individualModel.stockCode;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)joinPressed:(id)sender {
    
    [self checkIndividualGuessEndTimeWithBlock:^(NSInteger season, NSInteger endTime){
        AddIndividualViewController *vc = [[AddIndividualViewController alloc] init];
        vc.season = season;
        vc.endtime = endTime;
        vc.isJoin = YES;
        vc.delegate = self;
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
        
        [vc setupDefaultStock:self.stockInfo withStockCode:self.individualModel.stockCode];
    }];
}


#pragma mark - CheckGuessEndTime
- (void)checkIndividualGuessEndTimeWithBlock:(void (^)(NSInteger season, NSInteger endTime))block {
    
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [self.view addSubview:hud];
    
    hud.hidesWhenStopped = YES;
    [hud startAnimating];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_GetGuessIndividualEndtime parameters:@{@"season":@(self.individualModel.season)} completion:^(id data, NSError *error) {
        
        [hud stopAnimating];
        
        if (!error) {
            NSDictionary *dict = data;
            
            if (dict[@"guess_status"]) {
                [self.view makeToast:@"已封盘" duration:0.8 position:CSToastPositionCenter];
            }else {
                NSInteger season = [dict[@"guess_season"] integerValue];
                NSInteger endTime = [dict[@"guess_endtime"] integerValue];
                block(season,endTime);
            }
        }
    }];
}

#pragma mark - PlayGuessViewControllerDelegate
- (void)addGuessWithStockCode:(NSString *)stockCode pri:(float)pri season:(NSInteger)season isJoin:(BOOL)isJoin isForward:(BOOL)isForward
{
    NSDictionary *parmark1 = @{@"stock":SafeValue(stockCode),
                               @"points":@(pri)};
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    view.hidesWhenStopped = YES;
    view.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [self.navigationController.view addSubview:view];
    [view startAnimating];
    
    __weak PlayStockDetailViewController *wself = self;
    
    void (^errorBlock)(NSString *) = ^(NSString *title){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = title;
        [hud hideAnimated:YES afterDelay:0.8];
    };
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_CheckStockAndPointsValid parameters:parmark1 completion:^(id data, NSError *error) {
        if (!error) {
            NSDictionary *parmark = @{@"season":@(season),
                                      @"stock":SafeValue(stockCode),
                                      @"points":@(pri),
                                      @"is_forward":@(isForward),
                                      };
            
            [ma POST:API_AddGuessIndividual parameters:parmark completion:^(id data, NSError *error) {
                [view stopAnimating];
                
                if (error) {
                    errorBlock(error.localizedDescription?:@"竞猜失败");
                } else {
                    errorBlock(@"投注成功，等待开奖");
                    
                    // 刷新页面
                    [wself queryGuessInfo];
                }
            }];
        } else {
            [view stopAnimating];
            errorBlock(error.localizedDescription?:@"竞猜失败");
        }
    }];
    
}

#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    StockInfo *info = stocks.allValues.firstObject;
    if (info) {
        [self.stockPriceLabel setupForGuessDetailStockInfo:info];
    }
    
    self.stockInfo = info;
}

#pragma mark - UITableView Data
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSIndividualUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PSIndividualUserListCellID"];
    
    PSIndividualUserListModel *model = self.userList[indexPath.row];
    [cell setupUserModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

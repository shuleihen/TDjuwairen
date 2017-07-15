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

@interface PlayStockDetailViewController ()
<UITableViewDelegate, UITableViewDataSource, StockManagerDelegate>
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

@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) NSArray *userList;
@end

@implementation PlayStockDetailViewController

- (void)dealloc {
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70.0f;
    
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
    
    // 查询股票
    NSString *stockId = [mode.stockCode queryStockCode];
    [self.stockManager queryStockId:stockId];
    
    self.stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",mode.stockName,mode.stockCode];
    
    self.rewardImageView.hidden = !mode.isReward;
    
    // 获奖钥匙
    NSString *winKey = [NSString stringWithFormat:@"胜者奖励\n%ld把钥匙",(long)mode.guessKeyNum];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 2.0f;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:winKey];
    [attri setAttributes:@{NSParagraphStyleAttributeName: style} range:NSMakeRange(0, winKey.length)];
    [attri setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#F5A91B"]} range:NSMakeRange(0, 4)];
    [attri setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#FF0000"]} range:NSMakeRange(4, winKey.length-4)];
    self.winKeyLabel.attributedText = attri;
    
    NSString *season = [PlayStockHnadler seasonString:mode.season];
    self.sectionLabel.text = [NSString stringWithFormat:@"竞猜场次：%@",season];
    self.joinLabel.text = [NSString stringWithFormat:@"参与人数：%ld",(long)mode.joinNum];
    self.statusLabel.text = [NSString stringWithFormat:@"状 态：%@",[mode statusString]];
    self.orderLabel.text = [NSString stringWithFormat:@"%ld",(long)mode.rate];
    
    if (mode.status == kPSGuessExecuting) {
        self.endPriceLabel.text = @"收盘价：--";
        self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#152F00"];
    } else {
        self.endPriceLabel.text = [NSString stringWithFormat:@"收盘价：%.02f",mode.endPrice.floatValue];
        self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
    }
    
    switch (mode.result) {
        case kPSWinNoFinish: {
            UIImage *normalImage = [UIImage imageWithSize:CGSizeMake(80, 30)
                                           backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#FFAE00"]
                                              borderColor:[UIColor hx_colorWithHexRGBAString:@"#FFAE00"]
                                             cornerRadius:4.0f];
            
            [self.joinBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
            self.joinBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [self.joinBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3E1000"] forState:UIControlStateNormal];
            self.joinBtn.enabled = YES;
        }
            break;
        case kPSWinNo: {
            UIImage *disableImage = [UIImage imageWithSize:CGSizeMake(80, 30)
                                            backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#cccccc"]
                                               borderColor:[UIColor hx_colorWithHexRGBAString:@"#cccccc"]
                                              cornerRadius:4.0f];
            
            [self.joinBtn setBackgroundImage:disableImage forState:UIControlStateNormal];
            self.joinBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [self.joinBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateNormal];
            self.joinBtn.enabled = NO;
        }
            break;
        case kPSWinYes:{
            [self.joinBtn setBackgroundImage:nil forState:UIControlStateNormal];
            self.joinBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [self.joinBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3371E2"] forState:UIControlStateNormal];
            self.joinBtn.enabled = NO;
        }
            break;
        case kPSWinEntirely:{
            [self.joinBtn setBackgroundImage:nil forState:UIControlStateNormal];
            
            self.joinBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [self.joinBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3371E2"] forState:UIControlStateNormal];
            self.joinBtn.enabled = NO;
        }
            break;
        default:
            break;
    }
    
    
    self.userList = mode.joinList;
    [self.tableView reloadData];
}

- (void)sharePressed:(id)sender {
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *parmark = @{@"guess_id": self.guessId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"分享中";
    
    [ma POST:API_AddShareGuessToAlive parameters:parmark completion:^(id data, NSError *error) {
        if (!error) {
            hud.labelText = @"分享成功";
        } else {
            hud.labelText = @"分享失败";
        }
        [hud hide:YES afterDelay:0.7];
    }];
}


#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    StockInfo *info = stocks.allValues.firstObject;
    if (info) {
        [self.stockPriceLabel setupForGuessDetailStockInfo:info];
    }
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
@end

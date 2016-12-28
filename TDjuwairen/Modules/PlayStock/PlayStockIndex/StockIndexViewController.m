//
//  StockIndexViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockIndexViewController.h"
#import "TDWebViewController.h"
#import "StockGuessListCell.h"
#import "HexColors.h"
#import "BVUnderlineButton.h"
#import "StockManager.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "StockGuessModel.h"
#import "STPopup.h"

@interface StockIndexViewController ()<UITableViewDelegate, UITableViewDataSource, StockManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet BVUnderlineButton *keyNumBtn;

@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) NSDictionary *stockDict;

@property (nonatomic, strong) NSMutableArray *guessList;
@end

@implementation StockIndexViewController

- (void)dealloc {
    [self.stockManager stopThread];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 通知
    UIImage *rightImage = [[UIImage imageNamed:@"news_unread"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(messagePressed:)];
    self.navigationItem.rightBarButtonItem = right;
    
    UINib *nib = [UINib nibWithNibName:@"StockGuessListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"StockGuessListCellID"];
    self.tableView.rowHeight = 235.0f;
    
    self.stockManager = [[StockManager alloc] init];
    self.stockManager.delegate = self;
    
    [self queryGuessStock];
}

- (void)queryGuessStock {
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"m":@"Game",@"a":@"indexGuessing"};
    if (US.isLogIn) {
        NSAssert(US.userId, @"用户Id不能为空");
        dict = @{@"m":@"Game",@"a":@"indexGuessing",@"user_id": US.userId};
    }
    
    __weak StockIndexViewController *wself = self;
    [ma GET:API_GuessIndexList parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            NSString *keyNum = [NSString stringWithFormat:@"%@",data[@"user_keynum"]];
            [wself.keyNumBtn setTitle:keyNum forState:UIControlStateNormal];
            [wself.keyNumBtn setTitle:keyNum forState:UIControlStateHighlighted];
            
            NSArray *array = data[@"guessing_list"];
            if ([array count]) {
                NSMutableArray *guessList = [NSMutableArray arrayWithCapacity:[array count]];
                NSMutableArray *stockIds = [NSMutableArray arrayWithCapacity:[array count]];
                
                for (NSDictionary *dict in array) {
                    StockGuessModel *model = [[StockGuessModel alloc] initWithDict:dict];
                    [guessList addObject:model];
                    [stockIds addObject:model.stockId];
                }
                wself.guessList = guessList;
                
                [wself.stockManager addStocks:stockIds];
            }
            
            [wself.tableView reloadData];
        }
    }];
    
}

#pragma mark - Action
- (IBAction)walletPressed:(id)sender {
}

- (IBAction)myGuessPressed:(id)sender {
    
}

- (IBAction)rulePressed:(id)sender {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"PlayStockIndexRule" withExtension:@"html"];
    TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messagePressed:(id)sender {
    
}

- (void)commentPressed:(id)sender {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayStockCommentViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addGuessWithStockId:(NSString *)stockId {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"GuessAddPourViewController"];
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.navigationBarHidden = YES;
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

- (void)reloadWithStocks:(NSDictionary *)stocks {
    self.stockDict = stocks;
    
    
    [self.tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.guessList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#101115"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.bounds;
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn setTitle:@"评论" forState:UIControlStateNormal];
    [btn setTitle:@"评论" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockGuessListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockGuessListCellID"];
    
    StockGuessModel *guessInfo = self.guessList[indexPath.row];
    StockInfo *stockInfo = [self.stockDict objectForKey:guessInfo.stockId];
    
    [cell setupGuessInfo:guessInfo];
    [cell setupStock:stockInfo];
    
    __weak StockIndexViewController *wself = self;
    cell.guessBtnBlock = ^{
        [wself addGuessWithStockId:guessInfo.stockId];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    StockGuessListCell *scell = (StockGuessListCell *)cell;
//    
//    if (indexPath.row == 0) {
//        StockInfo *stockInfo = [self.stockDict objectForKey:@"sh000001"];
//        scell.stockWheel.index = [stockInfo.nowPri floatValue];
//    } else if (indexPath.row == 1) {
//        StockInfo *stockInfo = [self.stockDict objectForKey:@"sz399006"];
//        scell.stockWheel.index = [stockInfo.nowPri floatValue];
//    }
}
@end

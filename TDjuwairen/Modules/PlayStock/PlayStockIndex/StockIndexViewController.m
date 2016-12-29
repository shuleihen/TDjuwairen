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
#import "GuessAddPourViewController.h"
#import "MBProgressHUD.h"

@interface StockIndexViewController ()<UITableViewDelegate, UITableViewDataSource, StockManagerDelegate, GuessAddPourDelegate,CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet BVUnderlineButton *keyNumBtn;
@property (nonatomic, assign) NSInteger commentNum;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) NSDictionary *stockDict;

@property (nonatomic, strong) NSMutableArray *guessList;

@property (nonatomic, strong) UIImageView *animationKey;
@end

@implementation StockIndexViewController

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self.stockManager stopThread];
}

- (UIImageView *)animationKey {
    if (!_animationKey) {
        UIImage *image = [UIImage imageNamed:@"icon_key_small.png"];
        UIImageView *key = [[UIImageView alloc] initWithImage:image];
        key.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        _animationKey = key;
    }
    
    return _animationKey;
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
    
    // 开启股票刷新
    self.stockManager = [[StockManager alloc] init];
    self.stockManager.interval = 10;
    self.stockManager.delegate = self;
    
    // 开始定时刷新页面，计算倒计时
    __weak StockIndexViewController *wself = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:wself selector:@selector(timerFire:) userInfo:nil repeats:YES];
    
    [self queryGuessStock];
}

- (void)queryGuessStock {
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{};
    if (US.isLogIn) {
        dict = @{@"user_id": US.userId};
    }
    
    __weak StockIndexViewController *wself = self;
    [ma GET:API_GuessIndexList parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            NSString *keyNum = [NSString stringWithFormat:@"%@",data[@"user_keynum"]];
            [wself.keyNumBtn setTitle:keyNum forState:UIControlStateNormal];
            [wself.keyNumBtn setTitle:keyNum forState:UIControlStateHighlighted];
            
            wself.commentNum = [data[@"guess_comment_count"] integerValue];
            
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

- (void)timerFire:(id)timer {
    
    for (StockGuessListCell *cell in [self.tableView visibleCells]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        StockGuessModel *guessInfo = self.guessList[indexPath.row];
        
        [cell reloadTimeWithGuess:guessInfo];
    }
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

- (void)addGuessPri:(CGFloat)pri withStockId:(NSString *)stockId {
    for (int i=0;i < [self.guessList count];i++) {
        StockGuessModel *guess = self.guessList[i];
        
        if ([guess.stockId isEqualToString:stockId]) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:guess.buyIndexs];
            [array addObject:@(pri)];
            guess.buyIndexs = array;
            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            
//            [self.tableView beginUpdates];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableView endUpdates];
        }
        
    }
}

- (void)showGuessViewControllerWithStockId:(NSString *)stockId {
    
    StockInfo *stock = [self.stockDict objectForKey:stockId];
    if (stock) {
        GuessAddPourViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"GuessAddPourViewController"];
        vc.nowPri = stock.nowPriValue;
        vc.stockId = stockId;
        vc.delegate = self;
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
    }
    
}

- (void)addGuessAnimationToCell:(StockGuessListCell *)cell withPri:(CGFloat)pri{

    CGPoint point = [cell pointWithPri:pri];
    
    CGPoint start = CGPointMake(kScreenWidth/2, kScreenHeight-30);
    CGPoint end = [cell convertPoint:point toView:[UIApplication sharedApplication].keyWindow];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:start];
    
    CGPoint c1 = CGPointMake(start.x - (end.x - start.x)*0.12, end.y + (end.y - start.y)*-0.39);
    [path addQuadCurveToPoint:end controlPoint:c1];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    anim.path = path.CGPath;
    anim.duration = 0.6;
    anim.delegate = self;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
 
    [self.animationKey.layer addAnimation:anim forKey:@"animGroup"];
    [[UIApplication sharedApplication].keyWindow addSubview:self.animationKey];
}

#pragma mark - CAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.animationKey removeFromSuperview];
    
    [self.tableView reloadData];
}

#pragma mark - GuessAddPourDelegate
- (void)guessAddWithStockId:(NSString *)stockId pri:(float)pri keyNum:(NSInteger)keyNum {
    for (int i=0;i < [self.guessList count];i++) {
        StockGuessModel *guess = self.guessList[i];
        if ([guess.stockId isEqualToString:stockId]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            StockGuessListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            [self addGuessPri:pri withStockId:stockId];
            [self addGuessAnimationToCell:cell withPri:pri];
        }
        
    }
    
    
    return;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"guess_id": stockId, @"keynum": @(keyNum), @"points": @(pri)};
    if (US.isLogIn) {
        dict = @{@"user_id": US.userId, @"guess_id": stockId, @"keynum": @(keyNum), @"points": @(pri)};
    }
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    view.hidesWhenStopped = YES;
    [view startAnimating];
    
    __weak StockIndexViewController *wself = self;
    [ma GET:API_GuessAddJoin parameters:dict completion:^(id data, NSError *error){
        
        [view stopAnimating];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        if (!error && data) {
            BOOL status = data[@"status"];
            if (status) {
                hud.labelText = @"竞猜成功";
                
            } else {
                hud.labelText = @"竞猜失败";
            }
        } else {
            hud.labelText = @"竞猜失败";
        }
        
        [hud hide:YES afterDelay:0.5];
    }];
}

#pragma mark - StockManagerDelegate
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
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
    
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.commentNum > 0) {
        NSString *title = [NSString stringWithFormat:@"评论(%ld)",self.commentNum];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
    } else {
        [btn setTitle:@"评论" forState:UIControlStateNormal];
        [btn setTitle:@"评论" forState:UIControlStateHighlighted];
    }
    
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
        [wself showGuessViewControllerWithStockId:guessInfo.stockId];
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

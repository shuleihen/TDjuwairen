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
#import "MyWalletViewController.h"
#import "LoginViewController.h"
#import "MyGuessViewController.h"
#import "NotificationDef.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayStockCommentViewController.h"
#import "MessageTableViewController.h"
#import "NSString+Util.h"

@interface StockIndexViewController ()<UITableViewDelegate, UITableViewDataSource, StockManagerDelegate, GuessAddPourDelegate,CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet BVUnderlineButton *keyNumBtn;
@property (weak, nonatomic) IBOutlet UILabel *sectionTimeLabel;

@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, assign) NSInteger keyNum;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) NSDictionary *stockDict;

@property (nonatomic, strong) NSMutableArray *guessList;

@property (nonatomic, strong) UIImageView *animationKey;

@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation StockIndexViewController

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self.stockManager stopThread];
    
    [self stopBgAudio];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (AVAudioPlayer *)player {
    if (!_player) {
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"playStockBg" withExtension:@"mp3"];
        
        NSError *error;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl fileTypeHint:@"mp3" error:&error];
        _player.numberOfLoops = INT_MAX;
    }
    return _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(myGuessPressed:)];
    [item1 setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16],NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]} forState:UIControlStateNormal];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"规则" style:UIBarButtonItemStylePlain target:self action:@selector(rulePressed:)];
    [item2 setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16],NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[item2,item1];
    
    UINib *nib = [UINib nibWithNibName:@"StockGuessListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"StockGuessListCellID"];
    self.tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#272B34"];
    self.tableView.rowHeight = 235.0f;
    
    self.sectionTimeLabel.text = @"";
    
    // 开启股票刷新
    self.stockManager = [[StockManager alloc] init];
    self.stockManager.interval = 10;
    self.stockManager.delegate = self;
    
    // 开始定时刷新页面，计算倒计时
    __weak StockIndexViewController *wself = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:wself selector:@selector(timerFire:) userInfo:nil repeats:YES];
    
    [self queryGuessStock];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryGuessStock) name:kLoginStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentChanged:) name:kGuessCommentChanged object:nil];
    
    [self.player prepareToPlay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self playBgAudio];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self pauseBgAudio];
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
            wself.keyNum = [data[@"user_keynum"] integerValue];
            NSString *keyNum = [NSString stringWithFormat:@"%ld",(long)wself.keyNum];
            
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

- (NSString *)sectionString {
    
    /*
     ● 00：00~10：30，显示“上午场 XX:XX:XX”，可竞猜本日上午场
     ● 10：30~14：00，显示“下午场 XX:XX:XX”，可竞猜本日下午场
     ● 14：00~24：00，显示“下个交易日上午场 XX:XX:XX”，可竞猜下个交易日上午场
     */
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:now];
    dateComponents.hour = 10;
    dateComponents.minute = 30;
    dateComponents.second =0;
    dateComponents.nanosecond =0;
    
    NSDate *date1 = [calendar dateFromComponents:dateComponents];
    if ([[now earlierDate:date1] isEqualToDate:now]) {
        return @"上午场";
    }
    
    NSDateComponents *dateComponents2 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:now];
    dateComponents2.hour = 14;
    dateComponents2.minute = 00;
    dateComponents2.second =0;
    dateComponents2.nanosecond =0;
    
    NSDate *date2 = [calendar dateFromComponents:dateComponents2];
    if ([[now earlierDate:date2] isEqualToDate:now]) {
        return @"下午场";
    }
    
    return @"下个交易日上午场";
}

- (void)timerFire:(id)timer {
    
    StockGuessModel *guessInfo = self.guessList.firstObject;
    if (guessInfo) {
        NSDate *now = [NSDate new];
        
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd EE"];
        [dateFormatter setShortWeekdaySymbols:@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"]];
        NSString *time = [dateFormatter stringFromDate:now];
        NSString *section = [self sectionString];
        NSString *remaining = [NSString intervalNowDateWithDateInterval:guessInfo.endTime];
        
        self.sectionTimeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",time,section,remaining];
    }
}

- (void)commentChanged:(id)sender {
    [self queryGuessStock];
}

#pragma mark - Action
- (IBAction)walletPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    } else {
        MyWalletViewController *myWallet = [[MyWalletViewController alloc] init];
        [self.navigationController pushViewController:myWallet animated:YES];
    }
}

- (IBAction)myGuessPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    } else {
        MyGuessViewController *vc = [[MyGuessViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.guessListType = MyGuessIndexListType;
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
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    } else {
        MessageTableViewController *vc = [[MessageTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)commentPressed:(id)sender {
    PlayStockCommentViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayStockCommentViewController"];
    vc.playStockType = kPlayStockIndex;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)playBgAudio {
    
    if (self.player) {
        [self.player play];
    }
}

- (void)stopBgAudio {
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
}

- (void)pauseBgAudio {
    if (self.player) {
        [self.player pause];
    }
}
- (void)playAudio {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:@"playStock" ofType:@"wav"];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    
    SystemSoundID soundID=0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void)showGuessViewControllerWithGuess:(StockGuessModel *)guess {
    
    if (self.keyNum <= 0) {
        __weak StockIndexViewController *wself = self;
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [wself walletPressed:nil];
        }];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"筹码不足哦，是否充值？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [alert addAction:done];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if ([guess.guessPoints count] >= 3) {
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"本场下注次数已满，您可在其他场次继续下注！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:done];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    StockInfo *stock = [self.stockDict objectForKey:guess.stockId];
    if (stock) {
        GuessAddPourViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"GuessAddPourViewController"];
        vc.userKeyNum = self.keyNum;
        vc.nowPri = stock.nowPriValue;
        vc.guessId = guess.guessId;
        vc.delegate = self;
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
    }
    
}

- (void)addGuessPri:(CGFloat)pri withStockId:(NSString *)stockId {
    
    for (StockGuessModel *guess in self.guessList) {
        
        if ([guess.stockId isEqualToString:stockId]) {
            NSString *point = [NSString stringWithFormat:@"%.02f",pri];
            
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:guess.guessPoints];
            [array addObject:point];
            guess.guessPoints = array;
        }
    }
}

- (void)addAnimationToCell:(StockGuessListCell *)cell withPri:(CGFloat)pri{

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

- (void)addAnimationWithGuessId:(NSString *)guessId withPri:(CGFloat)pri{
    for (int i=0;i < [self.guessList count];i++) {
        StockGuessModel *guess = self.guessList[i];
        
        if ([guess.guessId isEqualToString:guessId]) {
            // 添加点数到GuessModel中
            NSString *point = [NSString stringWithFormat:@"%.02f",pri];
            
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:guess.guessPoints];
            [array addObject:point];
            guess.guessPoints = array;
            
            // 添加动画
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            StockGuessListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            if (cell) {
                [self addAnimationToCell:cell withPri:pri];
            }
            
        }
        
    }
}

#pragma mark - CAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.animationKey removeFromSuperview];
    
    [self.tableView reloadData];
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
    
    __weak StockIndexViewController *wself = self;
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
                [wself addAnimationWithGuessId:guessId withPri:pri];
                [wself queryGuessStock];
                [wself playAudio];
            } else {
                errorBlock(@"竞猜失败");
            }
        } else {
            errorBlock(@"竞猜失败");
        }
        
        
    }];
}

#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    self.stockDict = stocks;
    
    for (StockGuessListCell *cell in [self.tableView visibleCells]) {
        cell.isShowImageAnimation = YES;
    }
    
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
    view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#18191F"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.bounds;
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.commentNum > 0) {
        NSString *title = [NSString stringWithFormat:@"评论(%ld)",(long)self.commentNum];
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
        [wself showGuessViewControllerWithGuess:guessInfo];
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

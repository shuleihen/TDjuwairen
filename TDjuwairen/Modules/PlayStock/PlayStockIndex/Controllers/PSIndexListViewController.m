//
//  PSIndexListViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PSIndexListViewController.h"
#import "TDWebViewController.h"
#import "PSIndexListCell.h"
#import "HexColors.h"
#import "BVUnderlineButton.h"
#import "StockManager.h"
#import "NetworkManager.h"
#import "LoginStateManager.h"
#import "PSIndexListModel.h"
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
#import "PlayStockHnadler.h"

@interface PSIndexListViewController ()<UITableViewDelegate, UITableViewDataSource, StockManagerDelegate, GuessAddPourDelegate,CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet BVUnderlineButton *keyNumBtn;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, assign) NSInteger keyNum;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) NSDictionary *stockDict;

@property (nonatomic, strong) NSMutableArray *guessList;

@property (nonatomic, strong) UIImageView *animationKey;

@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation PSIndexListViewController

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
    
    UINib *nib = [UINib nibWithNibName:@"PSIndexListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"StockGuessListCellID"];
    self.tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#272B34"];
    self.tableView.backgroundView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#272B34"];
    self.tableView.rowHeight = 235.0f;
    
    self.sectionLabel.text = @"";
    self.dateLabel.text = @"";
    self.timeLabel.text = @"";
    
    // 开启股票刷新
    self.stockManager = [[StockManager alloc] init];
    self.stockManager.interval = 10;
    self.stockManager.delegate = self;
    
    // 开始定时刷新页面，计算倒计时
    __weak PSIndexListViewController *wself = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:wself selector:@selector(timerFire:) userInfo:nil repeats:YES];
    
    [self queryGuessStock];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentChanged:) name:kGuessCommentChanged object:nil];
    
//    if (self.player) {
//        [self.player prepareToPlay];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self playBgAudio];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self pauseBgAudio];
}


- (void)queryGuessStock {
    __weak PSIndexListViewController *wself = self;

    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [self.navigationController.view addSubview:hud];
    
    hud.hidesWhenStopped = YES;
    [hud startAnimating];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_GuessIndexList parameters:nil completion:^(id data, NSError *error){
        [hud stopAnimating];
        
        if (!error) {
            [wself reloadViewWithData:data];
        }
    }];
    
}

- (void)reloadViewWithData:(NSDictionary *)data {
    self.keyNum = [data[@"user_keynum"] integerValue];
    NSString *keyNum = [NSString stringWithFormat:@"%ld",(long)self.keyNum];
    
    [self.keyNumBtn setTitle:keyNum forState:UIControlStateNormal];
    [self.keyNumBtn setTitle:keyNum forState:UIControlStateHighlighted];
    
    self.commentNum = [data[@"guess_comment_count"] integerValue];
    
    [self.bottomButton setTitle:[NSString stringWithFormat:@"评论(%ld)",(long)self.commentNum] forState:UIControlStateNormal];
    
    NSString *dateString = data[@"guess_date"];
    self.dateLabel.text = dateString;
    
    // 0表示当天，1表示明日，2表示下个交易日
    NSInteger nextDay = [data[@"next_day"] integerValue];
    NSInteger season = [data[@"guess_season"] integerValue];
    self.sectionLabel.text = [NSString stringWithFormat:@"%@%@",[PlayStockHnadler stringWithNextDay:nextDay],[PlayStockHnadler stringWithSeason:season]];
    
    NSArray *array = data[@"guessing_list"];
    if ([array count]) {
        NSMutableArray *guessList = [NSMutableArray arrayWithCapacity:[array count]];
        NSMutableArray *stockIds = [NSMutableArray arrayWithCapacity:[array count]];
        
        for (NSDictionary *dict in array) {
            PSIndexListModel *model = [[PSIndexListModel alloc] initWithDict:dict];
            [guessList addObject:model];
            [stockIds addObject:model.stockId];
        }
        self.guessList = guessList;
        
        [self.stockManager addStocks:stockIds];
    }
    
    [self.tableView reloadData];
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
    PSIndexListModel *guessInfo = self.guessList.firstObject;
    if (guessInfo) {
        NSString *remaining = [NSString intervalNowDateWithDateInterval:guessInfo.endTime];
        
        self.timeLabel.text = remaining;
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

- (IBAction)commentPressed:(id)sender {
    PlayStockCommentViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayStockCommentViewController"];
    vc.playStockType = kPlayStockIndex;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)playBgAudio {
    
    if ([self.player prepareToPlay]) {
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

- (void)showGuessViewControllerWithGuess:(PSIndexListModel *)guess {
    
    if (self.keyNum <= 0) {
        __weak PSIndexListViewController *wself = self;
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
    
    for (PSIndexListModel *guess in self.guessList) {
        
        if ([guess.stockId isEqualToString:stockId]) {
            NSString *point = [NSString stringWithFormat:@"%.02f",pri];
            
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:guess.guessPoints];
            [array addObject:point];
            guess.guessPoints = array;
        }
    }
}

- (void)addAnimationToCell:(PSIndexListCell *)cell withPri:(CGFloat)pri{

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
        PSIndexListModel *guess = self.guessList[i];
        
        if ([guess.guessId isEqualToString:guessId]) {
            // 添加点数到GuessModel中
            NSString *point = [NSString stringWithFormat:@"%.02f",pri];
            
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:guess.guessPoints];
            [array addObject:point];
            guess.guessPoints = array;
            
            // 添加动画
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            PSIndexListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
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
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSString *point = [NSString stringWithFormat:@"%.2f",pri];
    
    NSDictionary *dict = @{@"guess_id": guessId, @"keynum": @(keyNum), @"points": point};
    if (US.isLogIn) {
        dict = @{@"user_id": US.userId, @"guess_id": guessId, @"keynum": @(keyNum), @"points": point};
    }
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    view.hidesWhenStopped = YES;
    [view startAnimating];
    
    __weak PSIndexListViewController *wself = self;
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
    
    for (PSIndexListCell *cell in [self.tableView visibleCells]) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSIndexListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockGuessListCellID"];
    
    PSIndexListModel *guessInfo = self.guessList[indexPath.row];
    StockInfo *stockInfo = [self.stockDict objectForKey:guessInfo.stockId];
    
    [cell setupGuessInfo:guessInfo];
    [cell setupStock:stockInfo];
    
    __weak PSIndexListViewController *wself = self;
    cell.guessBtnBlock = ^{
        [wself showGuessViewControllerWithGuess:guessInfo];
    };
    return cell;
}


@end

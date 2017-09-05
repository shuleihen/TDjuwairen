//
//  VideoDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "VideoTitleTableViewCell.h"
#import "NetworkManager.h"
#import "VideoInfoModel.h"
#import "ZFPlayer.h"
#import "AlivePingLunViewController.h"
#import "VideoDetailBottomToolView.h"
#import "AliveCommentViewController.h"
#import "ShareHandler.h"
#import "AliveListModel.h"
#import "AlivePublishViewController.h"

#define kVideoPlayViewHeight 210
#define kVideoBottomToolHeight 44

@interface VideoDetailViewController ()<UITableViewDelegate, UITableViewDataSource, ZFPlayerDelegate>
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) UIView *videoPlayView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VideoInfoModel *videoinfo;
@property (nonatomic, strong) VideoDetailBottomToolView *bottomToolView;

@end

@implementation VideoDetailViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kVideoPlayViewHeight, kScreenWidth, kScreenHeight-kVideoPlayViewHeight-kVideoBottomToolHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:@"VideoTitleTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"VideoTitleTableViewCellID"];
    }
    
    return _tableView;
}

- (UIView *)videoPlayView {
    if (!_videoPlayView) {
        _videoPlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kVideoPlayViewHeight)];
    }
    
    return _videoPlayView;
}


- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = self.videoinfo.title;
        _playerModel.videoURL         = [NSURL URLWithString:self.videoinfo.videoSrc];
        _playerModel.placeholderImageURLString = self.videoinfo.cover;
        _playerModel.fatherView       = self.videoPlayView;

    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = NO;
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}

- (VideoDetailBottomToolView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[VideoDetailBottomToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kVideoBottomToolHeight, kScreenWidth, kVideoBottomToolHeight)];
        [_bottomToolView.commentBtn addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolView.shareBtn addTarget:self action:@selector(sharePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _bottomToolView;
}

- (id)initWithVideoId:(NSString *)videoId {
    if (self = [super init]) {
        self.videoId = videoId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = TDViewBackgrouondColor;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(15, 35, 30, 24);
    [left setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = left;
    
    [self.videoPlayView addSubview:left];
    
    [self.view addSubview:self.videoPlayView];
    
    [self queryVideoInfo];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Action

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commentPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    AliveCommentViewController *commVC = [AliveCommentViewController new];
    commVC.alive_ID = self.videoId;
    commVC.alive_type = [NSString stringWithFormat:@"%d",(int)kAliveVideo];
    [self.navigationController pushViewController:commVC animated:YES];
}

- (void)sharePressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    AlivePublishModel *publishModel = [[AlivePublishModel alloc] init];
    publishModel.forwardId = self.videoId;
    publishModel.image = self.videoinfo.cover;
    publishModel.title = self.videoinfo.title;
    publishModel.detail = self.videoinfo.content;
    
    NSArray *images;
    if (self.videoinfo.cover.length) {
        images = @[self.videoinfo.cover];
    }
    
    __weak typeof(self)weakSelf = self;
    
    void (^shareBlock)(BOOL state) = ^(BOOL state) {
        if (state) {
            // 转发服务器会将分享数加1
//            [[NSNotificationCenter defaultCenter] postNotificationName:kAddLikeNotification object:nil userInfo:@{@"notiType":@"fenxiang"}];
        }
    };
    
    [ShareHandler shareWithTitle:self.videoinfo.title detail:self.videoinfo.content image:images url:self.videoinfo.shareUrl selectedBlock:^(NSInteger index){
        if (index == 0) {
            // 转发
            AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            vc.publishType = kAlivePublishVideo;
            vc.publishModel = publishModel;
            vc.shareBlock = shareBlock;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }  shareState:^(BOOL state) {
        if (state) {
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary *dict = @{@"item_id":weakSelf.videoId,@"type":@(kAliveVideo)};
            
            [manager POST:API_AliveAddShare parameters:dict completion:^(id data, NSError *error) {
                if (!error) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kAddLikeNotification object:nil userInfo:@{@"notiType":@"fenxiang"}];
                }
            }];
        }
    }];
}

- (void)queryVideoInfo {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, (kScreenHeight-64)/2);
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_VideoGetInfo parameters:@{@"video_id": self.videoId} completion:^(id data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error) {
            VideoInfoModel *model = [[VideoInfoModel alloc] initWithDictionary:data];
            [self reloadViewWithViewModel:model];
        } else {
            
        }
    }];
}

- (void)reloadViewWithViewModel:(VideoInfoModel *)model {
    self.videoinfo = model;
    
    [self.playerView autoPlayTheVideo];
    
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomToolView];
    
    AlivePingLunViewController *vc = [[AlivePingLunViewController alloc] init];
    vc.aliveID = self.videoId;
    vc.aliveType = kAliveVideo;
    [self addChildViewController:vc];
    self.tableView.tableFooterView = vc.view;
    
    [self.tableView reloadData];
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
//        self.backBtn.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.backBtn.alpha = 0;
    }];
}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = fullscreen;
    [UIView animateWithDuration:0.25 animations:^{
        self.backBtn.alpha = !fullscreen;
    }];
}


#pragma mark - UITableViewData
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        VideoTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTitleTableViewCellID"];
        
        [cell setupModel:self.videoinfo];
        return cell;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [VideoTitleTableViewCell cellHeightWithTitle:self.videoinfo.content];
}


@end

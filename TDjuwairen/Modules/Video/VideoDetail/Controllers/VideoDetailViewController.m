//
//  VideoDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "VideoTitleTableViewCell.h"

#define kVideoPlayViewHeight 210

@interface VideoDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) UIView *videoPlayView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation VideoDetailViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kVideoPlayViewHeight, kScreenWidth, kScreenHeight-kVideoPlayViewHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (UIView *)videoPlayView {
    if (!_videoPlayView) {
        _videoPlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kVideoPlayViewHeight)];
    }
    
    return _videoPlayView;
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
    
    [self.view addSubview:self.videoPlayView];
}


#pragma mark - UITableViewData
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        VideoTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTitleTableViewCellID"];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110.0f;
    } else {
        return 120.0f;
    }
}


@end

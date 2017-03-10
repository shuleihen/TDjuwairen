//
//  AliveRoomViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomViewController.h"
#import "NetworkManager.h"
#import "AliveRoomMasterModel.h"

@interface AliveRoomViewController ()
@property (nonatomic, strong) NSString *masterId;
@end

@implementation AliveRoomViewController

- (id)initWithRoomMasterId:(NSString *)masterId {
    if (self = [super init]) {
        self.masterId = masterId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)queryRoomInfoWithMasterId:(NSString *)masterId {
    
    if (!masterId.length) {
        return;
    }
    
    __weak AliveRoomViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"master_id" :masterId};
    
    [manager GET:API_AliveGetRoomInfo parameters:dict completion:^(id data, NSError *error){
    
        if (!error) {
            AliveRoomMasterModel *model = [[AliveRoomMasterModel alloc] initWithDictionary:data];
            [wself setupRoomInfoWithMasterRoomModel:model];
        } else {
            
        }
        
    }];
}

#pragma mark -
- (void)setupRoomInfoWithMasterRoomModel:(AliveRoomMasterModel *)roomModel {
    
}
@end

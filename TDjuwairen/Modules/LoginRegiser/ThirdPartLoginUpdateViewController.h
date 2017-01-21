//
//  ThirdPartLoginUpdateViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kUpdateTypeQQ,
    kUpdateTypeWeXin,
} UpdateType;

@interface ThirdPartLoginUpdateViewController : UITableViewController
@property (nonatomic, strong) NSString *thirdPartId;
@property (nonatomic, strong) NSString *thirdPartName;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, assign) UpdateType type;
@end

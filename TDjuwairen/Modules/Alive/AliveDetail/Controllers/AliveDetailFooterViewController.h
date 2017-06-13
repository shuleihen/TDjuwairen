//
//  AliveDetailFooterViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveTypeDefine.h"

@interface AliveDetailFooterViewController : UIViewController
@property (nonatomic, strong) NSString *masterId;
@property (copy, nonatomic) NSString *aliveID;
@property (nonatomic, assign) AliveType aliveType;
@end

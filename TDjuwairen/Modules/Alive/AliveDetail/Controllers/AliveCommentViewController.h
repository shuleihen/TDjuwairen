//
//  AliveCommentViewController.h
//  TDjuwairen
//
//  Created by deng shu on 2017/3/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AliveCommentViewController : UIViewController

typedef void(^RefreshCommentBlock)();

@property (nonatomic, copy) NSString *alive_ID;
@property (nonatomic, copy) NSString *alive_type;
@property (nonatomic, copy) RefreshCommentBlock commentBlock;

@end

//
//  AskPublishViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kPublishNiu,
    kPublishXiong,
    kPublishAsk,
} PublishType;
@interface AskPublishViewController : UIViewController
@property (nonatomic, strong) NSString *comanyCode;
@property (nonatomic, assign) PublishType type;
@end

//
//  ShareViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController
@property void (^buttonClickBlock)(NSInteger index);
@end

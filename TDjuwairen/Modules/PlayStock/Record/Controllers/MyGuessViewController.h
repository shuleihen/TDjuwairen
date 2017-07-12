//
//  MyGuessViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MyGuessIndexListType        =0, // 指数竞猜
    MyGuessIndividualListType   =1  // 个股竞猜
} MyGuessListType;

@interface MyGuessViewController : UITableViewController
@property (assign, nonatomic) MyGuessListType guessListType;

@end

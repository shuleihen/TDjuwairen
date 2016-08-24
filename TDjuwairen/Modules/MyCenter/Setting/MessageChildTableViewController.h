//
//  MessageChildTableViewController.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageChildDelegate <NSObject>

@end

@interface MessageChildTableViewController : UITableViewController

@property (nonatomic,assign) id<MessageChildDelegate>delegate;

- (void)requestShowList:(int)typeId;
@end

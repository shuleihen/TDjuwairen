//
//  CommentsChildTableViewController.h
//  TDjuwairen
//
//  Created by 团大 on 16/9/19.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentsChildDelegate <NSObject>



@end

@interface CommentsChildTableViewController : UITableViewController

@property (nonatomic,weak) id<CommentsChildDelegate>delegate;

- (void)requestComment:(int)typeID;

@end

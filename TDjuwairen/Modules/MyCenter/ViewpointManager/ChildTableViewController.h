//
//  ChildTableViewController.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChildTableViewControllerDelegate <NSObject>



@end

@interface ChildTableViewController : UITableViewController
@property(nonatomic,weak) id <ChildTableViewControllerDelegate> delegate;

- (void)requestShowList:(int)typeID;

@end

//
//  ChildBlogTableViewController.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildBlogTableViewController : UITableViewController

@property (nonatomic,assign) int page;
@property (nonatomic,copy) NSString *user_id;

- (void)requestShowList:(int)typeID WithID:(NSString *)user_id;

@end
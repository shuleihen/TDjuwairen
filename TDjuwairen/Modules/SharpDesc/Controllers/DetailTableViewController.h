//
//  DetailTableViewController.h
//  TDjuwairen
//
//  Created by 团大 on 16/9/20.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloorView.h"

@protocol ChildTabDelegate <NSObject>

- (void)reply:(FloorView *)sender;
- (void)didSelectCellforPid:(NSString *)pid andNickName:(NSString *)nick;

@end

@interface DetailTableViewController : UITableViewController

- (void)reply:(FloorView *)sender;

@property (nonatomic,assign) NSString *pagemode;

@property (nonatomic,copy) NSString *sharp_id;
@property (nonatomic,copy) NSString *view_id;
@property (nonatomic,weak) id<ChildTabDelegate>delegate;

- (void)requestCommentDataWithPage:(int)currentPage;
- (void)requestWithCommentDataWithTimeHot;
@end

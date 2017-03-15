//
//  AlivePingLunViewController.h
//  TDjuwairen
//
//  Created by deng shu on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^DataArrMCountBlock)(NSInteger dataCount);

@interface AlivePingLunViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *detail_id;

@property (copy, nonatomic) DataArrMCountBlock  dataBlock;
@property (nonatomic, strong) id superVC;
@end

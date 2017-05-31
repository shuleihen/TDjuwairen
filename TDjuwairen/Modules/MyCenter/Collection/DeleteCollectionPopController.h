//
//  DeleteCollectionPopController.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^deletedCollectionPopBlock)();

@interface DeleteCollectionPopController : UIViewController
@property (copy, nonatomic) deletedCollectionPopBlock  deleteBlock;


@end

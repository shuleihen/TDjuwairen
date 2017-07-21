//
//  TDADHandler.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDAdvertModel.h"

@interface TDADHandler : NSObject
+ (void)pushWithAdModel:(TDAdvertModel *)model inNav:(UINavigationController *)nav;
@end

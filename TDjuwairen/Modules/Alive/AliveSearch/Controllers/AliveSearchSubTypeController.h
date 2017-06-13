//
//  AliveSearchSubTypeController.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveTypeDefine.h"

@class SearchSectionData;

@interface AliveSearchSubTypeController : UIViewController
@property (assign, nonatomic) AliveSearchSubType searchType;
@property (strong, nonatomic) SearchSectionData *transmitSearchSectionData;
@property (copy, nonatomic) NSString *searchTextStr;
@property (assign, nonatomic) BOOL needLoadData;
@end

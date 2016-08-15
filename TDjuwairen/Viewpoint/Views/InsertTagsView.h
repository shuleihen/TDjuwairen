//
//  InsertTagsView.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharpTags.h"

@interface InsertTagsView : UIView

@property (nonatomic,strong) UITextField *tagsText;

@property (nonatomic,strong) UIScrollView *tagScroll;
@property (nonatomic,strong) SharpTags *tagList;

@property (nonatomic,strong) NSMutableArray *listArr;

@end

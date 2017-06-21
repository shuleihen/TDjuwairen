//
//  AliveListPostView.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListContentView.h"
#import "AliveListImagesView.h"
#import "AliveListTagsView.h"

@interface AliveListPostView : AliveListContentView<AliveListTagsViewDelegate>
@property (strong, nonatomic) AliveListImagesView *imagesView;
@property (strong, nonatomic) AliveListTagsView *tagsView;
@end

//
//  PaperTagsView.h
//  TDjuwairen
//
//  Created by zdy on 16/10/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaperTagsViewDelegate <NSObject>
- (void)paperTagPressedWithTag:(NSString *)tag;
@end

@interface PaperTagsView : UIView
@property (nonatomic, weak) id<PaperTagsViewDelegate> delegate;
@property (nonatomic, strong) NSArray *tags;
@end

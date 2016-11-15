//
//  NMView.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NMViewDelegate <NSObject>

- (void)selectWithNMViewTableView:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath;

@end

@interface NMView : UIView

@property (nonatomic,assign) id<NMViewDelegate>delegate;

@end

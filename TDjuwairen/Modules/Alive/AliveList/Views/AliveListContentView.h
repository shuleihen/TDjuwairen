//
//  AliveListContentView.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AliveListCellData.h"
#import "TTTAttributedLabel.h"

@interface AliveListContentView : UIView<TTTAttributedLabelDelegate>
@property (nonatomic, strong) AliveListCellData *cellData;

@property (strong, nonatomic) TTTAttributedLabel *messageLabel;

@end

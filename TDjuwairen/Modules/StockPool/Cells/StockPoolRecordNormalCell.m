//
//  StockPoolRecordNormalCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolRecordNormalCell.h"
#import "StockPoolRecordDateView.h"
#import "Masonry.h"

@interface StockPoolRecordNormalCell ()
/// 日期view
@property (strong, nonatomic) StockPoolRecordDateView *dateView;


@end

@implementation StockPoolRecordNormalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.dateView = [[StockPoolRecordDateView alloc] init];
        [self.contentView addSubview:self.dateView];
        [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.mas_equalTo(68.5);
            make.height.equalTo(self);
        }];
    }
    return self;
}


@end

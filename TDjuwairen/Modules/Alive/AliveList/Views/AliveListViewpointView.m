//
//  AliveListViewpointView.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListViewpointView.h"
#import "UIImageView+WebCache.h"

@implementation AliveListViewpointView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _visitLabel = [[UILabel alloc] init];
        _visitLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        _visitLabel.font = [UIFont systemFontOfSize:11.0f];
        _visitLabel.textColor = [UIColor whiteColor];
        _visitLabel.textAlignment = NSTextAlignmentCenter;
        [_imageView addSubview:_visitLabel];
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = TDDetailTextColor;
        _descLabel.font = [UIFont systemFontOfSize:14.0f];
        _descLabel.numberOfLines = 0;
        [self addSubview:_descLabel];
    }
    
    return self;
}

- (void)setCellData:(AliveListCellData *)cellData {
    [super setCellData:cellData];
    
    AliveListViewpointCellData *vpCellData = (AliveListViewpointCellData *)cellData;
    AliveListModel *alive = cellData.aliveModel;
    
    if (vpCellData.isShowImageView) {
        self.imageView.frame = vpCellData.imageViewFrame;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:alive.aliveImgs.firstObject] placeholderImage:nil];
        
        NSString *visit = [NSString stringWithFormat:@"已有%ld人浏览", (long)alive.visitNum];
        CGSize size = [visit boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]} context:nil].size;
        
        self.visitLabel.frame = CGRectMake(vpCellData.imageViewFrame.size.width - size.width-12, vpCellData.imageViewFrame.size.height-27, size.width+12, 27);
        self.visitLabel.text = visit;
        self.visitLabel.hidden = NO;
        self.descLabel.hidden = YES;
    } else {
        self.imageView.frame = vpCellData.imageViewFrame;
        self.descLabel.frame = vpCellData.descLabelFrame;
        self.visitLabel.hidden = YES;
        self.descLabel.hidden = NO;
        
        if ([alive.extra isKindOfClass:[NSDictionary class]]) {
            NSString *desc = alive.extra[@"view_desc"];
            self.descLabel.text = desc;
        }
    }
}
@end

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
        
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage imageNamed:@"button_play.png"];
        _videoImageView.frame = CGRectMake(0, 0, 60, 60);
        _videoImageView.hidden = YES;
        [_imageView addSubview:_videoImageView];
        
        _visitLabel = [[UILabel alloc] init];
        _visitLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        _visitLabel.font = [UIFont systemFontOfSize:11.0f];
        _visitLabel.textColor = [UIColor whiteColor];
        _visitLabel.textAlignment = NSTextAlignmentCenter;
        [_imageView addSubview:_visitLabel];
    }
    
    return self;
}

- (void)setCellData:(AliveListCellData *)cellData {
    [super setCellData:cellData];
    
    AliveListViewpointCellData *vpCellData = (AliveListViewpointCellData *)cellData;
    AliveListModel *alive = cellData.aliveModel;
        
    self.imageView.frame = vpCellData.imageViewFrame;
    self.videoImageView.center = CGPointMake(vpCellData.imageViewFrame.size.width/2, vpCellData.imageViewFrame.size.height/2);
    self.videoImageView.hidden = !(alive.aliveType == kAliveVideo);
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:alive.aliveImgs.firstObject] placeholderImage:nil];
    
    if (alive.aliveType == kAliveViewpoint) {
        NSString *visit = [NSString stringWithFormat:@"已有%ld人浏览", (long)alive.visitNum];
        CGSize size = [visit boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]} context:nil].size;
        
        self.visitLabel.frame = CGRectMake(vpCellData.imageViewFrame.size.width - size.width-12, vpCellData.imageViewFrame.size.height-27, size.width+12, 27);
        self.visitLabel.text = visit;
        self.visitLabel.hidden = NO;
    } else {
        // 转发视频
        self.visitLabel.hidden = YES;
    }
}
@end

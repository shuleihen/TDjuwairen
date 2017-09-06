//
//  AlivePublishImageTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/5.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AlivePublishImageTableViewCell.h"

@implementation AlivePublishImageTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightWithImageCount:(NSInteger)count withLimit:(NSInteger)limit {
    NSInteger n = MIN(limit, count+1);
    
    CGFloat offx = 15,offy= 10,height=0;
    CGFloat itemSize = 80;
    CGFloat margin = 8;
    
    for (int i=0; i<n; i++) {
        CGRect rect = CGRectMake(offx, offy, itemSize, itemSize);
        
        if ((CGRectGetMaxX(rect) + margin + itemSize + 15) <= kScreenWidth) {
            offx = CGRectGetMaxX(rect) + margin;
        } else {
            offx = 15;
            offy += (itemSize+margin);
        }
        
        height = CGRectGetMaxY(rect);
    }
    return height;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __block CGFloat offx = 15,offy= 10,height=0;
    CGFloat itemSize = 80;
    CGFloat margin = 8;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:images];
    [array addObject:[UIImage imageNamed:@"alive_addphoto.png"]];
    
    [array enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop){
        
        CGRect rect = CGRectMake(offx, offy, itemSize, itemSize);
        if (idx >= self.imageLimit) {
            *stop = YES;
            return;
        }
        
        if (idx == (array.count - 1)) {
            UIButton *add = [[UIButton alloc] initWithFrame:rect];
            [add setImage:image forState:UIControlStateNormal];
            [add addTarget:self action:@selector(addPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:add];
//            [self.contentView sendSubviewToBack:add];
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = rect;
            [self.contentView addSubview:imageView];
//            [self.contentView sendSubviewToBack:imageView];
            
            UIButton *cancel = [[UIButton alloc] init];
            [cancel setImage:[UIImage imageNamed:@"btn_del.png"] forState:UIControlStateNormal];
            cancel.frame = CGRectMake(CGRectGetMaxX(rect)-10, CGRectGetMinY(rect)-10, 20, 20);
            cancel.tag = idx;
            [cancel addTarget:self action:@selector(delPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:cancel];
        }
        
        if ((CGRectGetMaxX(rect) + margin + itemSize + 15) <= kScreenWidth) {
            offx = CGRectGetMaxX(rect) + margin;
        } else {
            offx = 15;
            offy += (itemSize+margin);
        }
        
        height = CGRectGetMaxY(rect);
    }];
}

- (void)delPressed:(id)sender {
    if (self.delegate) {
        [self.delegate alivePublishImageCell:self deletePressed:sender];
    }
}

- (void)addPressed:(id)sender {
    if (self.delegate) {
        [self.delegate alivePublishImageCell:self addPressed:sender];
    }
}
@end

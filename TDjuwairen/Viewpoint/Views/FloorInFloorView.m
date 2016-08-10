//
//  FloorInFloorView.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#define framex (n-i-1)*2

#import "FloorInFloorView.h"
#import "NSString+Ext.h"
#import "UIdaynightModel.h"

@implementation FloorInFloorView

- (instancetype)initWithArr:(NSArray *)arr
{
    if (self = [super init]) {
        UIdaynightModel *daynightModel = [UIdaynightModel sharedInstance];
        [daynightModel addObserver:self forKeyPath:@"daynight" options:NSKeyValueObservingOptionNew context:nil];
        self.height = 0;
        int n = 0;
        if (arr.count > 4) {
            n = 4;
        }else
        {
            n = (int)arr.count ;
        }
        for (int i = 0; i<n; i++) {
            NSDictionary *d = arr[i];
            FloorView *view = [[FloorView alloc]init];
            view.layer.borderWidth = 1.0f;
            
            
            NSString *comment = d[@"viewcomment_text"];
            UIFont *font = [UIFont systemFontOfSize:16];
            view.commentLab.font = font;
            view.commentLab.numberOfLines = 0;
            CGSize commentsize = CGSizeMake(view.frame.size.width-30, 20000.0f);
            commentsize = [comment calculateSize:commentsize font:font];
            
            [view setFrame:CGRectMake(framex, framex, kScreenWidth-70-framex*2, 10+15+10+commentsize.height+10+self.height)];
            
            [view.nicknameLab setFrame:CGRectMake(10, 10+self.height, 100, 15)];
            [view.numLab setFrame:CGRectMake(view.frame.size.width-30, 10+self.height, 30, 15)];
            [view.commentLab setFrame:CGRectMake(10, 10+15+10+self.height, kScreenWidth-70-framex*2-20, commentsize.height)];
            
            view.nicknameLab.text = d[@"user_nickname"];
            view.numLab.text = [NSString stringWithFormat:@"%d",i+1];
            view.numLab.textAlignment = NSTextAlignmentCenter;
            view.commentLab.text = comment;
            
            //UIdaynight
            view.layer.borderColor = daynightModel.titleColor.CGColor;
            view.backgroundColor = daynightModel.backColor;
            view.nicknameLab.textColor = daynightModel.titleColor;
            view.numLab.textColor = daynightModel.titleColor;
            view.commentLab.textColor = daynightModel.textColor;
            
            self.height = view.frame.size.height;
            
            if (i == 0) {
                [self addSubview:view];
                self.view = view;
            }else
            {
                [self insertSubview:view belowSubview:self.view];
            }
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"change");
}

@end
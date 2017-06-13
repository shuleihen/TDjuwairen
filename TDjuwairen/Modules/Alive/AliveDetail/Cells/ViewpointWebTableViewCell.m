//
//  ViewpointWebTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ViewpointWebTableViewCell.h"

@implementation ViewpointWebTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.webView.scrollView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadWebWithURLString:(NSString *)string {
    NSURL *url = [NSURL URLWithString:string];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.indicator startAnimating];
}
@end

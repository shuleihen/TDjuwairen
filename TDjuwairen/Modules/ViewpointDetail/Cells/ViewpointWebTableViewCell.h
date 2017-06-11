//
//  ViewpointWebTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewpointWebTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (void)loadWebWithURLString:(NSString *)string;
@end

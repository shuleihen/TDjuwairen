//
//  TDWebViewHandler.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDWebViewHandler : NSObject
+ (void)openURL:(NSString *)aUrl inNav:(UINavigationController *)nav;
+ (void)openURL:(NSString *)aUrl withUserMark:(BOOL)mark inNav:(UINavigationController *)nav;
@end

//
//  ShareHandler.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareHandler : NSObject
+ (void)shareWithTitle:(NSString *)title image:(NSArray *)images url:(NSString *)url;
@end

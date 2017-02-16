//
//  AppContext.h
//  RmbWithdraw
//
//  Created by zdy on 16/8/19.
//  Copyright © 2016年 lianlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kAppContext      [AppContext sharedInstance]

@interface AppContext : NSObject

@property (nonatomic, readonly) NSString *resolution;
@property (nonatomic, assign)   NSInteger networkStatus;

+ (instancetype)sharedInstance;

- (NSString *)machineInfo;
- (NSString *)version;
- (void)addHttpHeaderWithRequest:(NSMutableURLRequest *)request;
@end

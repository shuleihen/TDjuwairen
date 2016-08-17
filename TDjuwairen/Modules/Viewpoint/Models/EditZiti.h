//
//  EditZiti.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditZiti : NSObject

@property (nonatomic,copy) NSString *type;  //字体类型
@property (nonatomic,assign) int zihao;//字号

+ (EditZiti *)sharedInstance;

@end

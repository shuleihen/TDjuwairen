//
//  ShareHandler.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDShareModel.h"

@interface ShareHandler : NSObject

//+ (void)shareWithModel:(TDShareModel *)model selectedBlock:(void(^)(NSInteger index))selectedBlock shareState:(void(^)(BOOL state))stateBlock;

+ (void)shareWithTitle:(NSString *)title
                detail:(NSString *)detail
                 image:(NSString *)image
                   url:(NSString *)url
         selectedBlock:(void(^)(NSInteger index))selectedBlock
            shareState:(void(^)(BOOL state))stateBlock;

+ (void)shareWithTitle:(NSString *)title
                detail:(NSString *)detail
                images:(NSArray *)images
                   url:(NSString *)url
         selectedBlock:(void(^)(NSInteger index))selectedBlock
            shareState:(void(^)(BOOL state))stateBlock;
@end

//
//  NetworkManager.h
//  TDjuwairen
//
//  Created by 团大 on 16/5/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AFNetworking.h"
#import "NetworkDefine.h"
#import "ErrorCodeDefine.h"

@interface NetworkManager : NSObject
- (id)initWithBaseUrl:(NSString *)baseUrl;

- (void)cancel;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                   completion:(void (^)(id data, NSError *error))completion;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                    completion:(void (^)(id data, NSError *error))completion;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                    completion:(void (^)(id data, NSError *error))completion;

@end

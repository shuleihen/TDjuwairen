//
//  NetworkManager.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "NetworkManager.h"
#import "CocoaLumberjack.h"
#import "AppContext.h"
#import "LoginManager.h"

NSString *NetworkErrorDomain    = @"network.error.domain";

@interface NetworkManager()
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation NetworkManager
- (id)init
{
    return [self initWithBaseUrl:API_HOST];
}

- (void)dealloc
{
    [self.manager invalidateSessionCancelingTasks:NO];
}

- (id)initWithBaseUrl:(NSString *)baseUrl
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSURL *baseURL = [NSURL URLWithString:baseUrl];
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    dispatch_queue_t queue = dispatch_queue_create("com.afnetwork.completion", DISPATCH_QUEUE_SERIAL);
    self.manager.completionQueue = queue;
    
    AFJSONResponseSerializer *jsonResponseSerializer = (AFJSONResponseSerializer *)self.manager.responseSerializer;
    jsonResponseSerializer.removesKeysWithNullValues = YES;
    jsonResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"application/x-json", @"text/html", nil];
    
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                completion:(void (^)(id data, NSError *error))completion
{
    return [self GET:URLString parameters:parameters progress:nil completion:completion];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      completion:(void (^)(id data, NSError *error))completion
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"GET"
                                                        URLString:URLString
                                                       parameters:parameters
                                        constructingBodyWithBlock:nil
                                                       completion:completion];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                    completion:(void (^)(id data, NSError *error))completion
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:nil completion:completion];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                    completion:(void (^)(id data, NSError *error))completion
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"POST"
                                                        URLString:URLString
                                                       parameters:parameters
                                        constructingBodyWithBlock:block
                                                       completion:completion];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                      completion:(void (^)(id data, NSError *error))completion
{
    NSAssert(completion, @"completion is can not nil");
    
    NSMutableURLRequest *request = nil;
    if ([method isEqualToString:@"GET"]) {
        request = [self.manager.requestSerializer requestWithMethod:method
                                                          URLString:[[NSURL URLWithString:URLString relativeToURL:self.manager.baseURL] absoluteString]
                                                         parameters:parameters
                                                              error:nil];
    } else {
        request = [self.manager.requestSerializer multipartFormRequestWithMethod:method
                                                                       URLString:[[NSURL URLWithString:URLString relativeToURL:self.manager.baseURL] absoluteString]
                                                                      parameters:parameters
                                                       constructingBodyWithBlock:block
                                                                           error:nil];
    }
    
    // 添加header
    [kAppContext addHttpHeaderWithRequest:request];
    
    DDLogInfo(@"\nRequest * * * * * * * * * * *\nMethod = %@\nURL = %@\nParameters = %@\n* * * * * * * * * * *\n",
              method,request.URL,parameters);
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.manager dataTaskWithRequest:request
                                  uploadProgress:nil
                                downloadProgress:nil
                               completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                   
                                   if (error) {
                                       DDLogInfo(@"\nResponse * * * * * * * * * * *\nURL = %@\nError = %@\n* * * * * * * * * * *\n",response.URL,error);
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completion(nil, error);
                                       });
                                   } else {
                                       DDLogInfo(@"\nResponse * * * * * * * * * * *\nURL = %@\nData = %@\n* * * * * * * * * * *\n",response.URL, responseObject);
                                       NSInteger code = [responseObject[@"code"] integerValue];
                                       if (code == 200) {
                                           id data = responseObject[@"data"];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(data, nil);
                                           });
                                       } else if (code == 401) {
                                           // 多端登录提示
                                           NSString *msg = responseObject[@"msg"];
                                           NSError *error = [[NSError alloc] initWithDomain:NetworkErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:msg}];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(nil, error);
                                               
                                               [LoginManager multiLoginError];
                                           });
                                                                                      
                                       } else {
                                           NSString *msg = responseObject[@"msg"];
                                           NSError *error = [[NSError alloc] initWithDomain:NetworkErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:msg?:@""}];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(nil, error);
                                           });
                                       }
                                   }
                               }];
    
    return dataTask;
}

- (void)cancel {
    [self.manager invalidateSessionCancelingTasks:YES];
}
@end

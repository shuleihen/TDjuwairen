//
//  TencentStockManager.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TencentStockManager.h"
#import "AFHTTPSessionManager.h"
#import "CocoaLumberjack.h"
#import "NSString+Util.h"

@interface TencentStockManager ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation TencentStockManager
- (id)init {
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript", nil];
    }
    return self;
}

- (void)queryStock:(NSString *)stockCode completion:(void (^)(id data, NSError *error))completion {
    if (!stockCode.length) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://qt.gtimg.cn/q=%@",stockCode];
    DDLogInfo(@"Tencent stock URL = %@",url);
    
    [self.manager GET:url parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * dataTask, id data){
                  
                  DDLogInfo(@"Tencent stock query success");
                  
                  [self handleWithStockData:data completion:completion];
              }
              failure:^(NSURLSessionDataTask * dataTask, NSError *error){
                  DDLogInfo(@"Tencent stock query error = %@",error);
                  completion(nil, error);
              }];
}

- (void)handleWithStockData:(id)data completion:(void (^)(id data, NSError *error))completion {
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *resultString = [[NSString alloc] initWithData:data encoding:enc];
    NSArray *infoArray = [resultString componentsSeparatedByString:@"~"];
    
    StockInfo *stock = [[StockInfo alloc] init];

    if ([infoArray count] >= 48) {
        stock.gid = [infoArray[2] queryStockCode];
        stock.name = infoArray[1];
        stock.nowPri = infoArray[3];
        stock.yestodEndPri = infoArray[4];
        stock.todayStartPri = infoArray[5];
        stock.todayMax = infoArray[33];
        stock.todayMin = infoArray[34];
        stock.traNumber = [infoArray[36] floatValue]*100;
        stock.traAmount = [infoArray[37] floatValue]*10000;
        stock.date = infoArray[30];
        stock.time = infoArray[31];
        stock.allValue = infoArray[45];
        stock.currentValue = infoArray[44];
        stock.dynamicRatio = infoArray[39];
    }
    
    completion(stock, nil);
}
@end

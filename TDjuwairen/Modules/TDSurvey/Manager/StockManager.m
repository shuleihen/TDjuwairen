//
//  StockManager.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockManager.h"
#import "AFHTTPSessionManager.h"
#import "CocoaLumberjack.h"

@implementation StockInfo

@end

@interface StockManager ()
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation StockManager
- (id)init {
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = @"com.td.stock";
        
        _interval = 15;
    }
    return self;
}

- (NSTimer *)timer {
    if (!_timer) {
        NSTimeInterval timeInterval = self.interval;
        _timer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        
    }
    return _timer;
}

- (void)timerFire:(NSTimer *)timer {
    if (![self.stockIds count]) {
        return;
    }
    
    [self.queue addOperationWithBlock:^{
        NSString *url = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=%@",[self.stockIds componentsJoinedByString:@","]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript", nil];
        [manager GET:url parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * dataTask, id data){
                 NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                 NSString *stockString = [[NSString alloc] initWithData:data encoding:enc];
                 [self handleWithStockString:stockString];
             }
             failure:^(NSURLSessionDataTask * dataTask, NSError *error){
                 NSLog(@"Stock Error = %@",error);
             }];
    }];
}

- (void)start {
    DDLogInfo(@"Search Stock Queue Start");
    // 将timer添加到runloop中启动
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // 第一次要主动调用
    [self timerFire:_timer];
}

- (void)stop {
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    
    [self.queue cancelAllOperations];
}

- (void)handleWithStockString:(NSString *)stockString {
    NSArray *stockArray = [stockString componentsSeparatedByString:@";"];
    NSMutableArray *stocks = [NSMutableArray arrayWithCapacity:[stockArray count]];
    for (NSString *string in stockArray) {
        NSRange range = [string rangeOfString:@"="];
        if (range.location != NSNotFound) {
            StockInfo *stock = [[StockInfo alloc] init];
            
            NSString *first = [string substringWithRange:NSMakeRange(11, 8)];
            NSString *second = [string substringWithRange:NSMakeRange(range.location + 2, string.length-range.location-3)];
            stock.gid = first;
            NSArray *infoArray = [second componentsSeparatedByString:@","];
            if ([infoArray count] > 32) {
                stock.name = infoArray[0];
                stock.todayStartPri = infoArray[1];
                stock.yestodEndPri = infoArray[2];
                stock.todayMax = infoArray[3];
                stock.todayMin = infoArray[4];
                stock.traNumber = infoArray[8];
                stock.traAmount = infoArray[9];
                stock.date = infoArray[30];
                stock.time = infoArray[31];
                
                [stocks addObject:stock];
            }
            DDLogInfo(@"Stock Gid = %@ Info = %@",first,second);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadWithStocks:)]) {
            [self.delegate reloadWithStocks:stocks];
        }
    });
}
@end

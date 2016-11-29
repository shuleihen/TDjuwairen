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
@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation StockManager
- (id)init {
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = @"com.td.stock";
        
        _interval = 15;
        _stockIds = [NSMutableArray arrayWithCapacity:10];
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

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript", nil];
        _manager.completionQueue = dispatch_queue_create("com.td.stock.completion", NULL);
    }
    return _manager;
}

- (void)timerFire:(NSTimer *)timer {
    if (![self.stockIds count]) {
        return;
    }
    
    [self.queue addOperationWithBlock:^{
        NSString *stockIdStrinig = [self.stockIds componentsJoinedByString:@","];
        NSString *url = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=%@",stockIdStrinig];
        DDLogInfo(@"Stock URL = %@",url);
        [self.manager GET:url parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * dataTask, id data){
                 NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                 NSString *stockString = [[NSString alloc] initWithData:data encoding:enc];
                 [self handleWithStockString:stockString];
                 DDLogInfo(@"Stock successed with %@",stockIdStrinig);
             }
             failure:^(NSURLSessionDataTask * dataTask, NSError *error){
                 DDLogInfo(@"Stock Error = %@",error);
             }];
    }];
}

- (void)addStocks:(NSArray *)stockArray {
    @synchronized (self.stockIds) {
        [self.stockIds addObjectsFromArray:stockArray];
        NSSet *set = [NSSet setWithArray:self.stockIds];
        self.stockIds = [NSMutableArray arrayWithArray:[set allObjects]];
    }
    
    [self.queue cancelAllOperations];
    
    if (!self.isExecuting) {
        [self start];
    } else {
        [self.timer fire];
    }
}

- (void)start {
    if (self.isExecuting) {
        return;
    }
    
    DDLogInfo(@"Stock queue start in %@",[self.delegate class]);
    // 将timer添加到runloop中启动
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // 第一次要主动调用
    [self.timer fire];
    self.isExecuting = YES;
}

- (void)stop {
    if (!self.isExecuting) {
        return;
    }
    
    DDLogInfo(@"Stock queue stop in %@",[self.delegate class]);
    self.isExecuting = NO;
    [self.timer invalidate];
    self.timer = nil;
    [self.queue cancelAllOperations];
}

- (void)handleWithStockString:(NSString *)stockString {
    NSArray *stockArray = [stockString componentsSeparatedByString:@";"];
    NSMutableDictionary *stocks = [NSMutableDictionary dictionaryWithCapacity:[stockArray count]];
    for (NSString *string in stockArray) {
        NSRange range = [string rangeOfString:@"="];
        if (range.location != NSNotFound) {
            StockInfo *stock = [[StockInfo alloc] init];
            
            NSString *first = [string substringWithRange:NSMakeRange(range.location-8, 8)];
            NSString *second = [string substringWithRange:NSMakeRange(range.location + 2, string.length-range.location-3)];
            stock.gid = first;
            NSArray *infoArray = [second componentsSeparatedByString:@","];
            if ([infoArray count] > 32) {
                stock.name = infoArray[0];
                stock.todayStartPri = infoArray[1];
                stock.yestodEndPri = infoArray[2];
                stock.nowPri = infoArray[3];
                stock.todayMax = infoArray[4];
                stock.todayMin = infoArray[5];
                stock.traNumber = infoArray[8];
                stock.traAmount = infoArray[9];
                stock.date = infoArray[30];
                stock.time = infoArray[31];
                
                [stocks setObject:stock forKey:stock.gid];
            }
//            DDLogInfo(@"Stock Gid = %@ Info = %@",first,second);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadWithStocks:)]) {
            [self.delegate reloadWithStocks:stocks];
        }
    });
}
@end

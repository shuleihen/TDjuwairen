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

- (float)nowPriValue {
    NSDecimalNumber *nowPri = [NSDecimalNumber decimalNumberWithString:self.nowPri];
    return [nowPri floatValue];
}

- (float)yestodEndPriValue {
    NSDecimalNumber *nowPri = [NSDecimalNumber decimalNumberWithString:self.yestodEndPri];
    return [nowPri floatValue];
}

- (float)priValue {
    NSDecimalNumber *yestodEndPri = [NSDecimalNumber decimalNumberWithString:self.yestodEndPri];
    NSDecimalNumber *nowPri = [NSDecimalNumber decimalNumberWithString:self.nowPri];
    NSDecimalNumber *value = [nowPri decimalNumberBySubtracting:yestodEndPri];
    return [value floatValue];
}

- (float)priPercentValue {
    NSDecimalNumber *yestodEndPri = [NSDecimalNumber decimalNumberWithString:self.yestodEndPri];
    NSDecimalNumber *nowPri = [NSDecimalNumber decimalNumberWithString:self.nowPri];
    NSDecimalNumber *value = [[nowPri decimalNumberBySubtracting:yestodEndPri] decimalNumberByDividingBy:yestodEndPri];
    return [value floatValue];
}
@end

@interface StockManager () {
    CFRunLoopSourceRef sourceRef;
    CFRunLoopRef currentRunlopRef;
    CFRunLoopTimerRef timer;
}
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, assign) BOOL isCallBack;
@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation StockManager
- (void)dealloc {
//    NSLog(@"StockManager dealloc for delegate = %@",[self.delegate class]);
    
    if (sourceRef) {
        CFRelease(sourceRef);
    }
    
    if (timer) {
        CFRelease(timer);
    }
}

- (id)init {
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = @"com.td.stock";
        
        _isVerifyTime = YES;
        _interval = 15;
        _stockIds = [NSMutableArray arrayWithCapacity:10];
        
        [NSThread detachNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
    }
    return self;
}

- (void)startThread {
    DDLogInfo(@"Create query stock thread for delegate = %@ ",[self.delegate class]);

    CFRunLoopSourceContext source_context;
    CFRunLoopTimerContext timer_context;
    currentRunlopRef = CFRunLoopGetCurrent();
    
    bzero(&source_context, sizeof(source_context));
    source_context.perform = executeSource;
    source_context.info = (__bridge void *)(self);
    sourceRef = CFRunLoopSourceCreate(NULL, 0, &source_context);
    CFRunLoopAddSource(currentRunlopRef, sourceRef, kCFRunLoopCommonModes);
    
    bzero(&timer_context, sizeof(timer_context));
    timer_context.info = (__bridge void *)(self);
    timer = CFRunLoopTimerCreate(NULL, CFAbsoluteTimeGetCurrent(), self.interval, 0, 0,
                                 executeTimer, &timer_context);
    CFRunLoopAddTimer(currentRunlopRef, timer, kCFRunLoopCommonModes);
    
    CFRunLoopRun();
}

void executeTimer(CFRunLoopTimerRef timer, void *info) {
    StockManager *manager = (__bridge StockManager *)info;
    [manager execute];
}

void executeSource(void *info) {
    StockManager *manager = (__bridge StockManager *)info;
    [manager execute];
}

- (void)execute {
    if (![self.stockIds count]) {
        return;
    }
    
    // 发起请求
    [self.queue addOperationWithBlock:^{
        NSString *stockIdStrinig = [self.stockIds componentsJoinedByString:@","];
        NSString *url = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=%@",stockIdStrinig];
        DDLogInfo(@"\nStock URL = %@ for delegate = %@",url,[self.delegate class]);
        
        [self.manager GET:url parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * dataTask, id data){
                         
                         [self handleWithStockData:data];
                     }
                     failure:^(NSURLSessionDataTask * dataTask, NSError *error){
                         DDLogInfo(@"Stock query error = %@",error);
                     }];
    }];
}

- (void)start {
    DDLogInfo(@"Start query stock thread for delegate = %@ ",[self.delegate class]);
    

    [self addTimer];
}

- (void)stop {
    DDLogInfo(@"Stop query stock thread for delegate = %@ ",[self.delegate class]);

    [self removeTimer];
}

- (void)stopThread {
    if (currentRunlopRef) {
        CFRunLoopStop(currentRunlopRef);
    }
}

- (void)addTimer {
    if (currentRunlopRef && (timer == NULL)) {
        CFRunLoopTimerContext timer_context;
        
        bzero(&timer_context, sizeof(timer_context));
        timer_context.info = (__bridge void *)(self);
        timer = CFRunLoopTimerCreate(NULL, CFAbsoluteTimeGetCurrent(), self.interval, 0, 0,
                                     executeTimer, &timer_context);
        CFRunLoopAddTimer(currentRunlopRef, timer, kCFRunLoopCommonModes);
    }
}

- (void)removeTimer {
    DDLogInfo(@"Remove query timer source");
    
    if (timer) {
        CFRunLoopRemoveTimer(currentRunlopRef, timer, kCFRunLoopCommonModes);
        CFRelease(timer);
        timer = NULL;
    }
}

- (void)addStocks:(NSArray *)stockArray {
    [self.stockIds addObjectsFromArray:stockArray];
    NSSet *set = [NSSet setWithArray:self.stockIds];
    self.stockIds = [NSMutableArray arrayWithArray:[set allObjects]];
    
    if (sourceRef) {
        DDLogInfo(@"Add stocks wakeup");
        CFRunLoopSourceSignal(sourceRef);
        CFRunLoopWakeUp(currentRunlopRef);
    }
}


- (void)handleWithStockData:(NSData *)data {

    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *stockString = [[NSString alloc] initWithData:data encoding:enc];
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
            DDLogInfo(@"\nStock Gid = %@ Info = %@\n",first,second);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadWithStocks:)]) {
            [self.delegate reloadWithStocks:stocks];
        }
    });
    
    // 获取成功后判定是否在查询时间内
    if (self.isVerifyTime && ![self isInQueryTime]) {
        [self performSelector:@selector(removeTimer)];
    }
}

- (BOOL)isInQueryTime {
    // 周一到周五 9：00-12  1：00-3：00
    BOOL isInQueryTime = NO;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitHour fromDate:now];
    NSInteger weekday = [dateComponents weekday];
    NSInteger hour = [dateComponents hour];
    
    if ((weekday>=2 && weekday<=6) &&
        ((hour>= 9 && hour<=12) || (hour>= 13 && hour<=15))) {
        isInQueryTime = YES;
    }
    
    return isInQueryTime;
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
@end

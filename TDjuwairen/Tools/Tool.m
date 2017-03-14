//
//  Tool.m
//  PaidAdvertising
//
//  Created by dsw on 16/4/22.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import "Tool.h"
#import "NSObject+ChangeState.h"
@implementation Tool


#pragma mark - 过滤null
NSString *SafeValue(NSString *value) {
//    if ([value isKindOfClass:[NSNumber class]]) {
//        return [NSString stringWithFormat:@"%@",value];
//    }
    if (value) {
        return [value safeString];
    }else {
        return @"";
    }
}

NSString *SafeValueZero(NSString *value){
    if (value) {
        return [value changeToZero];
    }else {
        return @"0";
    }
}
NSString *SafeValueTwoZero(NSString *value){
    if (value) {
        NSString * str = [NSString stringWithFormat:@"%.2f",[[value changeToZero] floatValue]];
        return str;
    }else {
        return @"0.00";
    }
}


#pragma mark --- 判断字符串是否为空

+(BOOL)isStringNull:(NSString *)Str{
    if([Str isKindOfClass:[NSNumber class]])
    {
        Str = [NSString stringWithFormat:@"%@",Str];
    }
    
    if ([SafeValue(Str) isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark -- 判断字符串是否为0

+(BOOL)isStringZero:(NSString *)Str{
    if ([SafeValue(Str) isEqualToString:@"0"]) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -- 获取数字
+(NSString*)getNum:(NSString*)Str{
    NSString *regex=@"[^0-9]";
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:NULL];
    NSString *result = [regular stringByReplacingMatchesInString:Str options:0 range:NSMakeRange(0, [Str length]) withTemplate:@""];
    NSLog(@"%@", result);
    return result;
    
}

#pragma mark --- 判断数字和小数点
+(BOOL)isNumAndPoint:(NSString*)str{
    NSString * numsStr = @"^[1-9][0-9]*$";

//    NSString * numPointStr = @"^\d+(\.\d+)?$";

    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numsStr];
//    NSPredicate *phoneRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numPointStr];
    if ([emailTest evaluateWithObject:str]==YES) {
        return YES;
    }
////    if ([phoneRegex evaluateWithObject:str]==YES) {
//        return YES;
//    }
    return NO;
    
}

#pragma mark --- 是否超过当前日期
/**
 *   是否超过当前日期
 *
 *  @param choseStr 选择的日期
 *
 *  @return
 */

+(BOOL)isMoreThanNowDate:(NSString*)choseStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datenow = [formatter dateFromString:choseStr];
    NSString *timeSp = [NSString stringWithFormat:@"%d", (int)[datenow timeIntervalSince1970]];

    
    
    
    if ([timeSp integerValue]>[[self getDateNow] integerValue]) {
        return YES;
    }else{
        return NO;
    }
}


+(BOOL)isMoreThanNowDateYDM:(NSString*)choseStrYDM;{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datenow = [formatter dateFromString:choseStrYDM];
    NSString *timeSp = [NSString stringWithFormat:@"%d", (int)[datenow timeIntervalSince1970]];
    
    NSDate *now = [formatter dateFromString:[Tool getNowYMD]];
    
    NSString *nowTime = [NSString stringWithFormat:@"%d", (int)[now timeIntervalSince1970]];;
    
    if ([timeSp integerValue]>=[nowTime integerValue]) {
        return YES;
    }else{
        return NO;
    }
 
}

+ (NSString *)getDateNowWithTime:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *timeSp = [NSString stringWithFormat:@"%d", (int)[date timeIntervalSince1970]];
    return timeSp;
}

+ (NSString *)getTimeWithDate:(NSDate *)date andFotmat:(NSString *)dateFormat;
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = dateFormat;
    return [format stringFromDate:date];
}
#pragma mark --- 获取时间戳

+(NSString*)getDateNow{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%d", (int)[datenow timeIntervalSince1970]];

    return timeSp;
}

+(NSString*)getKnowTimeMonth:(NSString *)str
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMM"];
    
    NSDate *  senddate=[dateformatter dateFromString:str];
    
    NSDateFormatter  *dateformatter1=[[NSDateFormatter alloc] init];
    
    [dateformatter1 setDateFormat:@"MM"];
    
    NSString *  locationString=[dateformatter1 stringFromDate:senddate];
    NSLog(@"==== locationString %@",locationString);
    return locationString;
}
#pragma mark --- 获取当前的时间
+(NSString*)getNowTimeYear{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"==== locationString %@",locationString);
    return locationString;
}

#pragma mark --- 获取当前的月份
+(NSString*)getNowTimeMonth{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"MM"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"==== locationString %@",locationString);
    return locationString;
}
#pragma mark --- 获取当前的日期
+(NSString*)getNowTimeDay{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"==== locationString %@",locationString);
    return locationString;
}

+(NSDate *)getDateWith:(NSString *)string;
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    return [format dateFromString:string];
}
#pragma mark -- 获取当前的分钟

+(NSString*)getNowSecond{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"HH:mm"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"==== locationString %@",locationString);
    return locationString;
}

+(NSString*)getNowYM{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMM"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"==== locationString %@",locationString);
    return locationString;
}

+(NSString*)getNowYMD{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"==== locationString %@",locationString);
    return locationString;
}
#pragma mark -- 返回一部分数字
+(NSArray*)getRangeNumArr{
    
    NSMutableArray * arr = [NSMutableArray new];
    for (int i = 1; i < 121; i ++) {
        NSString * str = [NSString stringWithFormat:@"%d",i];
        [arr addObject:str];
    }
    return arr;
}

/**
 *
 *
 *  @param Arr 修改的数组
 *
 *  @return 选择的行
 */
+(NSMutableArray*)getChoseArrSigleArr:(NSMutableArray*)Arr
                          andSeletRow:(NSInteger)row{
    [Arr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue]==1) {
            [Arr replaceObjectAtIndex:idx withObject:@"0"];
        }
    }];
    
    [Arr replaceObjectAtIndex:row withObject:@"1"];
    return Arr;
}

#pragma makr ---- 单选返回的索引

+(NSInteger)getChoseRow:(NSMutableArray*)Arr{
    NSInteger row = 0;
    for (int i = 0; i < Arr.count; i ++) {
        if ([Arr[i] intValue]==1) {
            row = i;
        }
    }
    return row;
}


#pragma mark --- 数字字符串保留2位小数

+(NSString*)getStrTwoZore:(NSString*)str{
    NSString * str1 = SafeValue(str);
    CGFloat num = [str1 floatValue];
    NSString * numStr = [NSString stringWithFormat:@"%.2f",num];
    return numStr;
}

#pragma mark---textfield输入框字数的限制
+(NSInteger)mTextFieldDidChangeLimitLetter:(UITextField *)textField andLimitLength:(NSInteger)mLengh{
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > mLengh)
            {
                textField.text = [toBeString substringToIndex:mLengh];
            }
        }
    }else if([self stringContainsEmoji:textField.text]) {
        NSInteger mlong = textField.text.length;
        textField.text = [toBeString substringToIndex:mlong-2];
//        AlertMsg(@"不能输入表情符号");
        
    }else{// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > mLengh)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:mLengh];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:mLengh];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, mLengh)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    return toBeString.length;
}

+(NSInteger)mtextviewDidChangeLimitLetter:(UITextView *)textview andLimitLength:(NSInteger)mLengh
{

    NSString *toBeString = textview.text;
    NSString *lang = [textview.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textview markedTextRange];
        UITextPosition *position = [textview positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > mLengh)
            {
                textview.text = [toBeString substringToIndex:mLengh];
            }
        }
    }else if([self stringContainsEmoji:textview.text]) {
        NSInteger mlong = textview.text.length;
        textview.text = [toBeString substringToIndex:mlong-2];
//    AlertMsg(@"不能输入表情符号");
        
    }else{// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > mLengh)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:mLengh];
            if (rangeIndex.length == 1)
            {
                textview.text = [toBeString substringToIndex:mLengh];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, mLengh)];
                textview.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    return toBeString.length;


}


+ (BOOL)stringContainsEmoji:(NSString *)string
{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

//





/**
 *
 *
 *  @param NowStr 修改的数组
 *
 *  @str 要替代的字符串
 tagetStr 目标字符串代替
 */

+(NSString*)ReplaceStrOtherStr:(NSString*)NowStr
                 andReplaceStr:(NSString*)str
           andReplaceTargetStr:(NSString*)tagetStr{
    
     NowStr = [NowStr stringByReplacingOccurrencesOfString:str withString:tagetStr];
    return NowStr;
}


#pragma mark 判断有没有汉子
+(BOOL)IsChinese:(NSString *)str{
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    } return NO;
}

#pragma mark --- 转化成UTF8
+(NSString*)ChangeUTF8Str:(NSString*)str{
    NSString * utf8Str = @"";
    utf8Str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return utf8Str;
}

#pragma mark --- 判断手机是否为模拟器
+(BOOL)isIphone_simulator{
    if (TARGET_IPHONE_SIMULATOR) {
        return YES;
    }
    return NO;
}

+ (NSString *)getTimeHM:(NSString *)mmString;
{
    if ([Tool isStringNull:mmString]) {
        return @"";
    }
    NSString *exterTime;
    NSInteger hours = [mmString integerValue]/60;
    NSInteger minuts = [mmString integerValue]%60;
    if (hours == 0) {
        if (minuts<10) {
            exterTime = [NSString stringWithFormat:@"%ld分钟",minuts];
        }
        else
        {
            exterTime = [NSString stringWithFormat:@"%02ld分钟",minuts];
        }
    }
    if (minuts == 0 && hours !=0) {
        if (hours<10) {
            exterTime  = [NSString stringWithFormat:@"%zd小时",hours];
        }
        else
        {
            exterTime  = [NSString stringWithFormat:@"%02zd小时",hours];
        }
    }
    if (minuts != 0 && hours !=0) {
        if (minuts<=9 &&hours<=9) {
            exterTime  = [NSString stringWithFormat:@"%zd小时%zd分钟",hours,minuts];
        }
        if (minuts<=9 &&hours>9) {
            exterTime  = [NSString stringWithFormat:@"%02zd小时%zd分钟",hours,minuts];
        }
        if (minuts>9 && hours <=9) {
            exterTime  = [NSString stringWithFormat:@"%zd小时%02zd分钟",hours,minuts];
        }
        if (minuts>9 && hours >9) {
            exterTime  = [NSString stringWithFormat:@"%02zd小时%02zd分钟",hours,minuts];
        }
    }
    if (hours== 1 && minuts == 0) {
        exterTime  = @"1小时";
    }
    

    return exterTime;

}

+ (void *)getCountdownWithCreatTime:(NSInteger)creatTime WithStateBlock:(void(^)(NSNumber *state,NSString *formatTime))stateBlock;
{
    __block NSString *backString;
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSInteger total = [timeSp integerValue]-creatTime;
    if (total<0) {
        return @"" ;
    }
    
    if (total >24*60*60) {
        NSInteger day = total/(24*60*60);
        NSInteger second = total%(24*60*60);
        NSInteger hour = second/(60*60);
        backString = [NSString stringWithFormat:@"%ld天%ld小时",day,hour];
        stateBlock(@-1,backString);
    }else
    {
        __block int timeout = (int)total;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    stateBlock(@0,backString);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    stateBlock(@1,[self getTimeHMS:timeout]);
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
    return @"";
}

+ (NSString *)getTimeHMS:(int)seconds
{
    NSString *str_hour = [NSString stringWithFormat:@"%02d",seconds/3600];
    
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
    
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
    
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
    
}

+ (NSInteger )getCurrent_DAYWith_YearMonth:(NSString *)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth ;
    
    NSDateFormatter *monthFormat = [[NSDateFormatter alloc] init];
    monthFormat.dateFormat = @"yyyy-MM-dd";

    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[monthFormat dateFromString:month]];
//    NSUInteger dayR = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[monthFormat dateFromString:month]];
   

    NSUInteger numberOfDaysInMonth = range.length;
    
    return numberOfDaysInMonth;
}

// 分钟转换成小时
+(NSString*)getHourPointMin:(NSString*)string{
    NSInteger num = [string integerValue];
    CGFloat hour = (CGFloat)num/60;
    NSString * Hourstr = [NSString stringWithFormat:@"%.2f",hour];
    return Hourstr;
}

#pragma mark --- 判断中英文混合的正则表达式

+(BOOL)doCheckHaveChinaAndEngligh:(NSString*)str{
    NSString *pw = @"^[A-Za-z\u4e00-\u9fa5]*$";
    NSPredicate *pwPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pw];
    BOOL isMatch = [pwPred evaluateWithObject:str];
    return isMatch;
    
}

#pragma mark --- 判断时间
+(BOOL)doCheckOutRangeTime:(NSString*)beginstr
                 andEndStr:(NSString*)endTimeStr{
    NSArray * beginArr = [beginstr componentsSeparatedByString:@"-"];
    NSArray * endArr = [endTimeStr componentsSeparatedByString:@"-"];
    
    NSString * beginyear = beginArr[0];
    NSString * beginmonth = beginArr[1];
    
    NSString * endyear = endArr[0];
    NSString * endmonth = endArr[1];
    
    NSInteger begNum = [beginyear integerValue]*12 + [beginmonth integerValue];
    
    NSInteger endNum = [endyear integerValue]*12 + [endmonth integerValue];
    
    if (endNum<begNum) {
        return YES;
    }else{
        return NO;
    }
    
}
@end

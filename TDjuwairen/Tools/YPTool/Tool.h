//
//  Tool.h
//  PaidAdvertising
//
//  Created by dsw on 16/4/22.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

/**
 *  C方法
 *
 */

NSString *SafeValue(NSString *value);
NSString *SafeValueZero(NSString *value);
NSString *SafeValueTwoZero(NSString *value);

#pragma mark --- 判断字符串是否为空

+(BOOL)isStringNull:(NSString *)Str;

#pragma mark -- 判断字符串是否为0

+(BOOL)isStringZero:(NSString *)Str;

#pragma mark -- 获取数字
+(NSString*)getNum:(NSString*)Str;

#pragma mark --- 判断数字和小数点
+(BOOL)isNumAndPoint:(NSString*)str;

#pragma mark --- 是否超过当前日期
/**
 *   是否超过当前日期
 *
 *  @param choseStr 选择的日期
 *
 *  @return
 */

+(BOOL)isMoreThanNowDate:(NSString*)choseStr;


+(BOOL)isMoreThanNowDateYDM:(NSString*)choseStrYDM;

#pragma mark --- 获取时间戳

+ (NSString *)getDateNowWithTime:(NSDate *)date;
+(NSString*)getDateNow;

/** 获取指定时间指定格式日期 */
+ (NSString *)getTimeWithDate:(NSDate *)date andFotmat:(NSString *)dateFormat;

/** 获取当前年月 */
+ (NSString *)getNowYM;
+ (NSString*)getNowYMD;
#pragma mark --- 获取指定时间的月份
+(NSString*)getKnowTimeMonth:(NSString *)str;

#pragma mark --- 获取当前的时间年
+(NSString*)getNowTimeYear;
#pragma mark --- 获取当前的月份
+(NSString*)getNowTimeMonth;
#pragma mark --- 获取当前的日期
+(NSString*)getNowTimeDay;
#pragma mark -- 获取当前的分钟

+(NSString*)getNowSecond;
+(NSDate *)getDateWith:(NSString *)string;

// 分钟转换成小时
+(NSString*)getHourPointMin:(NSString*)string;

#pragma mark -- 返回一部分数字
+(NSArray*)getRangeNumArr;


#pragma mark --- 单选数组过滤
/**
 *
 *
 *  @param Arr 修改的数组
 *
 *  @return 选择的行
 */
+(NSMutableArray*)getChoseArrSigleArr:(NSMutableArray*)Arr
                          andSeletRow:(NSInteger)row;

#pragma makr ---- 单选返回的索引

+(NSInteger)getChoseRow:(NSMutableArray*)Arr;


#pragma mark --- 数字字符串保留2位小数

+(NSString*)getStrTwoZore:(NSString*)str;

#pragma mark---textfield输入框字数的限制
+(NSInteger)mTextFieldDidChangeLimitLetter:(UITextField *)textField andLimitLength:(NSInteger)mLengh;

+(NSInteger)mtextviewDidChangeLimitLetter:(UITextView *)textview andLimitLength:(NSInteger)mLengh;

+ (BOOL)stringContainsEmoji:(NSString *)string;


#pragma mark -- 位数限制
+(NSString *)JumpInpuyNumAndLength:(UITextField*)textField Length:(int )NumLength;
#pragma mark -- 将字符串中的某一点字符串替换掉
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
           andReplaceTargetStr:(NSString*)tagetStr;
#pragma mark 数字转换成中文
+(NSString *)ChineseWithInteger:(NSInteger)integer;

#pragma mark 判断有没有汉子
+(BOOL)IsChinese:(NSString *)str;

#pragma mark --- 转化成UTF8
+(NSString*)ChangeUTF8Str:(NSString*)str;

#pragma mark --- 判断手机是否为模拟器
+(BOOL)isIphone_simulator;



#pragma mark --- 将分钟转换成HHmm
+ (NSString *)getTimeHM:(NSString *)mmString;
+ (void *)getCountdownWithCreatTime:(NSInteger)creatTime WithStateBlock:(void(^)(NSNumber *state,NSString *formatTime))stateBlock;

/** 返回特定类型日历时间 （DAY） yyy-MM*/
+ (NSInteger )getCurrent_DAYWith_YearMonth:(NSString *)month;

#pragma mark --- 判断中英文混合的正则表达式

+(BOOL)doCheckHaveChinaAndEngligh:(NSString*)str;

#pragma mark --- 判断时间
+(BOOL)doCheckOutRangeTime:(NSString*)beginstr
                 andEndStr:(NSString*)endTimeStr;

+ (void)alertWithTitle:(NSString *)title;
@end

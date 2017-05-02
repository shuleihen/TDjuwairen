//
//  SearchCompanyListModel.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#define CompanyCode @"company_code"
#define CompanyName @"company_name"
#define CompanyShort @"company_short"

#import "SearchCompanyListModel.h"

@implementation SearchCompanyListModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self =  [super init]) {
        self.company_code = dict[@"company_code"];
        self.company_name = dict[@"company_name"];
        self.company_short = dict[@"company_short"];
    }
    return self;
}

/// 本地化
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.company_code forKey:CompanyCode];
    [aCoder encodeObject:self.company_name forKey:CompanyName];
    [aCoder encodeObject:self.company_short forKey:CompanyShort];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.company_code = [aDecoder decodeObjectForKey:CompanyCode];
        self.company_name = [aDecoder decodeObjectForKey:CompanyName];
        self.company_short = [aDecoder decodeObjectForKey:CompanyShort];
        
    }
    
    return self;
}

+ (void)saveLocalHistoryModelArr:(NSArray *)arr {
    
    if (arr.count<=0) {
        return;
    }

    //    获取路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"localSearchStockHistory.plist"];
    NSFileManager *fileM = [NSFileManager defaultManager];
    //    判断文件是否存在，不存在则直接创建，存在则直接取出文件中的内容
    if (![fileM fileExistsAtPath:filePath]) {
        [fileM createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    // 先取 本地保存数据
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (array.count<=0) {
        // 直接存
         [NSKeyedArchiver archiveRootObject:arr toFile:filePath];
        return;
    }
    
    NSMutableArray *tempArrM = [NSMutableArray arrayWithArray:array];
    [tempArrM addObjectsFromArray:arr];
    NSMutableArray *tArrM = [NSMutableArray array];
    
    
    SearchCompanyListModel *firstModel;
    
    for (int i=0; i<tempArrM.count; i++) {
            
        SearchCompanyListModel *model = tempArrM[i];
        if (i>0) {
            if (![firstModel.company_code isEqualToString:model.company_code]) {
                [tArrM addObject:model];
            }
            firstModel = model;
        }else {
            firstModel = tempArrM[0];
            [tArrM addObject:firstModel];
        }
  
    }
    
    tempArrM = [NSMutableArray array];
  
    if (tArrM.count>=2) {
      
        
        [tempArrM addObject:tArrM[tArrM.count-2]];
        [tempArrM addObject:[tArrM lastObject]];
       
    }else if (tArrM.count>=1) {
    [tempArrM addObject:[tArrM lastObject]];
        
    }
    
    
    if (tempArrM.count>0) {
        // 存
        [NSKeyedArchiver archiveRootObject:[tempArrM mutableCopy] toFile:filePath];
    }

}

// 取数据
+ (NSArray *)loadLocalHistoryModel {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"localSearchStockHistory.plist"];
    NSFileManager *fileM = [NSFileManager defaultManager];
    //    判断文件是否存在，不存在则直接创建，存在则直接取出文件中的内容
    if (![fileM fileExistsAtPath:filePath]) {
        return nil;
       
    }else {
        // 先取
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (array.count<=0) {
            return nil;
        }
      
        NSMutableArray *tempArrM = [NSMutableArray array];
        
        if (array.count>=1) {
            [tempArrM addObject:[array lastObject]];
            if (array.count>=2) {
                [tempArrM addObject:array[array.count-2]];
            }
        }
        
        return [tempArrM mutableCopy];
    }
}
+ (void)clearnLocalHistoryStock {

    //    获取路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"localSearchStockHistory.plist"];
    NSFileManager *fileM = [NSFileManager defaultManager];
    //    判断文件是否存在，存在则删除
    if ([fileM fileExistsAtPath:filePath]) {
        [fileM removeItemAtPath:filePath error:nil];
    }
}

@end

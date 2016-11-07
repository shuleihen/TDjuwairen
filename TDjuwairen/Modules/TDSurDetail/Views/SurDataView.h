//
//  SurDataView.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurDataView : UIView

@property (nonatomic,strong) UILabel *nowPri;

@property (nonatomic,strong) UILabel *increase;

@property (nonatomic,strong) UILabel *increPer;

@property (nonatomic,strong) UILabel *yestodEndPri;

@property (nonatomic,strong) UILabel *todayStartPri;

@property (nonatomic,strong) UILabel *todayMax;

@property (nonatomic,strong) UILabel *todayMin;

@property (nonatomic,strong) UILabel *traNumber;

@property (nonatomic,strong) UILabel *traAmount;

- (SurDataView *)initWithFrame:(CGRect)frame WithStockID:(NSString *)StockID;

@end

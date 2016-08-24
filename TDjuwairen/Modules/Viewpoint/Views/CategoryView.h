//
//  CategoryView.h
//  TDjuwairen
//
//  Created by 团大 on 16/7/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^changeBtn)(UIButton *);
@protocol CategoryDeletate <NSObject>

- (void)ClickBtn:(UIButton *)sender;

@end

@interface CategoryView : UIView

@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UILabel *selectLab;
@property (nonatomic,strong) NSMutableArray *btnsArr;

@property (nonatomic,strong) UILabel *line1;
@property (nonatomic,strong) UILabel *line2;
//@property (nonatomic,copy) changeBtn block;
@property (nonatomic,assign) id<CategoryDeletate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)arr;
@end

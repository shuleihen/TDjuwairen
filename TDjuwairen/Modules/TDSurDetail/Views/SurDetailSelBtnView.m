//
//  SurDetailSelBtnView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurDetailSelBtnView.h"
#import "AFNetworking.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "TopBotButton.h"

#import "HexColors.h"

@implementation SurDetailSelBtnView

- (instancetype)initWithFrame:(CGRect)frame WithStockCode:(NSString *)code
{
    if (self = [super initWithFrame:frame]) {
        NSString *stockcode = [code substringFromIndex:2];
        NSDictionary *para ;
        if (US.isLogIn) {
            para = @{@"code":stockcode,
                     @"user_id":US.userId};
        }
        else
        {
            para = @{@"code":stockcode};
        }
        
        [self createBtn];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        NSString *url = [NSString stringWithFormat:@"%@Survey/survey_show_header",kAPI_songsong];
        [manager POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
            nil;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *data = responseObject[@"data"];
            [self setupWithUIWithDic:data];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
    }
    return self;
}

- (void)createBtn{
    self.btnsArr = [NSMutableArray array];
    for (int i = 0; i<6; i++) {
        
        TopBotButton *btn = [[TopBotButton alloc] initWithFrame:CGRectMake(kScreenWidth/6*i, 0, kScreenWidth/6, 60)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [btn addTarget:self action:@selector(selectWithDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnsArr addObject:btn];
        [self addSubview:btn];
    }
}

- (void)setupWithUIWithDic:(NSDictionary *)dic{
    
    NSArray *norArr;
    NSArray *selArr;
    NSString *islock = [NSString stringWithFormat:@"%@",dic[@"isLock"]];
    if ([islock isEqualToString:@"1"]) {   //true 1 表示上锁  false 0 表示解锁
        self.isLocked = YES;
        norArr = @[@"btn_shidi_locked",
                   @"btn_duihua_locked",
                   @"btn_niuxiong_locked",
                   @"btn_redian_nor",
                   @"btn_chanpin_nor",
                   @"btn_wenda_nor"];
        
        selArr = @[@"btn_shidi_locked",
                   @"btn_duihua_locked",
                   @"btn_niuxiong_locked",
                   @"btn_redian_select",
                   @"btn_chanpin_select",
                   @"btn_wenda_select"];
        
    }
    else
    {
        self.isLocked = NO;
        norArr = @[@"btn_shidi_nor",
                   @"btn_duihua_nor",
                   @"btn_niuxiong_nor",
                   @"btn_redian_nor",
                   @"btn_chanpin_nor",
                   @"btn_wenda_nor"];
        
        selArr = @[@"btn_shidi_select",
                   @"btn_duihua_select",
                   @"btn_niuxiong_select",
                   @"btn_redian_select",
                   @"btn_chanpin_select",
                   @"btn_wenda_select"];
    }
    
    NSArray * titleColor = @[@"#FF9E05",@"#EA4344",@"#00C9EE",@"#FF875B",@"#43A6F3",@"#26D79F"];
    
    NSArray *titArr = @[@"实地篇",@"对话录",@"牛熊说",@"热点篇",@"产品篇",@"问答篇"];
    
    for (int i = 0; i < 6; i++) {
        UIButton *btn = self.btnsArr[i];
        [btn setTitle:titArr[i] forState:UIControlStateNormal];
        [btn setTitle:titArr[i] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[HXColor hx_colorWithHexRGBAString:titleColor[i]] forState:UIControlStateSelected];
        
        [btn setImage:[UIImage imageNamed:norArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selArr[i]] forState:UIControlStateSelected];
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.bounds.size.height+8,-btn.imageView.bounds.size.width, 0.0,0.0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, btn.titleLabel.bounds.size.height+8, -btn.titleLabel.bounds.size.width)];
    }
    
}

- (void)selectWithDetail:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(selectWithDetail:)]) {
        [self.delegate selectWithDetail:sender];
    }
}

@end

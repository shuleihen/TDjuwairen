//
//  SurveyDetailContentViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/30.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailContentViewController.h"
#import "LoginState.h"

@interface SurveyDetailContentViewController ()

@end

@implementation SurveyDetailContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)contentHeight {
    return 200;
}

- (NSDictionary *)contentParmWithTag:(NSInteger)tag {
    NSDictionary *para = @{@"code": self.stockId,
                           @"tag": @(tag)};
    return para;
}

- (void)reloadData {
    
}

- (NSString *)contenWebUrlWithBaseUrl:(NSString *)baseUrl witTag:(NSInteger)tag{
    NSString *code = [self.stockId substringFromIndex:2];
    
    NSString *model = @"0";
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        model = @"1";
    } else {
        model = @"0";
    }
    
    NSString *urlString = nil;
    if (!US.isLogIn) {
        urlString = [NSString stringWithFormat:@"%@/code/%@/tag/%ld/mode/%@",baseUrl,code,(long)tag,model];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@/code/%@/tag/%ld/userid/%@/mode/%@",baseUrl,code,(long)tag,US.userId,model];
    }
    return urlString;
}
@end

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
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
}

- (CGFloat)contentHeight {
    return 200;
}

- (NSDictionary *)contentParmWithTag:(NSInteger)tag {
    NSString *code = [self.stockId substringFromIndex:2];
    NSDictionary *para;
    if (US.isLogIn) {
        para = @{@"code": code,
                 @"tag": @(tag),
                 @"userid": US.userId};
    }
    else
    {
        para = @{@"code": code,
                 @"tag": @(tag)};
    }
    return para;
}

- (void)reloadData {
    
}

- (NSString *)contenWebUrlWithBaseUrl:(NSString *)baseUrl witTag:(NSInteger)tag{
    NSString *code = [self.stockId substringFromIndex:2];
    NSString *urlString = nil;
    if (!US.isLogIn) {
        urlString = [NSString stringWithFormat:@"%@/code/%@/tag/%ld/mode/%@",baseUrl,code,(long)tag,@"0"];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@/code/%@/tag/%ld/userid/%@/mode/%@",baseUrl,code,(long)tag,US.userId,@"0"];
    }
    return urlString;
}
@end

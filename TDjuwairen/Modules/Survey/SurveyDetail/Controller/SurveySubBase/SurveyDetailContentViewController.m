//
//  SurveyDetailContentViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/30.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailContentViewController.h"
#import "LoginState.h"
#import "NetworkDefine.h"

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

- (NSDictionary *)contentParm {
    NSDictionary *para = @{@"code": self.stockCode};

    return para;
}

- (void)reloadData {
    
}

+ (NSString *)contenWebUrlWithContentId:(NSString *)contentId withTag:(NSInteger)tag{
    NSString *urlString;
    if (US.isLogIn) {
        urlString = [NSString stringWithFormat:@"%@%@?content_id=%@&survey_tag=%d&user_id=%@",API_HOST,API_SurveyDetailContent,contentId,(int)tag,US.userId];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@%@?content_id=%@&survey_tag=%d",API_HOST,API_SurveyDetailContent,contentId,(int)tag];
    }
    return urlString;
}
@end

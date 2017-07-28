//
//  SurveyDetailContentViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/30.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailContentViewController.h"
#import "LoginStateManager.h"
#import "NetworkDefine.h"

@interface SurveyDetailContentViewController ()
@property (nonatomic, strong) UIView *noDataView;
@end

@implementation SurveyDetailContentViewController

- (UIView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        _noDataView.backgroundColor = [UIColor clearColor];
        
        UIImage *image = [UIImage imageNamed:@"view_nothing.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-image.size.width)/2, 90, image.size.width, image.size.height)];
        imageView.image = image;
        [_noDataView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+16, kScreenWidth, 16)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        label.text = [self noDataTipString];
        [_noDataView addSubview:label];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSString *)noDataTipString {
    NSString *string = @"";
    NSString *className = NSStringFromClass([self class]);
    if ([className isEqualToString:@"SpotViewController"]) {
        string = @"该公司暂无调研，敬请期待..";
    } else if ([className isEqualToString:@"SurveyAnnounceViewController"]) {
        string = @"该公司暂无公告，敬请期待..";
    } else if ([className isEqualToString:@"HotViewController"]) {
        string = @"该公司暂无热点，敬请期待..";
    } else if ([className isEqualToString:@"SurveyDetailAskViewController"]) {
        string = @"该公司暂无问答，敬请期待..";
    }
    return string;
}

- (CGFloat)contentHeight {
    return 200;
}

- (void)reloadData {
    NSAssert(NO, @"股票详情页面列表刷新需要子类实现");
}

- (void)showNoDataView:(BOOL)isShow {
    self.noDataView.hidden = !isShow;
    [self.view bringSubviewToFront:self.noDataView];
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

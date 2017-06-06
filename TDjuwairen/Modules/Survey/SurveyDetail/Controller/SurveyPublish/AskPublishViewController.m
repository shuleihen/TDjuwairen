//
//  AskPublishViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AskPublishViewController.h"
#import "UITextView+Placeholder.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "LoginState.h"
#import "NotificationDef.h"
#import "NSString+Emoji.h"

@interface AskPublishViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AskPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.textView becomeFirstResponder];
    
    switch (self.type) {
        case kPublishNiu:
            self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bull.png"]];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fabu_bull.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(publishPressed:)];
            self.textView.placeholder = @"请在这里输入牛评";
            break;
        case kPublishXiong:
            self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bear.png"]];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fabu_bear.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(publishPressed:)];
            self.textView.placeholder = @"请在这里输入熊评";
            break;
        case kPublishAsk:
            self.title = @"提问";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fabu_ask.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(publishPressed:)];
            self.textView.placeholder = @"请在这里输入问题";
            break;
            
        default:
            break;
    }

    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = textView.text.length;
}

- (void)publishPressed:(id)sender {
    [self.view endEditing:YES];
    
    NSString *content = self.textView.text;
    if (!content.length) {
        return;
    }
    
    
    BOOL isNiu = NO;
    NSDictionary *para ;
    NSString *url ;
    NSString *code = self.comanyCode;
    NSString *emojiCovert = [content stringByReplacingEmojiUnicodeWithCheatCodes];
    
    switch (self.type) {
        case kPublishNiu:
            url = API_SurveyAddComment;
            para = @{@"type":       @"1",
                     @"content":    emojiCovert,
                     @"code":       code,
                     @"user_id":    US.userId};
            isNiu = YES;
            break;
        case kPublishXiong:
            url = API_SurveyAddComment;
            para = @{@"type":       @"2",
                     @"content":    emojiCovert,
                     @"code":       code,
                     @"user_id":    US.userId};
            isNiu = NO;
            break;
        case kPublishAsk:
            url = API_SurveyAddQuestion;
            para = @{@"code":       code,
                     @"question":   emojiCovert,
                     @"user_id":    US.userId};
            break;
        default:
            return;
            break;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中";
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:url parameters:para completion:^(id data, NSError *error) {
        if (!error) {
            [hud hide:YES];
            if (self.type == kPublishAsk) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kSurveyDetailContentChanged object:nil userInfo:@{@"Tag": @(5)}];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kSurveyDetailContentChanged object:nil userInfo:@{@"Tag": @(2),@"IsNiu": @(isNiu)}];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            hud.labelText = error.localizedDescription;
            [hud hide:YES afterDelay:0.4];
        }
    }];
}



@end

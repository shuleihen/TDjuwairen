//
//  AnsPublishViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AnsPublishViewController.h"
#import "AskTableViewCell.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "NotificationDef.h"
#import "LoginState.h"
#import "NSString+Emoji.h"

@interface AnsPublishViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AnsPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fabu_ask.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(publishPressed:)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.textView becomeFirstResponder];
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
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSString *emojiCovert = [content stringByReplacingEmojiUnicodeWithCheatCodes];
    
    NSDictionary *para = @{@"ask_id":   self.ask.surveyask_id,
                           @"content":  emojiCovert,
                           @"user_id":  US.userId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中";
    
    [manager POST:API_SurveyAnswerQuestion parameters:para completion:^(id data, NSError *error) {
        if (!error) {
            [hud hide:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSurveyDetailContentChanged object:nil userInfo:@{@"Tag": @(5)}];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            hud.labelText = error.localizedDescription;
            [hud hide:YES afterDelay:0.4];
        }
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AskModel *ask = self.ask;
        return [AskTableViewCell heightWithContent:ask.surveyask_content];
    } else {
        return 120;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AskTableViewCell *askCell = (AskTableViewCell *)cell;
        [askCell setupAsk:self.ask];
    } else {
        
    }
}
@end

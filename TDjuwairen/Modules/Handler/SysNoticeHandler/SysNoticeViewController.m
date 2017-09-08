//
//  SysNoticeViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/8.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SysNoticeViewController.h"
#import "SettingHandler.h"
#import "STPopup.h"

@interface SysNoticeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SysNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    [SettingHandler saveShowSysNoticTime:time];
    
    self.textView.text = self.notice;
}

- (void)setNotice:(NSString *)notice {
    _notice = notice;
}

- (IBAction)notShowPressed:(id)sender {
    [SettingHandler setEverNotShowSysNotice];
    [self.popupController dismiss];
}

- (IBAction)donePressed:(id)sender {
    [self.popupController dismiss];
}
@end

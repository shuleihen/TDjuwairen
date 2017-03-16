//
//  AliveRoomPopupViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomPopupViewController.h"
#import "STPopup.h"

@interface AliveRoomPopupViewController ()
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@end

@implementation AliveRoomPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.titleLabel.text = self.titleString;
    self.textView.text = self.content;
}

- (IBAction)closePressed:(id)sender {
    [self.popupController dismiss];
}
@end

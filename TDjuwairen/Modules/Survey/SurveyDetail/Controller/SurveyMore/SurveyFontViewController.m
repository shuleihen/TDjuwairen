//
//  SurveyFontViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyFontViewController.h"
#import "PlistFileDef.h"
#import "NotificationDef.h"
#import "STPopup.h"

@interface SurveyFontViewController ()
@property (nonatomic, strong) NSArray *fontArray;
@property (nonatomic, assign) NSInteger currentFontSize;
@end

@implementation SurveyFontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = TDSeparatorColor;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kSurveyContentFontSize] == 0) {
        self.currentFontSize = 3;
    } else {
        self.currentFontSize = [[NSUserDefaults standardUserDefaults] integerForKey:kSurveyContentFontSize];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    
    UIImage *image = [[UIImage imageNamed:@"nav_back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.popupController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.popupController setNavigationBarHidden:YES animated:animated];
}


- (void)back:(id)sender {
    [self.popupController popViewControllerAnimated:YES];
}

- (void)donePressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentFontSize forKey:kSurveyContentFontSize];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.popupController dismissWithCompletion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kSurveyContentFontSizeChanged object:nil];
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.accessoryType = ((indexPath.row+1) == self.currentFontSize)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentFontSize = indexPath.row+1;
    [self.tableView reloadData];
}
@end

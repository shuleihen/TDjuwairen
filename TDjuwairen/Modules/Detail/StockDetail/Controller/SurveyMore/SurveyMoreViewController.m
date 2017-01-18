//
//  SurveyMoreViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyMoreViewController.h"
#import "STPopup.h"

@interface SurveyMoreViewController ()

@end

@implementation SurveyMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.popupController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.popupController setNavigationBarHidden:NO animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
    
    if (indexPath.row == 0) {
        if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
            cell.imageView.image = [UIImage imageNamed:@"icon_night.png"];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"icon_daytime.png"];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != 1) {
        [self.popupController dismiss];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithRow:)]) {
        [self.delegate didSelectedWithRow:indexPath.row];
    }

}
@end

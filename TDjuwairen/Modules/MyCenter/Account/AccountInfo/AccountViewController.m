//
//  AccountViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AccountViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginStateManager.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "NotificationDef.h"
#import "UIMacroDef.h"
#import "HexColors.h"
#import "NotificationDef.h"
#import "AliveCitySettingViewController.h"
#import "AliveSexSettingViewController.h"
#import "LoginHandler.h"
#import "ImagePickerHandler.h"

@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource,ImagePickerHanderlDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) UIImage *headImage;
@property (nonatomic, strong) LoginStateManager *userInfo;
@property (nonatomic, strong) ImagePickerHandler *imagePicker;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.imagePicker = [[ImagePickerHandler alloc] initWithDelegate:self];
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.userInfo = US;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self queryUserInfo];
}

- (void)queryUserInfo {
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_GetUserInfo parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            self.userInfo = [[LoginStateManager alloc] initWithDictionary:data];
            [LoginHandler saveUserInfoData:data];
            
            [self.tableView reloadData];
        } else {
            
        }
    }];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        // 头像
        if (self.headImage) {
            self.avatarImageView.image = self.headImage;
        } else {
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.headImage] placeholderImage:TDDefaultUserAvatar options:SDWebImageRefreshCached];
        }
        
    } else if ((indexPath.section == 0) && (indexPath.row == 1)) {
        // 昵称
        cell.detailTextLabel.text = self.userInfo.nickName;
    } else if ((indexPath.section == 0) && (indexPath.row == 2)) {
        // 用户名
        cell.detailTextLabel.text = self.userInfo.userName;
    } else if ((indexPath.section == 1) && (indexPath.row == 0)) {
        // 性别
        cell.detailTextLabel.text = self.userInfo.sexString;
    } else if ((indexPath.section == 1) && (indexPath.row == 1)) {
        // 地区
        cell.detailTextLabel.text = self.userInfo.city;
    } else if ((indexPath.section == 1) && (indexPath.row == 2)) {
        // 个人简介
        if (self.userInfo.personal.length) {
            self.introLabel.text = self.userInfo.personal;
        } else {
            self.introLabel.text = TDDefaultRoomDesc;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        // 修改头像
        [self.imagePicker showImagePickerInController:self withLimitSelectedCount:1];
    } else if ((indexPath.section == 1) && (indexPath.row == 0)) {
        // 性别
        AliveSexSettingViewController *vc = [[AliveSexSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.sex = self.userInfo.sexString;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ((indexPath.section == 1) && (indexPath.row == 1)) {
        // 地区
        AliveCitySettingViewController *vc = [[AliveCitySettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.level = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - ImagePickerHanderlDelegate
- (void)imagePickerHanderl:(ImagePickerHandler *)imagePicker didFinishPickingImages:(NSArray *)images {
    UIImage *image = images.firstObject;
    
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    UIImage *reSizeImg = [UIImage imageWithData:data];
    reSizeImg = [self imageWithImage:reSizeImg scaledToSize:CGSizeMake(200, 200)];
    self.headImage = reSizeImg;
    
    [self requestUploadHeadImage];
}

//修改图片尺寸
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)requestUploadHeadImage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"请稍等";
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"userid":self.userInfo.userId};
    
    [manager POST:API_UploadUserface parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = self.headImage;
        
        NSData *data = UIImageJPEGRepresentation(image, 1);
        
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:data name:self.userInfo.userId fileName:fileName mimeType:@"image/png"];
        
    } completion:^(id data, NSError *error) {
        if (!error) {
            hud.label.text = @"上传成功";
            [hud hideAnimated:YES afterDelay:1];
            
            // 修改头像
            self.userInfo.headImage = data[@"userinfo_facesmall"];
            
            [self.tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
        } else {
            hud.label.text = @"网络错误";
            [hud hideAnimated:YES afterDelay:1];
        }
    }];
}

@end

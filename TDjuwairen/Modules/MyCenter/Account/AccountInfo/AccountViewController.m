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
#import "ELCImagePickerController.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "NotificationDef.h"
#import "UIMacroDef.h"
#import "HexColors.h"
#import "NotificationDef.h"
#import "AliveCitySettingViewController.h"
#import "AliveSexSettingViewController.h"
#import "LoginHandler.h"

@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource,ELCImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) UIImage *headImage;
@property (nonatomic, strong) LoginStateManager *userInfo;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
            self.introLabel.text = @"很懒哦，什么也没留下";
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        //修改头像
        UIAlertController*alert = [[UIAlertController alloc] init];
        //相机
        [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }]];
        //相册
        [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = 1;
            elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.imagePickerDelegate = self;
            [self presentViewController:elcPicker animated:YES completion:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
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

//打开相机
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:picker animated:YES completion:nil];
        
    }else
    {
        
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:@"无法打开相机" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    UIImage *reSizeImg = [UIImage imageWithData:data];
    reSizeImg = [self imageWithImage:reSizeImg scaledToSize:CGSizeMake(200, 200)];
    self.headImage = reSizeImg;
    
    [self requestHead];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    NSDictionary *dic=[info objectAtIndex:0];
    UIImage *img = [dic objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSData *data = UIImageJPEGRepresentation(img, 0.9);
    UIImage *reSizeImg = [UIImage imageWithData:data];
    reSizeImg = [self imageWithImage:reSizeImg scaledToSize:CGSizeMake(200, 200)];
    self.headImage = reSizeImg;
    
    [self.tableView reloadData];
    //上传头像
    [self requestHead];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

//上传头像
-(void)requestHead
{
    [self requestUploadHeadImage];
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

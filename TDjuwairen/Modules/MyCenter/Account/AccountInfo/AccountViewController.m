//
//  AccountViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AccountViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginState.h"
#import "ELCImagePickerController.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "NotificationDef.h"
#import "UIMacroDef.h"
#import "HexColors.h"

@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource,ELCImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) UIImage *headImage;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.avatarImageView.layer.cornerRadius = 22.5f;
    self.avatarImageView.clipsToBounds = YES;
    [self getValidation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        // 头像
        if (self.headImage) {
            self.avatarImageView.image = self.headImage;
        } else {
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:US.headImage] placeholderImage:TDDefaultUserAvatar options:SDWebImageRefreshCached];
        }
        
    } else if ((indexPath.section == 0) && (indexPath.row == 1)) {
        // 用户名
        cell.detailTextLabel.text = US.userName;
    } else if ((indexPath.section == 0) && (indexPath.row == 2)) {
        // 昵称
        cell.detailTextLabel.text = US.nickName;
    } else if ((indexPath.section == 0) && (indexPath.row == 3)) {
        // 手机号
        cell.detailTextLabel.text = US.userPhone;
    } else if ((indexPath.section == 1) && (indexPath.row == 0)) {
        // 公司
        cell.detailTextLabel.text = US.company;
    } else if ((indexPath.section == 1) && (indexPath.row == 1)) {
        // 职位
        cell.detailTextLabel.text = US.post;
    } else if ((indexPath.section == 1) && (indexPath.row == 2)) {
        // 个人简介
        if (US.personal.length) {
            self.introLabel.text = US.personal;
            self.introLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#646464"];
        } else {
            self.introLabel.text = @"很懒哦，什么也没留下";
            self.introLabel.textColor = TDDetailTextColor;
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
    NSData *data = UIImageJPEGRepresentation(image, 0.75);
    UIImage *reSizeImg = [UIImage imageWithData:data];
    reSizeImg = [self imageWithImage:reSizeImg scaledToSize:CGSizeMake(200, 200)];
    self.headImage = reSizeImg;
    
    [self requestHead];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    NSDictionary *dic=[info objectAtIndex:0];
    UIImage *img = [dic objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSData *data = UIImageJPEGRepresentation(img, 0.5);
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
    hud.labelText = @"请稍等";
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"authenticationStr":US.userId,
                         @"encryptedStr":self.str,
                         @"userid":US.userId};
    
    [manager POST:API_UploadUserface parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = self.headImage;
        
        NSData *data = UIImageJPEGRepresentation(image, 1);
        
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:data name:US.userId fileName:fileName mimeType:@"image/png"];
        
    } completion:^(id data, NSError *error) {
        if (!error) {
            hud.labelText = @"上传成功";
            [hud hide:YES afterDelay:1];
            
            // 修改头像
            US.headImage = data[@"userinfo_facesmall"];
            
            [self.tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
        } else {
            hud.labelText = @"网络错误";
            [hud hide:YES afterDelay:1];
        }
    }];
}

- (void)getValidation{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para = @{@"validatestring":US.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.str = dic[@"str"];
        } else {
            
        }
    }];
}

@end

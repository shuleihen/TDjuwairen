//
//  MyInfoTableViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/20.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "MyInfoTableViewController.h"
#import "ELCImagePickerController.h"
#import "UIImageView+WebCache.h"
#import "LoginState.h"
#import "NetworkManager.h"

@interface MyInfoTableViewController ()<ELCImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIVisualEffectView *effectView;
    UIImage*headImage;
}
@property(nonatomic,strong)LoginState*LoginState;
@end

@implementation MyInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.LoginState=[LoginState addInstance];
    
    self.tableView.contentInset =UIEdgeInsetsMake(-100, 0, 0, 0);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //监听键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    //监听TextField内容的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(contentChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//监听TextField内容的改变，改变保存button的状态
-(void)contentChange
{
    self.preserveBtn.enabled=YES;
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height+120;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNagivation];
    [self loadImage];
    
    //设置用户名
    self.userNameTextField.text=self.LoginState.userName;
    self.userNameTextField.textColor=[UIColor grayColor];
    
    //设置昵称
    self.nicknameTextField.text=self.LoginState.nickName;
    self.nicknameTextField.textColor=[UIColor grayColor];
    self.nicknameTextField.userInteractionEnabled=NO;
    
    //设置手机号
    self.phoneTextField.text=self.LoginState.userPhone;
    self.phoneTextField.textColor=[UIColor grayColor];
    self.phoneTextField.userInteractionEnabled=NO;
    
    //设置公司
    self.companyTextField.text=self.LoginState.company;
    self.companyTextField.textColor=[UIColor grayColor];
    
    //设置职务
    self.postTextField.text=self.LoginState.post;
    self.postTextField.textColor=[UIColor grayColor];
    
    //设置个人简介
    self.personalTextField.text=self.LoginState.personal;
    self.personalTextField.textColor=[UIColor grayColor];
}

-(void)loadImage
{
    //加载头像
    NSString*imagePath=[NSString stringWithFormat:@"%@",self.LoginState.headImage];
    [self.headimageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil options:SDWebImageRefreshCached];
    
    //加载模糊背景图片
    
    NSString*Path=[NSString stringWithFormat:@"%@",self.LoginState.headImage];
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:Path] placeholderImage:nil options:SDWebImageRefreshCached];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(0, 0, kScreenWidth, self.backgroundImageView.frame.size.height);
    [self.backgroundImageView addSubview:effectView];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [effectView removeFromSuperview];
}

-(void)setNagivation
{
    
    //保存button
    self.preserveBtn=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(preserveClick)];
    self.preserveBtn.enabled=NO;
    self.navigationItem.rightBarButtonItem=self.preserveBtn;
    
    //设置navigationbar透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        NSArray *list = self.navigationController.navigationBar.subviews;
        
        for (id obj in list) {
            
            if ([obj isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageView = (UIImageView *)obj;
                
                imageView.hidden = YES;
                
            }
            
        }
        
    }

}


-(void)preserveClick
{
    //修改用户名
    [self requestChangeUserNameAuthentication];
    //修改公司名
    [self requestChangeCompanyAuthentication];
    //修改职务
    [self requestChangePostAuthentication];
    //修改个人简介
    [self requestChangePersonalAuthentication];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-修改用户名身份验证
-(void)requestChangeUserNameAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para=@{@"validatestring":self.LoginState.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.str=dic[@"str"];
            [self requestrequestChangeUserName];
        } else {
            
        }
    }];
}
#pragma mark-修改用户名
-(void)requestrequestChangeUserName
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras = @{@"authenticationStr":self.LoginState.userId,
                         @"encryptedStr":self.str,
                         @"userid":self.LoginState.userId,
                         @"username":self.userNameTextField.text};
    
    [manager POST:API_UpdateUserName parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            self.LoginState.userName=self.userNameTextField.text;
        } else {
            
        }
    }];
}

#pragma mark-修改公司身份验证
-(void)requestChangeCompanyAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para=@{@"validatestring":self.LoginState.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.str = dic[@"str"];
            [self requestChangeCompany];
        } else {
            
        }
    }];
}

#pragma mark-修改公司
-(void)requestChangeCompany
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"authenticationStr":self.LoginState.userId,
                         @"encryptedStr":self.str,
                         @"userid":self.LoginState.userId,
                         @"CompanyName":self.companyTextField.text};
    
    [manager POST:API_UpdateCompanyName parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            self.LoginState.company = self.companyTextField.text;
        } else {
            
        }
    }];
}
#pragma mark-修改职务身份验证
-(void)requestChangePostAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para=@{@"validatestring":self.LoginState.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.str = dic[@"str"];
            [self requestChangePost];
        } else {
            
        }
    }];
}
#pragma mark-修改职务
-(void)requestChangePost
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"authenticationStr":self.LoginState.userId,
                         @"encryptedStr":self.str,
                         @"userid":self.LoginState.userId,
                         @"occupationName":self.postTextField.text};
    
    [manager POST:API_UpdateOccupationName parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            self.LoginState.post=self.postTextField.text;
        } else {
            
        }
    }];
}

#pragma mark-修改个人简介身份验证
-(void)requestChangePersonalAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para=@{@"validatestring":self.LoginState.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.str = dic[@"str"];
            [self requestChangePersonal];
        } else {
            
        }
    }];
}
#pragma mark-修改个人简介
-(void)requestChangePersonal
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"authenticationStr":self.LoginState.userId,
                         @"encryptedStr":self.str,
                         @"userid":self.LoginState.userId,
                         @"Userinfo":self.personalTextField.text};
    
    [manager POST:API_UpdateUserInfo parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            self.LoginState.personal=self.personalTextField.text;
        } else {
            
        }
    }];
}


- (IBAction)headimageBtn:(UIButton *)sender {
    
    UIAlertController*alert=[[UIAlertController alloc]init];
    //相册
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.maximumImagesCount = 1;
        elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.imagePickerDelegate = self;
        [self presentViewController:elcPicker animated:YES completion:nil];
    }]];
    //相机
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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
    UIImage *reSizeImg=[UIImage imageWithData:data];
    reSizeImg=[self imageWithImage:reSizeImg scaledToSize:CGSizeMake(200, 200)]; 
    headImage=reSizeImg;
    [self requestHead];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    NSDictionary *dic=[info objectAtIndex:0];
    UIImage *img = [dic objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSData *data = UIImageJPEGRepresentation(img, 0.75);
    UIImage *reSizeImg=[UIImage imageWithData:data];
    reSizeImg=[self imageWithImage:reSizeImg scaledToSize:CGSizeMake(200, 200)];
    headImage=reSizeImg;
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
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para=@{@"validatestring":self.LoginState.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.str = dic[@"str"];
            [self requestUploadHeadImage];
        } else {
            
        }
    }];
}

-(void)requestUploadHeadImage
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"authenticationStr":self.LoginState.userId,
                         @"encryptedStr":self.str,
                         @"userid":self.LoginState.userId};
    
    [manager POST:API_UploadUserface parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image=headImage;
        NSData*data=UIImagePNGRepresentation(image);
        
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:data name:self.LoginState.userId fileName:fileName mimeType:@"image/png"];
        
    } completion:^(id data, NSError *error) {
        if (!error) {
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"头像上传成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [aler addAction:conformAction];
            [self presentViewController:aler animated:YES completion:nil];
        } else {
            
        }
    }];
}
@end

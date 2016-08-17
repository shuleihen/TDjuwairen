//
//  MyInfoViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyHeadTableViewCell.h"
#import "LoginState.h"
#import "UIdaynightModel.h"
#import "MyInfomationTableViewCell.h"
#import "ELCImagePickerController.h"
#import "NetworkManager.h"

@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,ELCImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *TitleArr;
@property (nonatomic,strong) NSMutableArray *MyInfoArr;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) UIImage *headImage;
@property (nonatomic,strong) UIButton *save;
@property (nonatomic,strong) UIButton *back;
@property (nonatomic,strong) UITextField *currentField;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.TitleArr = @[@"用户名",@"手机号",@"昵称",@"公司",@"职位",@"个人简介"];
    NSArray *arr = @[US.userName,
                     US.userPhone,
                     US.nickName,
                     US.company,
                     US.post,
                     US.personal];
    self.MyInfoArr = [NSMutableArray arrayWithArray:arr];

    //身份验证
    [self getValidation];
    [self setupWithNavigation];
    [self setupWithTableView];
    [self setupWithBackAndSave];
    // Do any additional setup after loading the view.
}
- (void)setupListen{
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];

}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
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

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //设置navigation背景色
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+20) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableview.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *identifier = @"headcell";
        MyHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NSString *identifier = @"cell";
        MyInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyInfomationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        if (indexPath.row-1 == 1 ||indexPath.row-1 == 2 ) {
            cell.textfield.enabled = NO;
        }
        cell.namelabel.text = self.TitleArr[indexPath.row];
        cell.textfield.text = self.MyInfoArr[indexPath.row];
        cell.textfield.delegate = self;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 190;
    }
    else
    {
        return 47;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    else
    {
        return 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        //修改头像
        UIAlertController*alert=[[UIAlertController alloc]init];
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
    else
    {
        MyInfomationTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.textfield isFirstResponder];
    }
    
}

- (void)setupWithBackAndSave{
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 50)];
    [self.back setImage:[UIImage imageNamed:@"nav_backwhite"] forState:UIControlStateNormal];
    [self.back addTarget:self action:@selector(ClickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    self.save = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-8-50, 20, 50, 50)];
    [self.save setTitle:@"保存" forState:UIControlStateNormal];
    [self.save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.save.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.save addTarget:self action:@selector(ClickSave:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableview addSubview:self.back];
    [self.tableview addSubview:self.save];
}
//点击返回
- (void)ClickBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击保存信息
- (void)ClickSave:(UIButton *)sender{
    //修改用户名
    [self requestrequestChangeUserName];
    //修改公司名
    [self requestChangeCompany];
    //修改职务
    [self requestChangePost];
    //修改个人简介
    [self requestChangePersonal];
}

#pragma mark-修改用户名
-(void)requestrequestChangeUserName
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    MyInfomationTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"authenticationStr":US.userId,
                         @"encryptedStr":self.str,
                         @"userid":US.userId,
                         @"username":cell.textfield.text};
    
    [manager POST:API_UpdateUserName parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            US.userName = cell.textfield.text;
        } else {
            
        }
    }];
}

#pragma mark-修改公司
-(void)requestChangeCompany
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    MyInfomationTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"authenticationStr":US.userId,
                         @"encryptedStr":self.str,
                         @"userid":US.userId,
                         @"CompanyName":cell.textfield.text};
    
    [manager POST:API_UpdateCompanyName parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            US.company=cell.textfield.text;
        } else {
            
        }
    }];
}

#pragma mark-修改职务
-(void)requestChangePost
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    MyInfomationTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"authenticationStr":US.userId,
                         @"encryptedStr":self.str,
                         @"userid":US.userId,
                         @"occupationName":cell.textfield.text};
    
    [manager POST:API_UpdateOccupationName parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            US.post=cell.textfield.text;
        } else {
            
        }
    }];
}

#pragma mark-修改个人简介
-(void)requestChangePersonal
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    MyInfomationTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"authenticationStr":US.userId,
                         @"encryptedStr":self.str,
                         @"userid":US.userId,
                         @"Userinfo":cell.textfield.text};
    
    [manager POST:API_UpdateUserInfo parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            US.personal = cell.textfield.text;
        } else {
            
        }
    }];
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
    self.headImage=reSizeImg;
    [self requestHead];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    NSDictionary *dic=[info objectAtIndex:0];
    UIImage *img = [dic objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSData *data = UIImageJPEGRepresentation(img, 0.75);
    UIImage *reSizeImg=[UIImage imageWithData:data];
    reSizeImg=[self imageWithImage:reSizeImg scaledToSize:CGSizeMake(200, 200)];
    self.headImage=reSizeImg;
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
    NSDictionary*para=@{@"validatestring":US.userId};
    
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
    NSDictionary*paras=@{@"authenticationStr":US.userId,
                         @"encryptedStr":self.str,
                         @"userid":US.userId};
    
    [manager POST:API_UploadUserface parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = self.headImage;
        NSData*data=UIImagePNGRepresentation(image);
        
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:data name:US.userId fileName:fileName mimeType:@"image/png"];
        
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark -textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentField = textField;
    //键盘高度216
    
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.10f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    CGPoint view = [self.view convertPoint:CGPointZero fromView:self.currentField];
    self.tableview.frame = CGRectMake(0.0f, -view.y/2, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
    self.back.alpha = 0.0f;
    self.save.alpha = 0.0f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //滑动效果
    NSTimeInterval animationDuration = 0.10f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.tableview.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
    self.back.alpha = 1.0f;
    self.save.alpha = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

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
#import "MyInfomationTableViewCell.h"
#import "AFNetworking.h"
#import "ELCImagePickerController.h"

@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,ELCImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) LoginState *loginState;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *TitleArr;
@property (nonatomic,strong) NSMutableArray *MyInfoArr;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) UIImage *headImage;
@property (nonatomic,strong) UIButton *save;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginState = [LoginState addInstance];
    self.TitleArr = @[@"用户名",@"手机号",@"昵称",@"公司",@"职位",@"个人简介"];
    NSArray *arr = @[self.loginState.userName,
                     self.loginState.userPhone,
                     self.loginState.nickName,
                     self.loginState.company,
                     self.loginState.post,
                     self.loginState.personal];
    self.MyInfoArr = [NSMutableArray arrayWithArray:arr];
    
    [self setupListen];
    
    //身份验证
    [self getValidation];
    [self setupWithNavigation];
    [self setupWithTableView];
    [self setupWithBackAndSave];
    // Do any additional setup after loading the view.
}
- (void)setupListen{
    //监听键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    //监听TextField内容的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(contentChange) name:UITextFieldTextDidChangeNotification object:nil];
}

//监听TextField内容的改变，改变保存button的状态
-(void)contentChange
{
    self.save.enabled=YES;
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

- (void)getValidation{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Public/getapivalidate/"];
    NSDictionary*para=@{@"validatestring":self.loginState.userId};
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary*dic=responseObject[@"data"];
            self.str=dic[@"str"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络错误，身份验证失败");
    }];
}

- (void)setupWithNavigation{
    [self.navigationController.navigationBar setHidden:YES];
    //设置navigation背景色
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    
    [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage* image = [UIImage imageNamed:@"back"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight+20) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableview.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSString *identifier = @"headcell";
        MyHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
    else
    {
        NSString *identifier = @"cell";
        MyInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyInfomationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.namelabel.text = self.TitleArr[indexPath.row-1];
        cell.textfield.text = self.MyInfoArr[indexPath.row-1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 190;
    }
    else
    {
        return 47;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //修改头像
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
    else
    {
        MyInfomationTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.textfield isFirstResponder];
    }
    
}

- (void)setupWithBackAndSave{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 65, 20)];
    [back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(ClickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    self.save = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-8-50, 30, 50, 20)];
    [self.save setTitle:@"保存" forState:UIControlStateNormal];
    [self.save setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.save.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.save addTarget:self action:@selector(ClickSave:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:back];
    [self.view addSubview:self.save];
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
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/User/updateUsername/"];
    NSDictionary*paras=@{@"authenticationStr":self.loginState.userId,
                         @"encryptedStr":self.str,
                         @"userid":self.loginState.userId,
                         @"username":cell.textfield.text};
    [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"修改用户名成功");
            self.loginState.userName = cell.textfield.text;
        }
        else
        {
            NSLog(@"修改用户名失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark-修改公司
-(void)requestChangeCompany
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    MyInfomationTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/User/updateCompanyName/"];
    NSDictionary*paras=@{@"authenticationStr":self.loginState.userId,
                         @"encryptedStr":self.str,
                         @"userid":self.loginState.userId,
                         @"CompanyName":cell.textfield.text};
    [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"修改公司成功");
            self.loginState.company=cell.textfield.text;
        }
        else
        {
            NSLog(@"修改公司失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark-修改职务
-(void)requestChangePost
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    MyInfomationTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/User/updateOccupationName/"];
    NSDictionary*paras=@{@"authenticationStr":self.loginState.userId,
                         @"encryptedStr":self.str,
                         @"userid":self.loginState.userId,
                         @"occupationName":cell.textfield.text};
    [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"修改职务成功");
            self.loginState.post=cell.textfield.text;
        }
        else
        {
            NSLog(@"修改职务失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark-修改个人简介
-(void)requestChangePersonal
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    MyInfomationTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/User/updateUserinfo/"];
    NSDictionary*paras=@{@"authenticationStr":self.loginState.userId,
                         @"encryptedStr":self.str,
                         @"userid":self.loginState.userId,
                         @"Userinfo":cell.textfield.text};
    [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"修改个人简介成功");
            self.loginState.personal = cell.textfield.text;
        }
        else
        {
            NSLog(@"修改个人简介失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Public/getapivalidate/"];
    NSDictionary*para=@{@"validatestring":self.loginState.userId};
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary*dic=responseObject[@"data"];
            self.str=dic[@"str"];
            [self requestUploadHeadImage];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)requestUploadHeadImage
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/User/userfaceImgUp/"];
    NSDictionary*paras=@{@"authenticationStr":self.loginState.userId,
                         @"encryptedStr":self.str,
                         @"userid":self.loginState.userId};
    [manager POST:url parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = self.headImage;
        NSData*data=UIImagePNGRepresentation(image);
        
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:data name:self.loginState.userId fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"上传成功！");
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"头像上传成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [aler addAction:conformAction];
        [self presentViewController:aler animated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败！");
    }];
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

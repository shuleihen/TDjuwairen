//
//  PublishViewViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PublishViewViewController.h"
#import "UIdaynightModel.h"
#import "BottomEdit.h"
#import "SecondEdit.h"
#import "EditZiti.h"
#import "CompanySelTableView.h"
#import "LoginState.h"
#import "PreviewViewController.h"
#import "InsertTagsView.h"

#import "NSString+Ext.h"
#import "PhotoTextAttachment.h"
#import "UIImageView+WebCache.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "SDImageCache.h"

@interface PublishViewViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,BottomEditDelegate,SecondEditDelegate,InsertTagsDelegate>
{
    NSString *currentTitle;
    NSString *currentDesc;
    BOOL jiacu;
    BOOL xieti;
    BOOL xiahuaxian;
    NSString *isoriginal;
    NSUInteger numm;
    NSRange currentRange;//当前光标所在位置
    NSString *zititype;
    BOOL firstchange;
    
}

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) UIScrollView *scrollview;

@property (nonatomic,strong) UITextField *titleText;
@property (nonatomic,strong) UIButton *originalBtn;
@property (nonatomic,strong) UILabel *placeholderLab;
@property (nonatomic,strong) UITextView *contentText;
@property (nonatomic,strong) BottomEdit *bottomView;
@property (nonatomic,strong) SecondEdit *secondView;
@property (nonatomic,strong) EditZiti *editziti;
@property (nonatomic,strong) InsertTagsView *tagsview;
@property (nonatomic,strong) CompanySelTableView *companySelView;
@property (nonatomic,copy) NSString *companyName;

@property (nonatomic,strong) NSMutableArray *imglocArr;
@property (nonatomic,strong) NSMutableArray *upimgArr;
@property (nonatomic,strong) NSMutableArray *tagsArr;

@property (nonatomic,strong) UIView *SelSecView;
@property (nonatomic,strong) UIButton *selBtnEdit;
@property (nonatomic,copy) NSString *selType;

@property (nonatomic,assign) float contentHeight;
@property (nonatomic,assign) float frameHeight;
@property (nonatomic,assign) float keyboardHeight;


@end

@implementation PublishViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imglocArr = [NSMutableArray array];
    self.upimgArr = [NSMutableArray array];
    self.tagsArr = [NSMutableArray array];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.editziti = [EditZiti sharedInstance];
    numm = 0;
    self.editziti.zihao = 16;//默认16号字体
    isoriginal = @"1"; //默认为原创文章
    firstchange = YES;
    self.editziti.type = [NSString stringWithFormat:@"nil%d",self.editziti.zihao];//默认
    zititype = self.editziti.type;
    
    
    [self setupWithNavigation];
    [self setupWithScrollview];
    [self setupWithTitleText];
    [self setupWithContentText];
    
    self.scrollview.contentSize = CGSizeMake(kScreenWidth, self.titleText.frame.size.height+self.contentText.frame.size.height);
    [self setupWithEdit];
}

#pragma mark - 监听editziti


- (void)setupWithNavigation{
    //设置navigation背景色
    [self.navigationController.navigationBar setBackgroundColor:self.daynightmodel.navigationColor];
    [self.navigationController.navigationBar setBarTintColor:self.daynightmodel.navigationColor];
    
    //设置右边发布按钮
    UIBarButtonItem *regist = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(clickPublish:)];
    self.navigationItem.rightBarButtonItem = regist;
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,30)];
    [back setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.backBarButtonItem = leftItem;
}

- (void)setupWithScrollview{
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40)];
    
    self.scrollview.backgroundColor = self.daynightmodel.navigationColor;
    [self.view addSubview:self.scrollview];
}

- (void)setupWithTitleText{
    self.titleText = [[UITextField alloc]initWithFrame:CGRectMake(-1, 0, kScreenWidth, 40)];
    self.titleText.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.titleText.rightViewMode = UITextFieldViewModeAlways;
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        self.titleText.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.titleText.backgroundColor = self.daynightmodel.backColor;
    }
    
    UIColor *color = self.daynightmodel.titleColor;
    self.titleText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"标题,24个字以内" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.titleText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.titleText.leftViewMode = UITextFieldViewModeAlways;
    
    self.titleText.font = [UIFont systemFontOfSize:18];
    self.titleText.textColor = self.daynightmodel.textColor;
    
    self.titleText.layer.borderWidth = 1;
    self.titleText.layer.borderColor = self.daynightmodel.lineColor.CGColor;
    
    self.originalBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-80, 5, 40, 30)];
    [self.originalBtn setImage:[UIImage imageNamed:@"btn_select.png"] forState:UIControlStateNormal];
    [self.originalBtn setImage:[UIImage imageNamed:@"btn_select_pre.png"] forState:UIControlStateSelected];
    self.originalBtn.selected = YES;//默认为原创
    [self.originalBtn setBackgroundColor:self.titleText.backgroundColor];
    [self.originalBtn addTarget:self action:@selector(isOriginal:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *originalLabel = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-40, 5, 40, 30)];
    originalLabel.titleLabel.font = [UIFont systemFontOfSize:16];
    [originalLabel setTitle:@"原创" forState:UIControlStateNormal];
    [originalLabel setTitleColor:self.daynightmodel.titleColor forState:UIControlStateNormal];
    [originalLabel setBackgroundColor:self.titleText.backgroundColor];
    [originalLabel addTarget:self action:@selector(isOriginal:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollview addSubview:self.titleText];
    [self.scrollview addSubview:self.originalBtn];
    [self.scrollview addSubview:originalLabel];
}



- (void)setupWithContentText{
    self.contentText = [[UITextView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-64-40)];
    self.contentText.textContainerInset = UIEdgeInsetsMake(8, 4, 8, 4);
    self.contentText.backgroundColor = self.titleText.backgroundColor;
    self.contentText.font = [UIFont systemFontOfSize:16];
    self.contentText.textColor = self.daynightmodel.textColor;
    self.contentText.delegate = self;
    [self.contentText addObserver:self
                       forKeyPath:@"contentSize"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    self.placeholderLab = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, kScreenWidth/2, 20)];
    self.placeholderLab.text = @"正文，8000个字以内";
    self.placeholderLab.textColor = self.daynightmodel.titleColor;
    self.placeholderLab.font = [UIFont systemFontOfSize:14];
    
    [self.contentText addSubview:self.placeholderLab];
    [self.scrollview addSubview:self.contentText];
    
}
#pragma mark - contentText的高度监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        //改变textview的高度
        CGRect frame = self.contentText.frame;
        if ([self.contentText.text isEqual:@""]) {
            
            if (![self.contentText.text isEqualToString:@""]) {
                
                self.contentHeight = [ self heightForTextView:self.contentText WithText:[self.contentText.text substringToIndex:[self.contentText.text length] - 1]];
                
            }else{
                
                self.contentHeight = [ self heightForTextView:self.contentText WithText:self.contentText.text];
            }
        }else{
            
            self.contentHeight = [self heightForTextView:self.contentText WithText:[NSString stringWithFormat:@"%@%@",self.contentText.text,self.contentText.text]];
        }
        frame.size.height = self.contentHeight;
        [UIView animateWithDuration:0.5 animations:^{
            
            self.contentText.frame = frame;
            
        } completion:nil];
        self.scrollview.contentSize = CGSizeMake(kScreenWidth, self.titleText.frame.size.height+self.contentText.frame.size.height);
        
        if (self.contentText.contentSize.height > kScreenHeight-self.keyboardHeight-80-64-40) {
            if (self.frameHeight != self.contentText.frame.size.height) {
                [self.scrollview setContentOffset:CGPointMake(0, self.contentText.contentSize.height-(kScreenHeight-self.keyboardHeight-80-64-40))];
            }
        }
    }
}

- (void)setupWithEdit{
    self.bottomView = [[BottomEdit alloc]initWithFrame:CGRectMake(0, kScreenHeight-64-40, kScreenWidth, 40)];
    self.bottomView.delegate = self;
    [self.view addSubview:self.bottomView];
}


- (void)clickBack:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.SelSecView removeFromSuperview];//移除子视图
    self.bottomView.selectBtn.selected = NO;
    [self.view endEditing:YES];
    [self keyboardWillBeHidden];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否保存草稿" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存到草稿" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //保存
        
        [self.navigationController popViewControllerAnimated:YES];
        //        [self.tabBarController.tabBar setHidden:NO];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
    
    UIAlertAction *giveup = [UIAlertAction actionWithTitle:@"放弃编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self.navigationController popViewControllerAnimated:YES];
        //        [self.tabBarController.tabBar setHidden:NO];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
        [self registerForKeyboardNotifications];
    }];
    
    [alert addAction:save];
    [alert addAction:giveup];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - 是否原创
- (void)isOriginal:(UIButton *)sender{
    if (self.originalBtn.selected == YES) {
        self.originalBtn.selected = NO;
        isoriginal = @"0";
    }
    else
    {
        self.originalBtn.selected = YES;
        isoriginal = @"1";
    }
}

#pragma mark - 点击编辑栏
- (void)clickEdit:(UIButton *)sender
{
    
    int num = (int)sender.tag;
    if (num == 0) {
        self.bottomView.selectBtn.selected = NO;
        sender.selected = YES;
        self.bottomView.selectBtn = sender;
        [self.SelSecView removeFromSuperview];
        [self.companySelView removeFromSuperview];
        if ([self.titleText isFirstResponder] || [self.contentText isFirstResponder]) {
            sender.selected = YES;
            self.selBtnEdit = sender;
            [self.view endEditing:YES];
            
        }
        else
        {
            sender.selected = NO;
            self.selBtnEdit = sender;
            [self.titleText becomeFirstResponder];
        }
    }
    else if(num == 1){
        self.bottomView.selectBtn.selected = NO;
        sender.selected = YES;
        self.bottomView.selectBtn = sender;
        [self.SelSecView removeFromSuperview];
        [self.companySelView removeFromSuperview];
        if ([self.titleText isFirstResponder]) {
            currentTitle = self.titleText.text;
            self.titleText.text = @"";
        }
        else
        {
            currentDesc = self.contentText.text;
            self.contentText.text = @"";
        }
    }
    else if (num == 2){
        self.bottomView.selectBtn.selected = NO;
        sender.selected = YES;
        self.bottomView.selectBtn = sender;
        [self.SelSecView removeFromSuperview];
        [self.companySelView removeFromSuperview];
        if ([self.titleText isFirstResponder]) {
            if ([currentTitle isEqualToString:@""] || currentTitle == nil) {
                
            }
            else
            {
                self.titleText.text = currentTitle;
            }
            
        }
        else
        {
            if ([currentDesc isEqualToString:@""] || currentDesc == nil) {
                
            }
            else
            {
                self.contentText.text = currentDesc;
            }
            
        }
    }
    else if (num ==3){
        if (sender.selected == NO) {
            [self.SelSecView removeFromSuperview];
            [self.companySelView removeFromSuperview];
            //字体设置
            self.secondView = [[SecondEdit alloc]initWithFrame:CGRectMake(0, self.bottomView.frame.origin.y-40, kScreenWidth, 40)];
            self.secondView.backgroundColor = self.daynightmodel.navigationColor;
            self.secondView.delegate = self;
            self.SelSecView = self.secondView;
            
            [self.view addSubview:self.secondView];
            
            self.bottomView.selectBtn.selected = NO;
            sender.selected = YES;
            self.bottomView.selectBtn = sender;
        }
        else
        {
            [self.SelSecView removeFromSuperview];
            [self.companySelView removeFromSuperview];
            self.bottomView.selectBtn.selected = NO;
            sender.selected = NO;
            self.bottomView.selectBtn = sender;
        }
        
    }
    else if (num == 4){
        if (sender.selected == NO) {
            [self.SelSecView removeFromSuperview];//移除子视图
            [self.companySelView removeFromSuperview];
            //插入
            NSArray *imgArr = @[@"btn_img@3x.png",@"btn_biaoqian"];
            NSArray *textArr = @[@"图片",@"股票"];
            self.secondView = [[SecondEdit alloc]initWithFrame:CGRectMake(0, self.bottomView.frame.origin.y-40, kScreenWidth, 40) andImgArr:imgArr andTextArr:textArr];
            self.secondView.backgroundColor = self.daynightmodel.navigationColor;
            self.secondView.delegate = self;
            self.SelSecView = self.secondView;
            
            [self.view addSubview:self.secondView];
            
            self.bottomView.selectBtn.selected = NO;
            sender.selected = YES;
            self.bottomView.selectBtn = sender;
        }
        else
        {
            [self.SelSecView removeFromSuperview];
            [self.companySelView removeFromSuperview];
            self.bottomView.selectBtn.selected = NO;
            sender.selected = NO;
            self.bottomView.selectBtn = sender;
        }
        
    }
    else {
        
        if (sender.selected == NO) {
            [self.SelSecView removeFromSuperview];//移除子视图
            [self.companySelView removeFromSuperview];
            //更多
            NSArray *imgArr = @[@"tab_yulan@3x.png",@"tab_caogao@3x.png"];
            NSArray *textArr = @[@"预览",@"存为草稿"];
            self.secondView = [[SecondEdit alloc]initWithFrame:CGRectMake(0, self.bottomView.frame.origin.y-40, kScreenWidth, 40) andImgArr:imgArr andTextArr:textArr];
            self.secondView.backgroundColor = self.daynightmodel.navigationColor;
            self.secondView.delegate = self;
            self.SelSecView = self.secondView;
            
            [self.view addSubview:self.secondView];
            
            self.bottomView.selectBtn.selected = NO;
            sender.selected = YES;
            self.bottomView.selectBtn = sender;
        }
        else
        {
            [self.SelSecView removeFromSuperview];
            [self.companySelView removeFromSuperview];
            self.bottomView.selectBtn.selected = NO;
            sender.selected = NO;
            self.bottomView.selectBtn = sender;
        }
        
    }
}

#pragma mark - 子视图
- (void)selectFont:(UIButton *)sender
{
    int num = (int)sender.tag;
    if (num == 0) {
        NSLog(@"加粗");
        numm = self.contentText.text.length;
        firstchange = YES;
        if (sender.selected == YES) {
            jiacu = YES;
        }
        else
        {
            jiacu = NO;
        }
        
    }
    else if (num == 1)
    {
        NSLog(@"倾斜");
        numm = self.contentText.text.length;
        firstchange = YES;
        if (sender.selected == YES) {
            xieti = YES;
        }
        else
        {
            xieti = NO;
        }
        
    }
    else if (num == 2)
    {
        NSLog(@"下划线");
        numm = self.contentText.text.length;
        firstchange = YES;
        if (sender.selected == YES) {
            xiahuaxian = YES;
        }
        else
        {
            xiahuaxian = NO;
        }
        
    }
    else if (num ==3)
    {
        NSLog(@"引用");
    }
    else if (num == 4)
    {
        NSLog(@"22");
        numm = self.contentText.text.length;
        firstchange = YES;
        self.editziti.zihao = 22;
    }
    else if (num == 5)
    {
        NSLog(@"20");
        numm = self.contentText.text.length;
        firstchange = YES;
        self.editziti.zihao = 20;
    }
    else if (num == 6)
    {
        NSLog(@"18");
        numm = self.contentText.text.length;
        firstchange = YES;
        self.editziti.zihao = 18;
    }
    else if (num == 7)
    {
        NSLog(@"16");
        numm = self.contentText.text.length;
        firstchange = YES;
        self.editziti.zihao = 16;
    }
    else
    {
        NSLog(@"14");
        numm = self.contentText.text.length;
        firstchange = YES;
        self.editziti.zihao = 14;
    }
}

- (void)sliderAction:(UISlider *)slider
{
    slider.value = (int)slider.value;
    self.secondView.fontLab.text = [NSString stringWithFormat:@"%d",(int)slider.value];
    numm = self.contentText.text.length;
    firstchange = YES;
    self.editziti.zihao = (int)slider.value;
}

- (void)clickSecBtn:(LeftRightBtn *)sender
{
    if ([sender.textLabel.text isEqualToString:@"链接"]) {
        //插入链接
    }
    else if ([sender.textLabel.text isEqualToString:@"图片"]){
        [self.SelSecView removeFromSuperview];
        //插入图片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
            
        }];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
            
        }];
        
        [alertController addAction:cameraAction];
        [alertController addAction:albumAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([sender.textLabel.text isEqualToString:@"股票"]){
        //插入股票
        [self.SelSecView removeFromSuperview];
        
        self.tagsview = [[InsertTagsView alloc]initWithFrame:CGRectMake(0, self.bottomView.frame.origin.y-80, kScreenWidth, 40) andArr:self.tagsArr];
        self.tagsview.delegate = self;
        self.tagsview.backgroundColor = self.daynightmodel.backColor;
        [self.tagsview.tagsText becomeFirstResponder];
        self.tagsview.tagsText.backgroundColor = self.daynightmodel.inputColor;
        self.tagsview.tagsText.layer.borderColor = self.daynightmodel.lineColor.CGColor;
        [self.tagsview.tagsText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        //弹出公司tab
        self.companySelView = [[CompanySelTableView alloc]initWithFrame:CGRectMake(15, self.bottomView.frame.origin.y - 140, kScreenWidth-100-15-15, 100) style:UITableViewStylePlain];
        __weak PublishViewViewController *publishView = self;
        self.companySelView.block = ^(CompanySelTableView *tableview,NSIndexPath *indexpath){
            UITableViewCell *cell = [tableview cellForRowAtIndexPath:indexpath];
            publishView.companyName = cell.textLabel.text;
            publishView.tagsview.tagsText.text = publishView.companyName;
        };
        self.SelSecView = self.tagsview;
        self.tagsArr = self.tagsview.listArr;
        [self.view addSubview:self.tagsview];
        [self.view addSubview:self.companySelView];
    }
    else if ([sender.textLabel.text isEqualToString:@"预览"]){
        //预览
        if (![self.contentText.text isEqualToString:@""]) {
            PreviewViewController *preview = [[PreviewViewController alloc] init];
            
            NSMutableAttributedString *up = [self.contentText.attributedText mutableCopy];
            NSUInteger cur = 0;
            
            for (int i = 0 ; i<self.upimgArr.count; i++) {
                NSString *str = self.imglocArr[i];
                NSUInteger loc = [str integerValue];
                if (i != 0) {
                    cur = [self.upimgArr[i-1] length] + cur;
                }
                NSUInteger current = loc+cur;
                NSAttributedString *imgtext = [[NSAttributedString alloc]initWithString:self.upimgArr[i]];
                [up insertAttributedString:imgtext atIndex:current];
                
            }
            NSString *htmlstring = [self htmlStringByHtmlAttributeString:up];
            htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
            htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
            
            preview.html = htmlstring;
            [self.navigationController pushViewController:preview animated:YES];
        }
    }
    else
    {
        [self.view endEditing:YES];
        [self.SelSecView removeFromSuperview];
        //存为草稿
        [self saveDrafts];
    }
}


#pragma mark Keyboard
- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification{
    //当键盘出现时计算键盘的高度大小，用于输入框显示
    NSDictionary *info = [aNotification userInfo];
    //kbSize为键盘尺寸
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘高度
    self.keyboardHeight = kbSize.height;
    
    [self beginMoveUpAnimation:kbSize.height];
    
}

- (void)keyboardWillBeHidden{
    [self.SelSecView removeFromSuperview];
    [self.companySelView removeFromSuperview];
    [UIView animateWithDuration:0.1 animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
        self.scrollview.transform = CGAffineTransformIdentity;
        
    }];
}

- (void)beginMoveUpAnimation:(CGFloat )height{
    [UIView animateWithDuration:0.1 animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -height);
        self.scrollview.transform = CGAffineTransformMakeTranslation(0, 0);
        [self.SelSecView setFrame:CGRectMake(0, self.bottomView.frame.origin.y-self.SelSecView.frame.size.height, kScreenWidth, self.SelSecView.frame.size.height)];
        [self.companySelView setFrame:CGRectMake(0, self.bottomView.frame.origin.y - 40-self.companySelView.frame.size.height, kScreenWidth-100-15-15, self.companySelView.frame.size.height)];
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 草稿再编辑处理
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    //    [self.titleText becomeFirstResponder];
    
    if (self.titleStr != nil && self.contentStr != nil) {
        self.titleText.text = self.titleStr;
        self.contentText.text = self.contentStr;
        self.placeholderLab.text = @"";
        self.placeholderLab.alpha = 0.0;
        
        
        NSString *htmlstring = self.contentStr;
        htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        
        //获取html中的图片标签
        NSArray *imgarr = [self getImageurlFromHtml:htmlstring];
        self.upimgArr = [NSMutableArray arrayWithArray:imgarr];
        
        NSArray *rangArr = [self getImageRangFromHtml:htmlstring andWithArr:imgarr];
        
        self.imglocArr = [NSMutableArray arrayWithArray:rangArr];
        
        NSAttributedString *contentAtt = [self attributedStringWithHtml:htmlstring];
        self.contentText.attributedText = contentAtt;
        
        //最后做清空处理
        self.titleStr = nil;
        self.contentStr = nil;
    }
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.contentText removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - 添加股票用
- (void)addTags:(UIButton *)sender
{
    //添加股票K线图
    if (![self.tagsview.tagsText.text isEqualToString:@""]) {
        NSString *stockCode = [self.tagsview.tagsText.text substringToIndex:6];
        //判断是上市还是深市
        NSString *code = [stockCode substringToIndex:1];
        NSString *stockKImgURl;
        NSString *imgUrl;
        if ([code isEqualToString:@"0"]) {
            stockKImgURl = [NSString stringWithFormat:@"http://image.sinajs.cn/newchart/daily/n/sz%@.gif",stockCode];
            imgUrl = [NSString stringWithFormat:@"<img src=\"%@\"/>",stockKImgURl];
        }
        else
        {
            stockKImgURl = [NSString stringWithFormat:@"http://image.sinajs.cn/newchart/daily/n/sh%@.gif",stockCode];
            imgUrl = [NSString stringWithFormat:@"<img src=\"%@\"/>",stockKImgURl];
        }
        
        [self.contentText becomeFirstResponder];
        currentRange = self.contentText.selectedRange;
        [self.upimgArr addObject:imgUrl];
        [self.imglocArr addObject:@(currentRange.location)];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:stockKImgURl]];
            UIImage *KImage = [[UIImage alloc]initWithData:data];
            if (data != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //在这里做UI操作
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentText.attributedText];
                    PhotoTextAttachment *textAttachment = [[PhotoTextAttachment alloc]init];
                    if (KImage.size.width >kScreenWidth) {
                        textAttachment.photoSize = CGSizeMake(kScreenWidth-16 , (kScreenWidth-16)/KImage.size.width*KImage.size.height);
                    }
                    else
                    {
                        textAttachment.photoSize = KImage.size;
                    }
                    
                    currentRange = self.contentText.selectedRange;
                    [self.imglocArr addObject:@(currentRange.location)];
                    textAttachment.image = KImage; //要添加的图片
                    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
                    
                    [string insertAttributedString:textAttachmentString atIndex:currentRange.location];//index为用户指定要插入图片的位置
                    //    NSAttributedString *imgtext = [[NSAttributedString alloc]initWithString:img];
                    //    [string insertAttributedString:imgtext atIndex:currentRange.location];
                    
                    self.contentText.attributedText = string;
                    [self.contentText becomeFirstResponder];
                    self.contentText.selectedRange = NSMakeRange(currentRange.location+1, currentRange.length);
                });
            } 
            
        });
    }
}

- (void)clearTags:(UIButton *)sender
{
    self.tagsview.tagsText.text = @"";
}

- (void)textFieldDidChange:(UITextField *)textfield{
    NSString *searchString = [textfield text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[c] %@",searchString];
    if (self.companySelView.showArr) {
        [self.companySelView.showArr removeAllObjects];
    }
    //得到搜索结果
    self.companySelView.showArr = [NSMutableArray arrayWithArray:[self.companySelView.companyArr filteredArrayUsingPredicate:predicate]];
    if (textfield.text.length == 0) {
        self.companySelView.showArr = [NSMutableArray arrayWithArray:self.companySelView.companyArr];
    }
    //刷新tableview
    [self.companySelView reloadData];
}

#pragma mark - textView delegate
-(void)textViewDidChange:(UITextView *)textView
{
    //比较上次光标位置，判断是否为删除状态
    if (currentRange.location < self.contentText.selectedRange.location) {
        //改变textview的高度
        CGRect frame = textView.frame;
        if ([textView.text isEqualToString:@""]) {
            
            if (![textView.text isEqualToString:@""]) {
                
                self.contentHeight = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
                
            }else{
                
                self.contentHeight = [ self heightForTextView:textView WithText:textView.text];
            }
        }else{
            
            self.contentHeight = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,textView.text]];
        }
        frame.size.height = self.contentHeight;
        [UIView animateWithDuration:0.5 animations:^{
            
            textView.frame = frame;
            
        } completion:nil];
    }
    
    //记录当前位置
    currentRange = self.contentText.selectedRange;
    
    if ([self.contentText.text length] > 0) {
        self.placeholderLab.text = @"";
        self.placeholderLab.alpha = 0.0;
    }
    else
    {
        self.placeholderLab.text = @"正文，8000个字以内";
        self.placeholderLab.alpha = 1.0;
    }
    
    if (self.contentText.text.length > numm) {
        if (jiacu == YES) {
            if (xieti == YES) {
                if (xiahuaxian == YES) {
                    self.editziti.type = [NSString stringWithFormat:@"cuxiexian%d",self.editziti.zihao];
                    
                    if ([self.editziti.type isEqualToString:zititype] ) {
                        //
                    }
                    else
                    {
                        if (firstchange == YES) {
                            //
                            NSString *s = [self.contentText.text substringWithRange:NSMakeRange(self.contentText.text.length-1, 1)];
                            const char *cString=[s UTF8String];
                            if (strlen(cString)==3){
                                
                                firstchange = NO;
                            }
                            else
                            {
                                //
                            }
                            
                        }
                        else
                        {
                            CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
                            UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont boldSystemFontOfSize :self.editziti.zihao ]. fontName matrix :matrix];
                            UIFont *font = [ UIFont fontWithDescriptor :desc size :self.editziti.zihao];
                            
                            NSMutableAttributedString *labelText = [self.contentText.attributedText mutableCopy];
                            NSDictionary *attr = @{NSFontAttributeName:font,
                                                   NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
                            [labelText addAttributes:attr range:NSMakeRange(numm, self.contentText.text.length-numm)];
                            self.contentText.attributedText = labelText;
                            zititype = self.editziti.type;
                            
                            
                        }
                        
                    }
                    
                }
                else
                {
                    self.editziti.type = [NSString stringWithFormat:@"cuxie%d",self.editziti.zihao];
                    
                    if ([self.editziti.type isEqualToString: zititype]) {
                        //
                    }
                    else
                    {
                        if (firstchange == YES) {
                            NSString *s = [self.contentText.text substringWithRange:NSMakeRange(self.contentText.text.length-1, 1)];
                            const char *cString=[s UTF8String];
                            if (strlen(cString)==3){
                                firstchange = NO;
                            }
                            else
                            {
                                //
                            }
                        }
                        else
                        {
                            //                    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
                            //                    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont boldSystemFontOfSize :self.editziti.zihao ]. fontName matrix :matrix];
                            //                    UIFont *font = [ UIFont fontWithDescriptor :desc size :self.editziti.zihao];
                            NSMutableAttributedString *labelText = [self.contentText.attributedText mutableCopy];
                            
                            NSDictionary *attr = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-BoldOblique" size:self.editziti.zihao],
                                                   NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)};
                            [labelText addAttributes:attr range:NSMakeRange(numm, self.contentText.text.length-numm)];
                            self.contentText.attributedText = labelText;
                            zititype = self.editziti.type;
                            
                            
                        }
                        
                    }
                    
                }
            }
            else
            {
                if (xiahuaxian == YES) {
                    self.editziti.type = [NSString stringWithFormat:@"cuxian%d",self.editziti.zihao];
                    
                    if ([self.editziti.type isEqualToString: zititype]) {
                        //
                    }
                    else
                    {
                        if (firstchange == YES) {
                            NSString *s = [self.contentText.text substringWithRange:NSMakeRange(self.contentText.text.length-1, 1)];
                            const char *cString=[s UTF8String];
                            if (strlen(cString)==3){
                                firstchange = NO;
                            }
                            else
                            {
                                //
                            }
                        }
                        else
                        {
                            CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(0 * (CGFloat)M_PI / 180), 1, 0, 0);
                            UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont boldSystemFontOfSize :self.editziti.zihao ]. fontName matrix :matrix];
                            UIFont *font = [ UIFont fontWithDescriptor :desc size :self.editziti.zihao];
                            
                            NSMutableAttributedString *labelText = [self.contentText.attributedText mutableCopy];
                            NSDictionary *attr = @{NSFontAttributeName:font,
                                                   NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
                            [labelText addAttributes:attr range:NSMakeRange(numm, self.contentText.text.length-numm)];
                            self.contentText.attributedText = labelText;
                            zititype = self.editziti.type;
                            
                            
                        }
                        
                    }
                    
                    
                }
                else
                {
                    self.editziti.type = [NSString stringWithFormat:@"cu%d",self.editziti.zihao];
                    if ([self.editziti.type isEqualToString: zititype]) {
                        //
                    }
                    else
                    {
                        if (firstchange == YES) {
                            NSString *s = [self.contentText.text substringWithRange:NSMakeRange(self.contentText.text.length-1, 1)];
                            const char *cString=[s UTF8String];
                            if (strlen(cString)==3){
                                firstchange = NO;
                            }
                            else
                            {
                                //
                            }
                        }
                        else
                        {
                            CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(0 * (CGFloat)M_PI / 180), 1, 0, 0);
                            UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName :[ UIFont boldSystemFontOfSize :self.editziti.zihao ]. fontName matrix :matrix];
                            UIFont *font = [ UIFont fontWithDescriptor :desc size :self.editziti.zihao];
                            
                            NSMutableAttributedString *labelText = [self.contentText.attributedText mutableCopy];
                            NSDictionary *attr = @{NSFontAttributeName:font,
                                                   NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)};
                            [labelText addAttributes:attr range:NSMakeRange(numm, self.contentText.text.length-numm)];
                            self.contentText.attributedText = labelText;
                            zititype = self.editziti.type;
                            
                            
                        }
                        
                    }
                    
                }
            }
        }
        else
        {
            if (xieti == YES) {
                if (xiahuaxian == YES) {
                    self.editziti.type = [NSString stringWithFormat:@"xiexian%d",self.editziti.zihao];
                    if ([self.editziti.type isEqualToString: zititype]) {
                        //
                    }
                    else
                    {
                        if (firstchange == YES) {
                            NSString *s = [self.contentText.text substringWithRange:NSMakeRange(self.contentText.text.length-1, 1)];
                            const char *cString=[s UTF8String];
                            if (strlen(cString)==3){
                                firstchange = NO;
                            }
                            else
                            {
                                //
                            }
                        }
                        else
                        {
                            //                    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
                            //                    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont italicSystemFontOfSize :self.editziti.zihao ]. fontName matrix :matrix];
                            //                    UIFont *font = [ UIFont fontWithDescriptor :desc size :self.editziti.zihao];
                            
                            NSMutableAttributedString *labelText = [self.contentText.attributedText mutableCopy];
                            NSDictionary *attr = @{NSFontAttributeName:[UIFont italicSystemFontOfSize:self.editziti.zihao],
                                                   NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
                            [labelText addAttributes:attr range:NSMakeRange(numm, self.contentText.text.length-numm)];
                            self.contentText.attributedText = labelText;
                            zititype = self.editziti.type;
                            
                        }
                        
                    }
                    
                }
                else
                {
                    self.editziti.type = [NSString stringWithFormat:@"xie%d",self.editziti.zihao];
                    //                    currentRange = self.contentText.selectedRange;
                    if ([self.editziti.type isEqualToString: zititype]) {
                        //
                    }
                    else
                    {
                        if (firstchange == YES) {
                            NSString *s = [self.contentText.text substringWithRange:NSMakeRange(self.contentText.text.length-1, 1)];
                            const char *cString=[s UTF8String];
                            if (strlen(cString)==3){
                                firstchange = NO;
                            }
                            else
                            {
                                //
                            }
                        }
                        else
                        {
                            //                    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
                            //                    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont italicSystemFontOfSize :self.editziti.zihao ]. fontName matrix :matrix];
                            //                    UIFont *font = [ UIFont fontWithDescriptor :desc size :self.editziti.zihao];
                            
                            NSMutableAttributedString *labelText = [self.contentText.attributedText mutableCopy];
                            NSDictionary *attr = @{NSFontAttributeName:[UIFont italicSystemFontOfSize:self.editziti.zihao],
                                                   NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)};
                            [labelText addAttributes:attr range:NSMakeRange(numm, self.contentText.text.length-numm)];
                            self.contentText.attributedText = labelText;
                            zititype = self.editziti.type;
                            
                        }
                        
                    }
                    
                    
                }
            }
            else
            {
                if (xiahuaxian == YES) {
                    self.editziti.type = [NSString stringWithFormat:@"xian%d",self.editziti.zihao];
                    if ([self.editziti.type isEqualToString: zititype]) {
                        //
                    }
                    else
                    {
                        
                        if (firstchange == YES) {
                            //
                            NSString *s = [self.contentText.text substringWithRange:NSMakeRange(self.contentText.text.length-1, 1)];
                            const char *cString=[s UTF8String];
                            if (strlen(cString)==3){
                                firstchange = NO;
                            }
                            else
                            {
                                //
                            }
                        }
                        else
                        {
                            CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(0 * (CGFloat)M_PI / 180), 1, 0, 0);
                            UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :self.editziti.zihao ]. fontName matrix :matrix];
                            UIFont *font = [ UIFont fontWithDescriptor :desc size :self.editziti.zihao];
                            
                            NSMutableAttributedString *labelText = [self.contentText.attributedText mutableCopy];
                            NSDictionary *attr = @{NSFontAttributeName:font,
                                                   NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
                            [labelText addAttributes:attr range:NSMakeRange(numm, self.contentText.text.length-numm)];
                            self.contentText.attributedText = labelText;
                            zititype = self.editziti.type;
                            
                        }
                        
                    }
                    
                }
                else
                {
                    self.editziti.type = [NSString stringWithFormat:@"nil%d",self.editziti.zihao];
                    if ([self.editziti.type isEqualToString:zititype] ) {
                        //
                    }
                    else
                    {
                        if (firstchange == YES) {
                            //
                            NSString *s = [self.contentText.text substringWithRange:NSMakeRange(self.contentText.text.length-1, 1)];
                            const char *cString=[s UTF8String];
                            if (strlen(cString)==3){
                                firstchange = NO;
                            }
                            else
                            {
                                //
                            }
                        }
                        else
                        {
                            CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(0 * (CGFloat)M_PI / 180), 1, 0, 0);
                            UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :self.editziti.zihao ]. fontName matrix :matrix];
                            UIFont *font = [ UIFont fontWithDescriptor :desc size :self.editziti.zihao];
                            
                            NSMutableAttributedString *labelText = [self.contentText.attributedText mutableCopy];
                            NSDictionary *attr = @{NSFontAttributeName:font,
                                                   NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)};
                            [labelText addAttributes:attr range:NSMakeRange(numm, self.contentText.text.length-numm)];
                            self.contentText.attributedText = labelText;
                            zititype = self.editziti.type;
                            
                        }
                        
                    }
                    
                }
            }
        }
    }

}


#pragma mark - 点击确定选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //发送图片到数据库得到url
    
    //方法1，用原图
    UIImage *Photo = info[UIImagePickerControllerOriginalImage];//原图
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    [manager POST:API_UploadContentPic parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        UIImage *image = Photo;
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:data name:@"img" fileName:fileName mimeType:@"image/png"];
    } completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            NSString *imgUrl = [NSString stringWithFormat:@"<img src=\"%@\"/>",dic[@"picurl"]];
            NSString *imgu = [imgUrl stringByReplacingOccurrencesOfString:@"http://localhost/tuanda_web/Public" withString:@"http://static.juwairen.net"];
            
            [self.upimgArr addObject:imgu];
        }
    }];
    
    //方法2，得到数据库中的地址来存放图片
    //    NSString *imgurl = @"http://q.qlogo.cn/qqapp/101266993/DCA4CFB9A7D63D39BDC451E0822CE3BC/100";
    //    NSString *img = [NSString stringWithFormat:@"<img scr='%@'>",imgurl];
    //    [self.upimgArr addObject:img];
    //    NSLog(@"%@",img);
    //
    //    NSURL *url = [NSURL URLWithString:imgurl];
    //    UIImage *Photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentText.attributedText];
    PhotoTextAttachment *textAttachment = [[PhotoTextAttachment alloc]init];
    if (Photo.size.width >kScreenWidth) {
        textAttachment.photoSize = CGSizeMake(kScreenWidth-16 , (kScreenWidth-16)/Photo.size.width*Photo.size.height);
    }
    else
    {
        textAttachment.photoSize = Photo.size;
    }
    
    currentRange = self.contentText.selectedRange;
    [self.imglocArr addObject:@(currentRange.location)];
    textAttachment.image = Photo; //要添加的图片
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [string insertAttributedString:textAttachmentString atIndex:currentRange.location];//index为用户指定要插入图片的位置
    //    NSAttributedString *imgtext = [[NSAttributedString alloc]initWithString:img];
    //    [string insertAttributedString:imgtext atIndex:currentRange.location];
    
    self.contentText.attributedText = string;
    [self.contentText becomeFirstResponder];
    self.contentText.selectedRange = NSMakeRange(currentRange.location+1, currentRange.length);
    
}

#pragma mark - 点击发布
- (void)clickPublish:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([self.titleText.text isEqualToString:@""]) {
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.labelText = @"标题不能为空";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [hud hide:YES afterDelay:0.1f];
        }];
        return ;
    }
    else if ([self.contentText.text isEqualToString:@""]){
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.labelText = @"内容不能为空";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [hud hide:YES afterDelay:0.1f];
        }];
        return ;
    }
    else
    {
        [self publishView];
    }
}

#pragma mark - 保存草稿
- (void)saveDrafts{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"保存中...";
    
    NSMutableAttributedString *up = [self.contentText.attributedText mutableCopy];
    NSUInteger cur = 0;
    
    for (int i = 0 ; i<self.upimgArr.count; i++) {
        NSString *str = self.imglocArr[i];
        NSUInteger loc = [str integerValue];
        if (i != 0) {
            cur = [self.upimgArr[i-1] length] + cur;
        }
        NSUInteger current = loc+cur;
        NSAttributedString *imgtext = [[NSAttributedString alloc]initWithString:self.upimgArr[i]];
        [up insertAttributedString:imgtext atIndex:current];
        
    }
    
    NSString *htmlstring = [self htmlStringByHtmlAttributeString:up];
    htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *para ;
    if (self.tagsArr.count == 0) {
        para = @{@"userid":US.userId,
                 @"isOrigin":isoriginal,
                 @"title":self.titleText.text,
                 @"is_publish":@"0",
                 @"viewcontent":htmlstring,
                 };
    }
    else
    {
        NSString *tags = [self.tagsArr componentsJoinedByString:@"#"];
        para = @{@"userid":US.userId,
                 @"isOrigin":isoriginal,
                 @"title":self.titleText.text,
                 @"is_publish":@"0",
                 @"viewcontent":htmlstring,
                 @"tags":tags
                 };
    }
    
    [manager POST:API_PushViewDo1_2 parameters:para completion:^(id data, NSError *error){
        if (!error) {
            hud.labelText = @"保存成功";
            [hud hide:YES afterDelay:1];
        } else {
            hud.labelText = @"保存失败";
            [hud hide:YES afterDelay:1];
        }
    }];
}

#pragma mark - 发布文章
- (void)publishView{
    [self.SelSecView removeFromSuperview];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发布中...";
    
    NSMutableAttributedString *up = [self.contentText.attributedText mutableCopy];
    NSUInteger cur = 0;
    
    for (int i = 0 ; i<self.upimgArr.count; i++) {
        NSString *str = self.imglocArr[i];
        NSUInteger loc = [str integerValue];
        if (i != 0) {
            cur = [self.upimgArr[i-1] length] + cur;
        }
        NSUInteger current = loc+cur;
        NSAttributedString *imgtext = [[NSAttributedString alloc]initWithString:self.upimgArr[i]];
        [up insertAttributedString:imgtext atIndex:current];
        
    }
    
    //    转成NSData再存入plist
    //    NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0];  //获得沙箱的 Document 的地址
    //    NSString *pathFile = [path stringByAppendingPathComponent:@"text"];
    //    NSData *data = [labelText dataFromRange:NSMakeRange(0, labelText.length) documentAttributes:@{NSDocumentTypeDocumentAttribute:NSRTFDTextDocumentType} error:nil];//将NSAttributedString转成NSData;
    //    NSLog(@"%@",data);
    
    NSString *htmlstring = [self htmlStringByHtmlAttributeString:up];
    htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    
    NSDictionary *para ;
    if (self.tagsArr.count == 0) {
        para = @{@"userid":US.userId,
                 @"isOrigin":isoriginal,
                 @"title":self.titleText.text,
                 @"is_publish":@"1",
                 @"viewcontent":htmlstring,
                 };
    }
    else
    {
        NSString *tags = [self.tagsArr componentsJoinedByString:@"#"];
        para = @{@"userid":US.userId,
                 @"isOrigin":isoriginal,
                 @"title":self.titleText.text,
                 @"is_publish":@"1",
                 @"viewcontent":htmlstring,
                 @"tags":tags
                 };
    }
    
    [manager POST:API_PushViewDo1_2 parameters:para completion:^(id data, NSError *error){
        if (!error) {
            
            hud.labelText = @"发布成功";
            hud.mode = MBProgressHUDModeText;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [hud hide:YES afterDelay:1.0f];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            
        } else {
            hud.labelText = @"发布失败";
            [hud hide:YES afterDelay:1];
        }
    }];
    
}

/** 将富文本格式化为超文本*/
- (NSString *)htmlStringByHtmlAttributeString:(NSAttributedString *)htmlAttributeString{
    NSString *htmlString;
    
    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                   NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    
    NSData *htmlData = [htmlAttributeString dataFromRange:NSMakeRange(0, htmlAttributeString.length) documentAttributes:exportParams error:nil];
    htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"pt" withString:@"px"];
    
    return htmlString;
}

/** 将超文本格式化为富文本*/
-(NSAttributedString *)attributedStringWithHtml:(NSString *)html
{
    html = [html stringByReplacingOccurrencesOfString:@"pt" withString:@"px"];
    
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:options documentAttributes:nil error:nil];
    return attrString;
}

//获取htmlString中的所有图片URL
- (NSArray *) getImageurlFromHtml:(NSString *) webString
{
    NSMutableArray * imageurlArray = [NSMutableArray arrayWithCapacity:1];
    
    //标签匹配
    NSString *parten = @"<img(.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSArray* match = [reg matchesInString:webString options:0 range:NSMakeRange(0, [webString length] - 1)];
    
    for (NSTextCheckingResult * result in match) {
        
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [webString substringWithRange:range];
        
        
        //从图片中的标签中提取ImageURL
        //        NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"http://(.*?)\"" options:0 error:NULL];
        //        NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
        //        NSTextCheckingResult * subRes = match[0];
        //        NSRange subRange = [subRes range];
        //        subRange.length = subRange.length -1;
        //        NSString * imagekUrl = [subString substringWithRange:subRange];
        //        NSString *imgUrl = [NSString stringWithFormat:@"<img src=\"%@\"/>",imagekUrl];
        
        //将提取出的图片URL添加到图片数组中
        [imageurlArray addObject:subString];
    }
    
    return imageurlArray;
}

/** 定位html中图片的位置*/
- (NSArray *)getImageRangFromHtml:(NSString *)htmlstring andWithArr:(NSArray *)imgarr{
    //把url标签替换成图片
    for (int i = 0; i<imgarr.count; i++) {
        htmlstring = [htmlstring stringByReplacingOccurrencesOfString:imgarr[i] withString:@"[图片]"];
    }
    NSAttributedString *tupianAtt = [self attributedStringWithHtml:htmlstring];
    NSString *tp = tupianAtt.string;
    NSArray *rangArr = [self rangeOfSymbolString:@"[图片]" inString:tp];
    
    return rangArr;
}

/** 统计文本中所有图片资源标志的range*/
- (NSArray *)rangeOfSymbolString:(NSString *)symbol inString:(NSString *)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString *string1 = [string stringByAppendingString:symbol];
    NSString *temp;
    int n = 0;
    for (int i = 0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, symbol.length)];
        if ([temp isEqualToString:symbol]) {
            NSRange range = {i, symbol.length};
            
            float m = n * (symbol.length-1);
            [rangeArray addObject:@(range.location-m)];
            
            n++;
        }
    }
    return rangeArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//计算textview内容高度
- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float textHeight = textView.contentSize.height + kScreenHeight/2;
    return textHeight;
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

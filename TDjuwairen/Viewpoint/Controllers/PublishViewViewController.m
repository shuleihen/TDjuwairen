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

#import "NSString+Ext.h"

@interface PublishViewViewController ()<UITextViewDelegate,BottomEditDelegate,SecondEditDelegate>
{
    NSString *currentTitle;
    NSString *currentDesc;
    BOOL jiacu;
    BOOL xieti;
    BOOL xiahuaxian;
}

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) UIScrollView *scrollview;

@property (nonatomic,strong) UITextField *titleText;
@property (nonatomic,strong) UIButton *originalBtn;
@property (nonatomic,strong) UILabel *placeholderLab;
@property (nonatomic,strong) UITextView *contentText;
@property (nonatomic,strong) BottomEdit *bottomView;
@property (nonatomic,strong) SecondEdit *secondView;

@property (nonatomic,strong) UIView *SelSecView;

@end

@implementation PublishViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
    [self setupWithNavigation];
    [self setupWithScrollview];
    [self setupWithTitleText];
    [self setupWithContentText];
    
    self.scrollview.contentSize = CGSizeMake(kScreenWidth, self.titleText.frame.size.height+self.contentText.frame.size.height);
    [self setupWithEdit];
}

- (void)setupWithNavigation{
    self.edgesForExtendedLayout = UIRectEdgeNone;    //iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方
    
    //设置navigation背景色
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundColor:self.daynightmodel.navigationColor];
    [self.navigationController.navigationBar setBarTintColor:self.daynightmodel.navigationColor];
    
    //设置右边发布按钮
    UIBarButtonItem *regist = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(clickPublish:)];
    self.navigationItem.rightBarButtonItem = regist;
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,30)];
    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupWithScrollview{
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    
    self.scrollview.backgroundColor = self.daynightmodel.backColor;
    [self.view addSubview:self.scrollview];
}

- (void)setupWithTitleText{
    self.titleText = [[UITextField alloc]initWithFrame:CGRectMake(-1, 0, kScreenWidth+2, 40)];
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
    
    self.titleText.font = [UIFont systemFontOfSize:16];
    self.titleText.textColor = self.daynightmodel.textColor;
    
    self.titleText.layer.borderWidth = 1;
    self.titleText.layer.borderColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0].CGColor;
    
    self.originalBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-80, 0, 40, 40)];
    [self.originalBtn setImage:[UIImage imageNamed:@"btn_select@3x.png"] forState:UIControlStateNormal];
    [self.originalBtn setImage:[UIImage imageNamed:@"btn_select_pre@3x.png"] forState:UIControlStateSelected];
    [self.originalBtn addTarget:self action:@selector(isOriginal:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *originalLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-40, 0, 40, 40)];
    originalLabel.text = @"原创";
    originalLabel.textColor = self.daynightmodel.titleColor;
    
    [self.scrollview addSubview:self.titleText];
    [self.scrollview addSubview:self.originalBtn];
    [self.scrollview addSubview:originalLabel];
}

- (void)setupWithContentText{
    self.contentText = [[UITextView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-64-40)];
    self.contentText.textContainerInset = UIEdgeInsetsMake(8, 4, 8, 4);
    self.contentText.backgroundColor = self.titleText.backgroundColor;
    self.contentText.font = [UIFont systemFontOfSize:14];
    self.contentText.textColor = self.daynightmodel.textColor;
    self.contentText.delegate = self;

    self.placeholderLab = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, kScreenWidth/2, 20)];
    self.placeholderLab.text = @"正文，8000个字以内";
    self.placeholderLab.textColor = self.daynightmodel.titleColor;
    self.placeholderLab.font = [UIFont systemFontOfSize:14];
    
    [self.scrollview addSubview:self.contentText];
    [self.contentText addSubview:self.placeholderLab];
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
        [self.tabBarController.tabBar setHidden:NO];
    }];
    
    UIAlertAction *giveup = [UIAlertAction actionWithTitle:@"放弃编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self.navigationController popViewControllerAnimated:YES];
        [self.tabBarController.tabBar setHidden:NO];
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

#pragma mark - 点击发布
- (void)clickPublish:(UIButton *)sender{
    
}

#pragma mark - 是否原创 
- (void)isOriginal:(UIButton *)sender{
    if (sender.selected == YES) {
        sender.selected = NO;
    }
    else
    {
        sender.selected = YES;
    }
}

#pragma mark - 点击编辑栏
- (void)clickEdit:(UIButton *)sender
{
    int num = (int)sender.tag;
    if (num == 0) {
        if ([self.titleText isFirstResponder] || [self.contentText isFirstResponder]) {
            [self.view endEditing:YES];
        }
        else
        {
            [self.titleText becomeFirstResponder];
        }
    }
    else if(num == 1){
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
        if ([self.titleText isFirstResponder]) {
            self.titleText.text = currentTitle;
        }
        else
        {
            self.contentText.text = currentDesc;
        }
    }
    else if (num ==3){
        [self.SelSecView removeFromSuperview];
        //字体设置
        self.secondView = [[SecondEdit alloc]initWithFrame:CGRectMake(0, self.bottomView.frame.origin.y-40, kScreenWidth, 40)];
        self.secondView.delegate = self;
        self.SelSecView = self.secondView;
        
        [self.view addSubview:self.secondView];
    }
    else if (num == 4){
        [self.SelSecView removeFromSuperview];//移除子视图
        //插入
        NSArray *imgArr = @[@"btn_lianjie@3x.png",@"btn_img@3x.png",@"btn_biaoqian"];
        NSArray *textArr = @[@"链接",@"图片",@"股票"];
        self.secondView = [[SecondEdit alloc]initWithFrame:CGRectMake(0, self.bottomView.frame.origin.y-40, kScreenWidth, 40) andImgArr:imgArr andTextArr:textArr];
        self.secondView.delegate = self;
        self.SelSecView = self.secondView;
        
        [self.view addSubview:self.secondView];
    }
    else {
        [self.SelSecView removeFromSuperview];//移除子视图
        //更多
        NSArray *imgArr = @[@"tab_yulan@3x.png",@"tab_caogao@3x.png"];
        NSArray *textArr = @[@"预览",@"存为草稿"];
        self.secondView = [[SecondEdit alloc]initWithFrame:CGRectMake(0, self.bottomView.frame.origin.y-40, kScreenWidth, 40) andImgArr:imgArr andTextArr:textArr];
        self.secondView.delegate = self;
        self.SelSecView = self.secondView;
        
        [self.view addSubview:self.secondView];
    }
}

#pragma mark - 子视图
- (void)selectFont:(UIButton *)sender
{
    int num = (int)sender.tag;
    if (num == 0) {
        NSLog(@"加粗");
        if (sender.selected == YES) {
            jiacu = YES;
        }
        else
        {
            jiacu = NO;
        }
        if ([self.titleText isFirstResponder]) {
            if (sender.selected == YES) {
                if (xieti == YES) {
                    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
                    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[UIFont boldSystemFontOfSize:16]. fontName matrix :matrix];
                    
                    UIFont *font = [ UIFont fontWithDescriptor :desc size :16];
                    self.titleText.font = font;
                }
                else
                {
                    self.titleText.font = [UIFont boldSystemFontOfSize:16];
                }
            }
            else
            {
                if (xieti == YES) {
                    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
                    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :16 ]. fontName matrix :matrix];
                    
                    UIFont *font = [ UIFont fontWithDescriptor :desc size :16];
                    
                    self.titleText.font = font;
                }
                else
                {
                    self.titleText.font = [UIFont systemFontOfSize:16];
                }
            }
        }
        else
        {
            self.contentText.font = [UIFont boldSystemFontOfSize:14];
        }
    }
    else if (num == 1)
    {
        NSLog(@"倾斜");
        if (sender.selected == YES) {
            xieti = YES;
        }
        else
        {
            xieti = NO;
        }
        if ([self.titleText isFirstResponder]) {
            if (sender.selected == YES) {
                if (jiacu == YES) {
                    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
                    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[UIFont boldSystemFontOfSize:16]. fontName matrix :matrix];
                    
                    UIFont *font = [ UIFont fontWithDescriptor :desc size :16];
                    self.titleText.font = font;
                }
                else
                {
                    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
                    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :16 ]. fontName matrix :matrix];
                    
                    UIFont *font = [ UIFont fontWithDescriptor :desc size :16];
                                                                     
                    self.titleText.font = font;
                }
            }
            else
            {
                if (jiacu == YES) {
                    self.titleText.font = [UIFont boldSystemFontOfSize:16];
                }
                else
                {
                    self.titleText.font = [UIFont systemFontOfSize:16];
                }
            }
        }
        else
        {
            self.contentText.font = [UIFont boldSystemFontOfSize:16];
        }
    }
    else if (num == 2)
    {
        NSLog(@"下划线");
        if (sender.selected == YES) {
            xiahuaxian = YES;
        }
        else
        {
            xiahuaxian = NO;
        }
        if ([self.titleText isFirstResponder]) {
            if (sender.selected == YES)
            {
                //下划线
                NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.titleText.text attributes:attribtDic];
                self.titleText.attributedText = attribtStr;
            }
            else
            {
                //下划线
                NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleNone]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.titleText.text attributes:attribtDic];
                self.titleText.attributedText = attribtStr;
            }
        }
        else
        {
            if (sender.selected == YES)
            {
                //下划线
                NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.titleText.text attributes:attribtDic];
                self.titleText.attributedText = attribtStr;
            }
            else
            {
                //下划线
                NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleNone]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.titleText.text attributes:attribtDic];
                self.titleText.attributedText = attribtStr;
            }
        }
    }
    else if (num ==3)
    {
        NSLog(@"引用");
    }
    else if (num == 4)
    {
        NSLog(@"16");
    }
    else if (num == 5)
    {
        NSLog(@"15");
    }
    else if (num == 6)
    {
        NSLog(@"14");
    }
    else if (num == 7)
    {
        NSLog(@"13");
    }
    else
    {
        NSLog(@"12");
    }
}

- (void)clickSecBtn:(LeftRightBtn *)sender
{
    int num = (int)sender.tag;
    if (num == 0) {
        NSLog(@"%@",sender.textLabel.text);
    }
    else{
        NSLog(@"%@",sender.textLabel.text);
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
    [self beginMoveUpAnimation:kbSize.height];
}

- (void)keyboardWillBeHidden{
    [UIView animateWithDuration:0.1 animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
        self.scrollview.transform = CGAffineTransformIdentity;
    }];
}

- (void)beginMoveUpAnimation:(CGFloat )height{
    [UIView animateWithDuration:0.1 animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -height);
        self.scrollview.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self registerForKeyboardNotifications];
    [self.titleText becomeFirstResponder];
    
}

#pragma mark - textView delegate
-(void)textViewDidChange:(UITextView *)textView
{
    if ([self.contentText.text length] > 0) {
        self.placeholderLab.text = @"";
        self.placeholderLab.alpha = 0.0;
    }
    else
    {
        self.placeholderLab.text = @"正文，8000个字以内";
        self.placeholderLab.alpha = 1.0;
    }
    
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

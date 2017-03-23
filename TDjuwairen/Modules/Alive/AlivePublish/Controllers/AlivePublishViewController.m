//
//  AlivePublishViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AlivePublishViewController.h"
#import "HexColors.h"
#import "UITextView+Placeholder.h"
#import "ImagePickerHandler.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "NotificationDef.h"
#import "AliveListModel.h"
#import "SearchCompanyListTableView.h"
#import "SearchCompanyListModel.h"

@interface AlivePublishViewController ()<UITextViewDelegate, ImagePickerHanderlDelegate, MBProgressHUDDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *stockIdTextField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) ImagePickerHandler *imagePicker;
@property (nonatomic, strong) NSString *stockId;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *textFieldPlaceholder;
@property (strong, nonatomic) SearchCompanyListTableView *companyListTableView;

@end

@implementation AlivePublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.isTiedan) {
        self.title = @"发布贴单";
        self.textFieldPlaceholder = @"填写买入卖出理由或其他";
    } else {
        self.title = @"发布动态";
        self.textFieldPlaceholder = @"写点什么吧...";
    }
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:self.isTiedan?@"推单":@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishPressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSBackgroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSBackgroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                         forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
    
    self.imageArray = [NSMutableArray arrayWithCapacity:9];
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.scrollEnabled = NO;
    
    [self setupFooterView];
    [self checkRightBarItemEnabled];
    self.companyListTableView = [[SearchCompanyListTableView alloc] initWithSearchCompanyListTableViewWithFrame:CGRectMake(85, 44, kScreenWidth-97, 0)];

    __weak typeof(self)weakSelf = self;
    self.companyListTableView.choiceCode = ^(NSString *str){
       weakSelf.stockIdTextField.text = str;
        weakSelf.stockId = str;
        [weakSelf checkRightBarItemEnabled];
        
    };
    [self.tableView addSubview:self.companyListTableView];
    
}

- (UITextField *)stockIdTextField {
    if (!_stockIdTextField) {
        _stockIdTextField = [[UITextField alloc] init];
        _stockIdTextField.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _stockIdTextField.font = [UIFont systemFontOfSize:15.0f];
        _stockIdTextField.placeholder = @"请输入股票代码";
        _stockIdTextField.keyboardType = UIKeyboardTypeNumberPad;
        _stockIdTextField.delegate = self;
        [_stockIdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _stockIdTextField;
}

- (ImagePickerHandler *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[ImagePickerHandler alloc] initWithDelegate:self];
    }
    return _imagePicker;
}

- (void)setupFooterView {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth-30, 137)];
    textView.placeholder = self.textFieldPlaceholder;
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.text = self.reason;
    [footerView addSubview:textView];
    
    __block CGFloat offx = 15,offy=154,height=0;
    CGFloat itemSize = 80;
    CGFloat margin = 8;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.imageArray];
    [array addObject:[UIImage imageNamed:@"alive_addphoto.png"]];
    
    [array enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop){
        
        CGRect rect = CGRectMake(offx, offy, itemSize, itemSize);
        if (idx >= 9) {
            *stop = YES;
            return;
        }
        
        if (idx == (array.count - 1)) {
            UIButton *add = [[UIButton alloc] initWithFrame:rect];
            [add setImage:image forState:UIControlStateNormal];
            [add addTarget:self action:@selector(addPressed:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:add];
            [footerView sendSubviewToBack:add];
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = rect;
            [footerView addSubview:imageView];
            [footerView sendSubviewToBack:imageView];
            
            UIButton *cancel = [[UIButton alloc] init];
            [cancel setImage:[UIImage imageNamed:@"btn_del.png"] forState:UIControlStateNormal];
            cancel.frame = CGRectMake(CGRectGetMaxX(rect)-10, CGRectGetMinY(rect)-10, 20, 20);
            cancel.tag = idx;
            [cancel addTarget:self action:@selector(delPressed:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:cancel];
        }
        
        if ((CGRectGetMaxX(rect) + margin + itemSize + 15) <= kScreenWidth) {
            offx = CGRectGetMaxX(rect) + margin;
        } else {
            offx = 15;
            offy += (itemSize+margin);
        }
        
        height = CGRectGetMaxY(rect);
    }];
    
    footerView.frame = CGRectMake(0, 0, kScreenWidth, height+15);
    self.tableView.tableFooterView = footerView;
}

- (void)checkRightBarItemEnabled {
    
    if (self.isTiedan) {
        NSString *stockId = [self.stockIdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.navigationItem.rightBarButtonItem.enabled = (stockId.length&&self.reason.length);
    } else {
        self.navigationItem.rightBarButtonItem.enabled = self.reason.length;
    }
}

- (NSString *)imageNameWithIndex:(NSInteger)index {
    
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%ld", US.userId, str, (long)index];
    return fileName;
}

- (void)addPressed:(UIButton *)sendr {
    if (self.isTiedan && self.companyListTableView.hidden == NO) {
        self.companyListTableView.hidden = YES;
    }
    
    [self.imagePicker showImagePickerInController:self withLimitSelectedCount:(9-self.imageArray.count)];
}

- (void)delPressed:(UIButton *)sender {
    NSInteger row = sender.tag;
    if (row>=0 && row < self.imageArray.count) {
        [self.imageArray removeObjectAtIndex:row];
        
        [self setupFooterView];
    }
}

- (void)publishPressed:(id)sender {
    if (!self.reason.length) {
        return;
    }
    
    if (self.isTiedan && self.companyListTableView.hidden == NO) {
        self.companyListTableView.hidden = YES;
    }
    
    self.stockId = [self.stockIdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!self.isTiedan && !self.stockId) {
        return;
    }
    
    [self.view endEditing:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSDictionary *dict = @{@"alive_type": self.isTiedan?@"2":@"1",
                           @"content": self.reason,
                           @"stock": self.stockId?:@""};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中";
    
    __weak AlivePublishViewController *wself = self;
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_AliveAddRoomPublish parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for(int i=0;i<wself.imageArray.count;i++) {
            UIImage *image = wself.imageArray[i];
            NSData *data = UIImageJPEGRepresentation(image, 1);
            NSString *name = [wself imageNameWithIndex:i];
            NSString *fileName = [name stringByAppendingString:@".jpg"];
            
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpg"];
        }
        
    } completion:^(id data, NSError *error) {
        wself.navigationItem.rightBarButtonItem.enabled = YES;
        
        if (!error) {
            hud.labelText = @"提交成功";
            hud.delegate = self;
            [hud hide:YES afterDelay:1];
        } else {
            hud.labelText = @"提交失败";
            [hud hide:YES afterDelay:1];
        }
    }];

}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ImagePickerHanderlDelegate
- (void)imagePickerHanderl:(ImagePickerHandler *)imagePicker didFinishPickingImages:(NSArray *)images {
    [self.imageArray addObjectsFromArray:images];
    [self setupFooterView];
}


#pragma mark - loadCompanyList
- (void)loadCompanyListData:(NSString *)textStr {

    NSDictionary *dict = @{@"keyword":textStr};
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_ViewSearchCompnay parameters:dict completion:^(id data, NSError *error) {
        if (!error) {
            NSArray *dataArray = data;
            NSMutableArray *resultModelArrM = [NSMutableArray array];
            for (NSDictionary *d in dataArray) {
                SearchCompanyListModel *model = [[SearchCompanyListModel alloc] initWithDictionary:d];
                [resultModelArrM addObject:model];
            }
            [self.companyListTableView configResultDataArr:[resultModelArrM mutableCopy] andRectY:44];
        }else{
            
            [self.companyListTableView configResultDataArr:[NSArray array] andRectY:44];
            
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (textField == self.stockIdTextField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField {
    self.stockId = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self checkRightBarItemEnabled];
    if (textField == self.stockIdTextField) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
            return;
        }
    }
    
    if (textField.text.length > 0) {
        
        [self loadCompanyListData:textField.text];
    }else {
    
        [self.companyListTableView configResultDataArr:[NSArray array] andRectY:44];
        
    }
    
    
    
}




#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.reason = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self checkRightBarItemEnabled];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    if (self.isTiedan && self.companyListTableView.hidden == NO) {
        self.companyListTableView.hidden = YES;
    }
}




#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FLT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isTiedan?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isTiedan?1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveStockCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AliveStockCellID"];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        cell.textLabel.frame = CGRectMake(15, 12, 70, 20);
        cell.textLabel.text = @"股票代码";
        
        self.stockIdTextField.frame = CGRectMake(85, 12, kScreenWidth-97, 20);
        [cell.contentView addSubview:self.stockIdTextField];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




@end

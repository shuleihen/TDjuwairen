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

@interface AlivePublishViewController ()<UITextViewDelegate, ImagePickerHanderlDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UITextField *stockIdTextField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) ImagePickerHandler *imagePicker;
@property (nonatomic, strong) NSString *stockId;
@property (nonatomic, strong) NSString *reason;
@end

@implementation AlivePublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.isTiedan) {
        self.title = @"发布贴单";
    } else {
        self.title = @"发布动态";
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
    
    [self setupFooterView];
    [self checkRightBarItemEnabled];
}

- (UITextField *)stockIdTextField {
    if (!_stockIdTextField) {
        _stockIdTextField = [[UITextField alloc] init];
        _stockIdTextField.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _stockIdTextField.font = [UIFont systemFontOfSize:15.0f];
        _stockIdTextField.placeholder = @"请输入股票代码";
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
    textView.placeholder = @"请填写买入卖出理由或其他";
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

- (NSString *)imageFileNameWithIndex:(NSInteger)index {
    
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", str,(long)index];
    return fileName;
}

- (void)addPressed:(UIButton *)sendr {
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
    
    self.stockId = [self.stockIdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!self.isTiedan && !self.stockId) {
        return;
    }
    
    [self.view endEditing:YES];
    
    NSDictionary *dict = @{@"alive_type": self.isTiedan?@"2":@"1",
                           @"content": self.reason,
                           @"stock": self.stockId?:@""};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中";
    
    __weak AlivePublishViewController *wself = self;
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_AliveAddRoomPublish parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [wself.imageArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop){
            NSData *data = UIImageJPEGRepresentation(image, 1);
            NSString *fileName = [wself imageFileNameWithIndex:idx];
            
            [formData appendPartWithFileData:data name:US.userId fileName:fileName mimeType:@"image/png"];
        }];
        
    } completion:^(id data, NSError *error) {
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

#pragma mark - UITextField
- (void)textFieldDidChange:(UITextField *)textField {
    self.stockId = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self checkRightBarItemEnabled];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.reason = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self checkRightBarItemEnabled];
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
    
    return cell;
}
@end

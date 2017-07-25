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
#import "AliveListForwardView.h"
#import "PublishSelectedStockCell.h"
#import "UIView+Border.h"

@interface AlivePublishViewController ()<UITextViewDelegate, ImagePickerHanderlDelegate, MBProgressHUDDelegate,UITextFieldDelegate,PublishSelectedStockCellDelegate>

@property (nonatomic, strong) UITextField *stockIdTextField;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) ImagePickerHandler *imagePicker;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *textFieldPlaceholder;
@property (strong, nonatomic) SearchCompanyListTableView *companyListTableView;
@property (nonatomic, strong) AliveListForwardView *forwardView;
@property (nonatomic, assign) NSInteger imageLimit;
@property (strong, nonatomic) NSMutableArray *selectedStockArrM;
/// 历史选择记录
@property (strong, nonatomic) NSMutableArray *historySelectedStockArrM;


@end

@implementation AlivePublishViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *rightButtonTitle = @"";
    
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    switch (self.publishType) {
        case kAlivePublishNormal:
            self.title = @"发布动态";
            self.textFieldPlaceholder = @"写点什么吧...";
            rightButtonTitle = @"发布";
            self.imageLimit = 9;
            break;
        case kAlivePublishPosts:
            self.title = @"发布推单";
            self.textFieldPlaceholder = @"填写买入卖出理由或其他";
            rightButtonTitle = @"推单";
            self.imageLimit = 9;
            break;
        case kAlivePublishForward:
        case kAlivePublishShare:
            self.title = @"转发直播";
            self.textFieldPlaceholder = @"写点分享心得吧...";
            rightButtonTitle = @"发布";
            self.imageLimit = 1;
            break;
        default:
            break;
    }
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:rightButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(publishPressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                         forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
    
    self.imageArray = [NSMutableArray arrayWithCapacity:9];
    
    self.selectedStockArrM = [NSMutableArray array];
    
#pragma mark - 获取本地存储的历史搜索记录
    NSArray *localArr = [SearchCompanyListModel loadLocalHistoryModel];
    if (localArr == nil) {
        self.historySelectedStockArrM = [NSMutableArray array];
    }else {
        self.historySelectedStockArrM = [NSMutableArray arrayWithArray:localArr];
    }
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView addSubview:self.companyListTableView];
    
    [self setupFooterView];
    [self checkRightBarItemEnabled];
    
}

- (SearchCompanyListTableView *)companyListTableView {
    if (!_companyListTableView) {
        _companyListTableView = [[SearchCompanyListTableView alloc] initWithSearchCompanyListTableViewWithFrame:CGRectZero];
        CGPoint p = [self.stockIdTextField convertPoint:self.stockIdTextField.frame.origin toView:self.view];
        _companyListTableView.frame = CGRectMake(85, p.y+20, kScreenWidth-97, 0);
        
        __weak typeof(self)weakSelf = self;
        _companyListTableView.choiceModel = ^(SearchCompanyListModel *model){
            weakSelf.stockIdTextField.text = @"";
            [weakSelf addSelectedStockObjectWithModel:model];
        };
    }
    return _companyListTableView;
}

- (UITextField *)stockIdTextField {
    if (!_stockIdTextField) {
        _stockIdTextField = [[UITextField alloc] init];
        _stockIdTextField.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _stockIdTextField.font = [UIFont systemFontOfSize:15.0f];
        _stockIdTextField.placeholder = @"请写股票代码，可多选";
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

- (AliveListForwardView *)forwardView {
    if (!_forwardView) {
        _forwardView = [[AliveListForwardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 80)];
        
        AliveListModel *forward = [[AliveListModel alloc] init];
        forward.aliveImgs = self.aliveListModel.aliveImgs;
        forward.masterNickName = self.aliveListModel.masterNickName;
        forward.aliveTitle = self.aliveListModel.aliveTitle;
        
        [_forwardView setupAlive:forward];
    }
    return _forwardView;
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
        if (idx >= self.imageLimit) {
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
    
    if (self.publishType == kAlivePublishForward ||
        self.publishType == kAlivePublishShare) {
        self.forwardView.frame = CGRectMake(15, height+15, kScreenWidth-30, 80);
        [footerView addSubview:self.forwardView];
        height = CGRectGetMaxY(self.forwardView.frame);
    }
    
    footerView.frame = CGRectMake(0, 0, kScreenWidth, height+15);
    self.tableView.tableFooterView = footerView;
    
    [self.tableView bringSubviewToFront:self.companyListTableView];
}

- (void)checkRightBarItemEnabled {
    
    if (self.publishType == kAlivePublishNormal) {
        self.navigationItem.rightBarButtonItem.enabled = self.reason.length;
    } else if (self.publishType == kAlivePublishPosts){
        
        if (self.imageArray.count && self.selectedStockArrM.count) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else {
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
        }
        
    } else if (self.publishType == kAlivePublishForward ||
               self.publishType == kAlivePublishShare) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
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
    if ((self.publishType == kAlivePublishPosts) && self.companyListTableView.hidden == NO) {
        self.companyListTableView.hidden = YES;
    }
    
    [self.imagePicker showImagePickerInController:self withLimitSelectedCount:(self.imageLimit-self.imageArray.count)];
    
}

- (void)delPressed:(UIButton *)sender {
    NSInteger row = sender.tag;
    if (row>=0 && row < self.imageArray.count) {
        [self.imageArray removeObjectAtIndex:row];
        
        [self setupFooterView];
        
        [self checkRightBarItemEnabled];
    }
}

- (void)publishPressed:(id)sender {
    
    NSString *stockId = @"";
    NSString *reasonString = self.reason;
    
    if (self.publishType == kAlivePublishNormal) {
        // 图文发布，描述不能为空
        if (!reasonString.length) {
            return;
        }
    } else if (self.publishType == kAlivePublishPosts) {
        // 推单发布，股票代码和图片不能为空
        self.companyListTableView.hidden = YES;
        NSMutableArray *arrM = [NSMutableArray array];
        for (SearchCompanyListModel *model in self.selectedStockArrM) {
            [arrM addObject:model.company_code];
        }
        
        if (arrM.count<=0 ||
            !self.imageArray.count) {
            return;
        }
        
        stockId = [self arrayToJSONString:arrM];
       
    } else if (self.publishType == kAlivePublishForward ||
               self.publishType == kAlivePublishShare) {
        // 转发，描述可以为空
    }
    
    [self.view endEditing:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSDictionary *dict = nil;
    
    switch (self.publishType) {
        case kAlivePublishNormal:
            dict = @{@"alive_type": @"1",
                     @"content": reasonString?:@""};
            
            break;
        case kAlivePublishPosts:
        {
            dict = @{@"alive_type": @"2",
                     @"content": reasonString?:@"",
                     @"stock": stockId?:@""};
            [SearchCompanyListModel saveLocalHistoryModelArr:self.selectedStockArrM];
        }
            break;
        case kAlivePublishForward:
            dict = @{@"alive_type": @"3",
                     @"content": reasonString?:@"",
                     @"forward_type": @(self.aliveListModel.aliveType),
                     @"forward_id": self.aliveListModel.aliveId};
            break;
        case kAlivePublishShare:
            dict = @{@"alive_type": @"4",
                     @"content": reasonString?:@"",
                     @"forward_type": @(self.aliveListModel.aliveType),
                     @"forward_id": self.aliveListModel.aliveId};
            break;
        default:
            NSAssert(NO, @"不支持的类型发布动态");
            break;
    }
    
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
    if (self.publishType == kAlivePublishForward ||
        self.publishType == kAlivePublishShare) {
        if (self.shareBlock) {
            self.shareBlock(YES);
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAlivePublishNotification object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ImagePickerHanderlDelegate
- (void)imagePickerHanderl:(ImagePickerHandler *)imagePicker didFinishPickingImages:(NSArray *)images {
    [self.imageArray addObjectsFromArray:images];
    [self setupFooterView];
    [self checkRightBarItemEnabled];
}


#pragma mark - loadCompanyList
- (void)loadCompanyListData:(NSString *)textStr {
    
    NSDictionary *dict = @{@"keyword":textStr};
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    CGPoint p = [self.stockIdTextField convertPoint:self.stockIdTextField.frame.origin toView:self.view];
    
    [manager POST:API_ViewSearchCompnay parameters:dict completion:^(id data, NSError *error) {
        if (!error) {
            NSArray *dataArray = data;
            NSMutableArray *resultModelArrM = [NSMutableArray array];
            for (NSDictionary *d in dataArray) {
                SearchCompanyListModel *model = [[SearchCompanyListModel alloc] initWithDictionary:d];
                [resultModelArrM addObject:model];
            }
            
            [self.companyListTableView configResultDataArr:[resultModelArrM mutableCopy] andRectY:p.y+20];
        }else{
            
            [self.companyListTableView configResultDataArr:[NSArray array] andRectY:p.y+20];
            
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (textField == self.stockIdTextField) {
        
        if (self.selectedStockArrM.count>=5) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"股票最多选择五个哦！";
            hud.mode = MBProgressHUDModeText;
            [hud hide:NO afterDelay:1.5];
            [textField resignFirstResponder];
            return NO;
        }
        
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


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (self.selectedStockArrM.count>=5) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"股票最多选择五个哦！";
        [hud hide:NO afterDelay:1.5];
        [textField resignFirstResponder];
        return;
    }
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    
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
    if ((self.publishType == kAlivePublishPosts) && self.companyListTableView.hidden == NO) {
        self.companyListTableView.hidden = YES;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.publishType == kAlivePublishPosts)?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.publishType == kAlivePublishPosts)?(1+self.selectedStockArrM.count):0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.selectedStockArrM.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveStockCellID"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AliveStockCellID"];
            self.stockIdTextField.frame = CGRectMake(15, 12, kScreenWidth-27, 20);
            [cell.contentView addSubview:self.stockIdTextField];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        PublishSelectedStockCell *selectedCell = [PublishSelectedStockCell loadPublishSelectedStockCellWithTableView:tableView];
        selectedCell.delegate = self;
        selectedCell.stockModel = self.selectedStockArrM[indexPath.row];
        return selectedCell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.publishType == kAlivePublishPosts && self.historySelectedStockArrM.count>0) {
        
        return 54;
    }else {
        return FLT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {
    
    if (self.publishType == kAlivePublishPosts && self.historySelectedStockArrM.count>0) {
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
        headerV.backgroundColor = TDViewBackgrouondColor;
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        vi.backgroundColor = [UIColor whiteColor];
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 44)];
        tLabel.text = @"猜你选择";
        tLabel.font = [UIFont systemFontOfSize:15.0];
        tLabel.textColor = TDTitleTextColor;
        [vi addSubview:tLabel];
        CGFloat btnX = 90;
        for (int i=0; i<self.historySelectedStockArrM.count; i++) {
            SearchCompanyListModel *model = self.historySelectedStockArrM[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:[NSString stringWithFormat:@"%@(%@)",model.company_name,model.company_code] forState:UIControlStateNormal];
            CGFloat btnW = [self calculateWidthWithStr:btn.currentTitle];
            [btn addBorder:0.5 borderColor:TDDetailTextColor];
            btn.frame = CGRectMake(btnX, 10, btnW, 24);
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [btn setTitleColor:TDDetailTextColor forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(historySeletedClick:) forControlEvents:UIControlEventTouchUpInside];
            [vi addSubview:btn];
            btnX += btnW+8;
        }
        
        [headerV addSubview:vi];
        
        return headerV;
    }else {
        
        return nil;
    }
}

#pragma mark - PublishSelectedStockCellDelegate
- (void)deletePublishSelectedCell:(id)model {
    [self.selectedStockArrM removeObject:model];
    [self.tableView reloadData];
    CGPoint p = [self.stockIdTextField convertPoint:self.stockIdTextField.frame.origin toView:self.view];
    [self.companyListTableView changeTableViewHeightWithRectY:p.y-24];
}


#pragma mark - 猜你选择
- (void)historySeletedClick:(UIButton *)sender {
    [self addSelectedStockObjectWithModel:self.historySelectedStockArrM[sender.tag]];
}


#pragma mark --- 计算字符长度
- (CGFloat)calculateWidthWithStr:(NSString *)textStr {
    
    return [textStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.width;
}


#pragma mark - UISCroolView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if(!decelerate)
    {   //OK,真正停止了，do something}
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint p = [self.stockIdTextField convertPoint:self.stockIdTextField.frame.origin toView:self.view];
    [self.companyListTableView changeTableViewHeightWithRectY:p.y+20];
    
}

/// 添加自选项，删除重复数据
- (void)addSelectedStockObjectWithModel:(SearchCompanyListModel *)model {
    
    if (self.selectedStockArrM.count <= 0) {
        [self.selectedStockArrM addObject:model];
    }else {
        
        if (self.selectedStockArrM.count>=5) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"股票最多选择五个哦！";
            [hud hide:YES afterDelay:1.5];
            return;
        }
        
        for (SearchCompanyListModel *m in self.selectedStockArrM
             ) {
            if ([m.company_code isEqualToString:model.company_code]) {
                return;
            }else {
                
                [self.selectedStockArrM addObject:model];
                
                break;
            }
        }
    }
    [self checkRightBarItemEnabled];
    [self.tableView reloadData];
}

- (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    //    NSMutableArray *muArray = [NSMutableArray array];
    //    for (NSString *userId in array) {
    //        [muArray addObject:[NSString stringWithFormat:@"\"%@\"", userId]];
    //    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"json string is: %@", jsonString);
    return jsonString;
}

@end

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
#import "LoginStateManager.h"
#import "NotificationDef.h"
#import "AliveListModel.h"
#import "SearchCompanyListModel.h"
#import "PublishSelectedStockCell.h"
#import "AlivePublishImageTableViewCell.h"
#import "UIView+Border.h"
#import <AliyunOSSiOS/OSSService.h>
#import "CocoaLumberjack.h"
#import "UIImageView+WebCache.h"
#import "NSString+Json.h"
#import "NSString+Emoji.h"
#import "SearchCompanyTableViewDelegate.h"
#import "PublishStockCodeInputTableViewCell.h"
#import "PublishForwardTableViewCell.h"
#import "PublishStockHolderTableViewCell.h"
#import "AlivePublishHandler.h"
#import "StockPoolSearchViewController.h"
#import "SettingHandler.h"

#define kPublishStockCodeSelected       @"PublishStockCodeSelected"
#define kPublishStockCodeInput          @"PublishStockCodeInput"
#define kPublishReasonInput             @"kPublishReasonInput"
#define kPublishImageSelected           @"kPublishImageSelected"
#define kPublishForward                 @"kPublishForward"
#define kPublishStockHolder             @"PublishStockHolder"

@interface AlivePublishViewController ()<UITextViewDelegate, ImagePickerHanderlDelegate, MBProgressHUDDelegate,UITextFieldDelegate,PublishSelectedStockCellDelegate, AlivePublishImageCellDegate>
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UITextField *stockIdTextField;
@property (nonatomic, strong) UITextView *reasonTextView;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) ImagePickerHandler *imagePicker;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *textFieldPlaceholder;
@property (nonatomic, assign) NSInteger imageLimit;
@property (strong, nonatomic) NSMutableArray *selectedStockArrM;
/// 历史选择记录
@property (strong, nonatomic) NSMutableArray *historySelectedStockArrM;

@property (nonatomic, strong) UITableView *searchStockTableView;
@property (nonatomic, strong) SearchCompanyTableViewDelegate *searchStockTableViewDelegate;

@property (nonatomic, strong) OSSClient *client;
@property (nonatomic, strong) NSString *bucketName;

@property (nonatomic, assign) BOOL isOpenStockHolder;
@property (nonatomic, strong) NSString *stockHolderCode;
@end

@implementation AlivePublishViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (UITableView *)searchStockTableView {
    if (!_searchStockTableView) {
        _searchStockTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _searchStockTableView;
}

- (SearchCompanyTableViewDelegate *)searchStockTableViewDelegate {
    if (!_searchStockTableViewDelegate) {
        _searchStockTableViewDelegate = [[SearchCompanyTableViewDelegate alloc] initWithTableView:self.searchStockTableView];
        
        __weak AlivePublishViewController *wself = self;
        _searchStockTableViewDelegate.didSelectedWithSearchCompnayModle = ^(SearchCompanyListModel *model){
            wself.stockIdTextField.text = @"";
            [wself.stockIdTextField resignFirstResponder];
            [wself addSelectedStockObjectWithModel:model];
        };
    }
    
    return _searchStockTableViewDelegate;
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

- (UITextView *)reasonTextView {
    if (!_reasonTextView) {
        _reasonTextView = [[UITextView alloc] init];
        _reasonTextView.font = [UIFont systemFontOfSize:15.0f];
        _reasonTextView.delegate = self;
    }
    return _reasonTextView;
}

- (ImagePickerHandler *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[ImagePickerHandler alloc] initWithDelegate:self];
    }
    return _imagePicker;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *rightButtonTitle = @"";
    
    switch (self.publishType) {
        case kAlivePublishNormal:
            self.title = @"发布话题";
            self.textFieldPlaceholder = @"写点什么吧...";
            self.sections = @[kPublishReasonInput,kPublishImageSelected,kPublishStockHolder];
            rightButtonTitle = @"发布";
            self.imageLimit = 9;
            break;
        case kAlivePublishPosts:
            self.title = @"发布推单";
            self.textFieldPlaceholder = @"填写买入卖出理由或其他";
            self.sections = @[kPublishStockCodeSelected,kPublishStockCodeInput,kPublishReasonInput,kPublishImageSelected];
            rightButtonTitle = @"发布";
            self.imageLimit = 9;
            break;
        default:
            self.title = @"转发直播";
            self.textFieldPlaceholder = @"写点分享心得吧...";
            self.sections = @[kPublishReasonInput,kPublishImageSelected,kPublishForward];
            rightButtonTitle = @"发布";
            self.imageLimit = 1;
            break;
    }

    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:rightButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(publishPressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                         forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
    
    self.reasonTextView.placeholder = self.textFieldPlaceholder;
    
    self.imageArray = [NSMutableArray arrayWithCapacity:9];
    
    self.selectedStockArrM = [NSMutableArray array];
    
    NSArray *localArr = [SearchCompanyListModel loadLocalHistoryModel];
    if (localArr == nil) {
        self.historySelectedStockArrM = [NSMutableArray array];
    }else {
        self.historySelectedStockArrM = [NSMutableArray arrayWithArray:localArr];
    }
    
    self.isOpenStockHolder = [AlivePublishHandler isOpenStockHolder];
    if (self.isOpenStockHolder) {
        self.stockHolderCode = [AlivePublishHandler getStockHolderCode];
    }
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.backgroundView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    UINib *nib = [UINib nibWithNibName:@"PublishForwardTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PublishForwardTableViewCellID"];
    UINib *nib2 = [UINib nibWithNibName:@"PublishStockHolderTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"PublishStockHolderTableViewCellID"];
    
    [self checkRightBarItemEnabled];
    
    [self getAliyunUploadSetting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


-(void)keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
  
    self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-keyboardBounds.size.height);
    
    if (self.stockIdTextField.isFirstResponder) {
        NSInteger section = [self.sections indexOfObject:kPublishStockCodeInput];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            CGRect rect = [self.tableView convertRect:cell.frame toView:self.tableView];
            self.searchStockTableView.frame = CGRectMake(0, CGRectGetMaxY(rect), kScreenWidth, kScreenHeight-64-CGRectGetHeight(rect)-keyboardBounds.size.height);
            // 搜索
            [self.searchStockTableViewDelegate reloadWithSearchText:self.stockIdTextField.text];
            [self.view addSubview:self.searchStockTableView];
            
            self.tableView.scrollEnabled = NO;
        }
        
    } else if (self.reasonTextView.isFirstResponder) {
        NSInteger section = [self.sections indexOfObject:kPublishReasonInput];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)note{
    if (self.searchStockTableView.superview) {
        [self.searchStockTableView removeFromSuperview];
        self.tableView.scrollEnabled = YES;
    }
    
    self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
}


/// 添加自选项，删除重复数据
- (void)addSelectedStockObjectWithModel:(SearchCompanyListModel *)model {
    
    for (SearchCompanyListModel *m in self.selectedStockArrM) {
        if ([m.company_code isEqualToString:model.company_code]) {
            return;
        }
    }
    
    [self.selectedStockArrM addObject:model];
    
    [self checkRightBarItemEnabled];
    [self.tableView reloadData];
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
    } else {
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

- (void)stockHolderSwitchChanged:(UISwitch *)sender {
    if (sender.on) {
        StockPoolSearchViewController *vc = [[StockPoolSearchViewController alloc] init];
        vc.selectedBlock = ^(NSString *stockName, NSString *stockCode){
            self.isOpenStockHolder = YES;
            self.stockHolderCode = stockCode;
            NSInteger time = [[NSDate new] timeIntervalSince1970];
            [SettingHandler saveStockHolderOpenTime:time];
            [SettingHandler saveStockHolderName:[NSString stringWithFormat:@"%@ %@",stockName, stockCode]];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        sender.on = NO;
    } else {
        self.isOpenStockHolder = NO;
        [SettingHandler saveStockHolderOpenTime:0];
        [SettingHandler saveStockHolderName:@""];
        [self.tableView reloadData];
    }
}

- (void)publishPressed:(id)sender {
    
    [self.view endEditing:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    dict[@"publish_type"] = @(self.publishType);
    
    if (self.reason.length) {
        dict[@"content"] = [self.reason stringByReplacingEmojiUnicodeWithCheatCodes];
    }
    
    if (self.publishType == kAlivePublishNormal) {
        if (self.isOpenStockHolder) {
            dict[@"publish_type"] = @(kAlivePublishStockHolder);
            NSDictionary *extraDict = @{@"is_stock_mt": @"1",
                                        @"stock": @[self.stockHolderCode]};
            NSString *extra = [NSString jsonStringWithObject:extraDict];
            dict[@"publish_extra"] = extra;
        }
    } else if (self.publishType == kAlivePublishPosts) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (SearchCompanyListModel *model in self.selectedStockArrM) {
            [arrM addObject:model.company_code];
        }
        NSDictionary *extraDict = @{@"stock": arrM};
        NSString *extra = [NSString jsonStringWithObject:extraDict];
        dict[@"publish_extra"] = extra;
    } else if (self.publishType == kAlivePublishForward){
        NSDictionary *extraDict = @{@"forward_id": self.publishModel.forwardId,@"forward_type": @(self.publishModel.forwardType)};
        NSString *extra = [NSString jsonStringWithObject:extraDict];
        dict[@"publish_extra"] = extra;
    } else {
        if (self.publishModel) {
            NSDictionary *extraDict = @{@"forward_id": self.publishModel.forwardId};
            NSString *extra = [NSString jsonStringWithObject:extraDict];
            dict[@"publish_extra"] = extra;
        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"提交中";
    
    __weak AlivePublishViewController *wself = self;
    
    if (self.imageArray.count && self.client) {
        NSArray *files = [self imageFilesWithImages:self.imageArray];
        
        NSMutableArray *fileNames = [NSMutableArray arrayWithCapacity:files.count];
        [files enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL *stop){
            NSString *fileName = [filePath lastPathComponent];
            [fileNames addObject:fileName];
        }];
        

        NSString *uploadImageNames = [NSString jsonStringWithObject:fileNames];
        dict[@"upload_imgs"] = uploadImageNames;
        
        [self uploadImages:self.imageArray imageFiles:files completion:^{
            
            NetworkManager *manager = [[NetworkManager alloc] init];
            [manager POST:API_AliveAddRoomPublish parameters:dict completion:^(id data, NSError *error) {
                wself.navigationItem.rightBarButtonItem.enabled = YES;
                
                if (!error) {
                    hud.label.text = @"发布成功";
                    hud.delegate = self;
                    [hud hideAnimated:YES afterDelay:1];
                } else {
                    hud.label.text = @"发布失败";
                    [hud hideAnimated:YES afterDelay:1];
                }
            }];
        }];
    } else {
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
                hud.label.text = @"发布成功";
                hud.delegate = self;
                [hud hideAnimated:YES afterDelay:1];
            } else {
                hud.label.text = @"发布失败";
                [hud hideAnimated:YES afterDelay:1];
            }
        }];
    }
    
}


#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (self.shareBlock) {
        self.shareBlock(YES);
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAlivePublishNotification object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ImagePickerHanderlDelegate
- (void)imagePickerHanderl:(ImagePickerHandler *)imagePicker didFinishPickingImages:(NSArray *)images {
    [self.imageArray addObjectsFromArray:images];
    [self.tableView reloadData];
    [self checkRightBarItemEnabled];
}



#pragma mark - AlivePublishImageCellDegate

- (void)alivePublishImageCell:(AlivePublishImageTableViewCell *)cell addPressed:(id)sender {
    [self.view endEditing:YES];
    
    [self.imagePicker showImagePickerInController:self withLimitSelectedCount:(self.imageLimit-self.imageArray.count)];
}

- (void)alivePublishImageCell:(AlivePublishImageTableViewCell *)cell deletePressed:(id)sender {
    NSInteger row = ((UIButton *)sender).tag;
    if (row>=0 && row < self.imageArray.count) {
        [self.imageArray removeObjectAtIndex:row];
        
        [self.tableView reloadData];
        [self checkRightBarItemEnabled];
    }
}

#pragma mark - PublishSelectedStockCellDelegate
- (void)deletePublishSelectedCell:(id)model {
    [self.selectedStockArrM removeObject:model];
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.stockIdTextField) {
        
        if (self.selectedStockArrM.count>=5) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"股票最多选择五个哦！";
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:NO afterDelay:1.5];
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
        hud.label.text = @"股票最多选择五个哦！";
        [hud hideAnimated:NO afterDelay:1.5];
        [textField resignFirstResponder];
        return;
    }
    
    NSInteger section = [self.sections indexOfObject:kPublishStockCodeInput];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if ([cell isKindOfClass:[PublishStockCodeInputTableViewCell class]]) {
        PublishStockCodeInputTableViewCell *stockCodelCell = (PublishStockCodeInputTableViewCell *)cell;
        stockCodelCell.cancelBtn.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger section = [self.sections indexOfObject:kPublishStockCodeInput];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if ([cell isKindOfClass:[PublishStockCodeInputTableViewCell class]]) {
        PublishStockCodeInputTableViewCell *stockCodelCell = (PublishStockCodeInputTableViewCell *)cell;
        stockCodelCell.cancelBtn.hidden = YES;
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self.searchStockTableViewDelegate reloadWithSearchText:textField.text];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.reason = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self checkRightBarItemEnabled];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *sectionTitle = self.sections[section];
    if ([sectionTitle isEqualToString:kPublishStockCodeSelected]) {
        return self.selectedStockArrM.count;
    } else if ([sectionTitle isEqualToString:kPublishStockCodeInput] ||
               [sectionTitle isEqualToString:kPublishReasonInput] ||
               [sectionTitle isEqualToString:kPublishImageSelected] ||
               [sectionTitle isEqualToString:kPublishForward] ||
               [sectionTitle isEqualToString:kPublishStockHolder]) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sectionTitle = self.sections[indexPath.section];
    if ([sectionTitle isEqualToString:kPublishStockCodeSelected]) {
        PublishSelectedStockCell *selectedCell = [PublishSelectedStockCell loadPublishSelectedStockCellWithTableView:tableView];
        selectedCell.delegate = self;
        selectedCell.stockModel = self.selectedStockArrM[indexPath.row];
        return selectedCell;
        
    } else if ([sectionTitle isEqualToString:kPublishStockCodeInput]) {
        PublishStockCodeInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishStockCodeInputTableViewCellID"];
        if (!cell) {
            cell = [[PublishStockCodeInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PublishStockCodeInputTableViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField = self.stockIdTextField;
            self.stockIdTextField.frame = CGRectMake(15, 12, kScreenWidth-75, 20);
            [cell.contentView addSubview:self.stockIdTextField];
        }

        return cell;
    } else if ([sectionTitle isEqualToString:kPublishReasonInput]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishReasonInputCellID"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PublishReasonInputCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.reasonTextView.frame = CGRectMake(15, 12, kScreenWidth-27, 137);
            self.reasonTextView.placeholder = self.textFieldPlaceholder;
            [cell.contentView addSubview:self.reasonTextView];
        }
        
        return cell;
    } else if ([sectionTitle isEqualToString:kPublishImageSelected]) {
        AlivePublishImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishSelectedImageCellID"];
        if (!cell) {
            cell = [[AlivePublishImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PublishSelectedImageCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.imageLimit = self.imageLimit;
        cell.images = self.imageArray;
        return cell;
    } else if ([sectionTitle isEqualToString:kPublishForward]) {
        PublishForwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishForwardTableViewCellID"];
        [cell setupPublishModel:self.publishModel withPublishType:self.publishType];
        
        return cell;
    } else if ([sectionTitle isEqualToString:kPublishStockHolder]) {
        PublishStockHolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishStockHolderTableViewCellID"];
        [cell.switchBtn addTarget:self action:@selector(stockHolderSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (self.isOpenStockHolder) {
            cell.stockNameLabel.text = [AlivePublishHandler getStockHolderName];
            cell.switchBtn.on = YES;
        } else {
            cell.stockNameLabel.text = @"";
            cell.switchBtn.on = NO;
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishNormalCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PublishNormalCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = self.sections[indexPath.section];
    if ([sectionTitle isEqualToString:kPublishStockCodeSelected]) {
        return 44.0f;
    } else if ([sectionTitle isEqualToString:kPublishStockCodeInput]) {
        return 44.0f;
    } else if ([sectionTitle isEqualToString:kPublishReasonInput]) {
        return 152;
    } else if ([sectionTitle isEqualToString:kPublishImageSelected]) {
        return [AlivePublishImageTableViewCell heightWithImageCount:self.imageArray.count withLimit:self.imageLimit];
    } else if ([sectionTitle isEqualToString:kPublishForward]) {
        return 94;
    } else if ([sectionTitle isEqualToString:kPublishStockHolder]) {
        return 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = self.sections[section];
    if ([sectionTitle isEqualToString:kPublishStockHolder]) {
        return 10.0f;
    }
    return FLT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_MIN;
}


#pragma mark - Aliyun Upload

- (void)getAliyunUploadSetting {
    __weak AlivePublishViewController *wself = self;
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_AliyunUpload parameters:@{@"type": @(1)} completion:^(id data, NSError *error) {
        
        if (!error) {
            NSString *AccessKeyId = data[@"AccessKeyId"];
            NSString *AccessKeySecret = data[@"AccessKeySecret"];
            NSString *SecurityToken = data[@"SecurityToken"];
            
            NSString *endpoint = @"https://oss-cn-hangzhou.aliyuncs.com";
            // 移动端建议使用STS方式初始化OSSClient。更多鉴权模式请参考后面的访问控制章节。
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:AccessKeyId secretKeyId:AccessKeySecret securityToken:SecurityToken];
            wself.client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
            wself.bucketName = data[@"bucketName"];
        } else {
            
        }
    }];
}

- (NSArray *)imageFilesWithImages:(NSArray *)images {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:images.count];
    
    NSString *root = @"";
    if (self.publishType == kAlivePublishPosts) {
        // 推单 保存的路径为Bare,文件名为bare_u+用户id+_+年月日时分秒+后缀名，即上传的整个路径为Bare/文件名
        root = @"Bare/bare";
    } else {
        // 当为话题或转发时，保存路径为Room，文件名为alive_u+用户id+_+年月日时分秒+后缀名
        root = @"Room/alive";
    }
    
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateString = [formatter stringFromDate:now];
    
    for (int i=0; i<images.count; i++) {
        int x = arc4random() % 100;
        
        NSString *file = [NSString stringWithFormat:@"%@_%@_%@_%ld.jpg",root,US.userId,dateString,(long)x];
        [array addObject:file];
    }
    
    return array;
}

- (void)uploadImages:(NSArray<UIImage *> *)images imageFiles:(NSArray *)imageFiles completion:(void(^)(void)) complete{
    
    OSSClient *client = self.client;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    int i = 0;
    for (UIImage *image in images) {
        if (image) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                put.bucketName = self.bucketName;
                put.objectKey = imageFiles[i];
                NSData *data = UIImageJPEGRepresentation(image, 0.8);
                put.uploadingData = data;
                
                OSSTask * putTask = [client putObject:put];
                
                if (!putTask.error) {
                    DDLogInfo(@"upload file successed");
                } else {
                    DDLogError(@"upload object failed, error: %@" , putTask.error);
                }
            }];
            
            [queue addOperation:operation];
        }
        i++;
    }
    
    [queue waitUntilAllOperationsAreFinished];
    
    if (complete) {
        complete();
    }
}


#pragma mark - UISCroolView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    
//    if(!decelerate)
//    {   //OK,真正停止了，do something}
//        [self scrollViewDidEndDecelerating:scrollView];
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGPoint p = [self.stockIdTextField convertPoint:self.stockIdTextField.frame.origin toView:self.view];
//    [self.companyListTableView changeTableViewHeightWithRectY:p.y+20];
    
}

@end

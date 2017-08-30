//
//  StockPoolAddAndEditViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolAddAndEditViewController.h"
#import "SPEditTableViewCell.h"
#import "NetworkManager.h"
#import "SPEditRecordModel.h"
#import "UITextView+Placeholder.h"
#import "StockPoolSearchViewController.h"
#import "MBProgressHUD.h"
#import "NSString+Json.h"
#import "ACActionSheet.h"
#import "NotificationDef.h"

@interface StockPoolAddAndEditViewController ()
<UITableViewDelegate, UITableViewDataSource, SPEditTableViewCellDelegate,
UITextViewDelegate, MBProgressHUDDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, assign) BOOL isEdit;
@end

@implementation StockPoolAddAndEditViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F3FBFF"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 46.0f;
        
        UINib *nib = [UINib nibWithNibName:@"SPEditTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"SPEditTableViewCellID"];
    }
    
    return _tableView;
}

- (void)setRecordId:(NSString *)recordId {
    _recordId = recordId;
    
    if (recordId.length) {
        _isEdit = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNav];
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F3FBFF"];
    [self.view addSubview:self.tableView];
    
    [self queryRecordList];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-keyboardBounds.size.height);
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set views with new info
    self.tableView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.tableView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

- (void)setupNav {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
    label.text = @"记录";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [left setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}
                        forState:UIControlStateNormal];
    [left setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}
                        forState:UIControlStateDisabled];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishPressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}
                         forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)backPressed:(id)sender {
    if (![self canSave]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    ACActionSheet *sheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存" otherButtonTitles:@[@"保存草稿"] actionSheetBlock:^(NSInteger index){
        if (index == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if (index == 1) {
            [self publishOrSaveDraft:YES];
        }
    }];
    [sheet show];
    
    
}

- (void)publishPressed:(id)sender {
    
    void (^ShowHud)(NSString *mesage) = ^(NSString *mesage){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.font = [UIFont systemFontOfSize:14.0f];
        hud.label.text = mesage;
        hud.center = CGPointMake(kScreenWidth/2, 250);
        [hud hideAnimated:YES afterDelay:1.6];
    };
    
    if (self.list.count <= 1) {
        ShowHud(@"请先添加股票信息");
        return;
    }
    
    int i=0;
    for (SPEditRecordModel *model in self.list) {
        if (model.cellType == kSPEidtCellEidt ||
            model.cellType == kSPEidtCellNormal) {
            if (!model.ratio.length) {
                ShowHud(@"添加新股的仓位不得为0");
                return;
            } else {
                if ((self.isEdit == NO) &&
                    ([model.ratio integerValue] == 0)) {
                    ShowHud(@"添加新股的仓位不得为0");
                    return;
                }
                i += [model.ratio integerValue];
            }
        }
    }
    
    if (i> 100) {
        ShowHud(@"总仓位不得超过100%");
        return;
    }
    
    if (!self.reason.length) {
        ShowHud(@"持仓理由不能为空");
        return;
    }
    
    [self publishOrSaveDraft:NO];
}


- (void)queryRecordList {
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(kScreenWidth/2, (kScreenHeight-64)/2);
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *dict = @{};
    if (self.recordId.length) {
        dict = @{@"record_id":self.recordId};
    }
    
    [ma GET:API_StockPoolGetRecordPoint parameters:dict completion:^(id data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error && data && [data isKindOfClass:[NSDictionary class]]) {
            self.reason = data[@"record_desc"];
            NSArray *records = data[@"record_detail_list"];
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:records.count];
            for (NSDictionary *dict in records) {
                SPEditRecordModel *model = [[SPEditRecordModel alloc] initWithDictionary:dict];
                [array addObject:model];
            }
            [self reloadViewWithArray:array];
        } else {
            [self reloadViewWithArray:nil];
        }
    }];
}

- (void)reloadViewWithArray:(NSArray *)array {
    
    SPEditRecordModel *edit = [[SPEditRecordModel alloc] init];
    edit.cellType = kSPEidtCellEidt;
    
    SPEditRecordModel *add = [[SPEditRecordModel alloc] init];
    add.cellType = kSPEidtCellAdd;
    
    NSMutableArray *marray = [NSMutableArray arrayWithCapacity:array.count];
    if (array.count) {
        [marray addObjectsFromArray:array];
    }
    
    if (self.isEdit) {
        [marray addObject:add];
    } else {
        [marray addObject:edit];
        [marray addObject:add];
    }
    
    self.list = marray;
    [self.tableView reloadData];
}

- (void)addRecordPressed:(id)sender {
    SPEditRecordModel *edit = [[SPEditRecordModel alloc] init];
    edit.cellType = kSPEidtCellEidt;
    
    [self.tableView beginUpdates];
    [self.list insertObject:edit atIndex:(self.list.count-1)];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.list.count-2 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
}

- (void)deleteRecordPressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"删除后不能恢复，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self sendDeleteRecordRequest];
    }];
    [alert addAction:cancel];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)deleteWithIndex:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.list removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

- (BOOL)canSave {
    
    if (self.list.count <= 1) {
        return NO;
    }
    
    int i=0;
    for (SPEditRecordModel *model in self.list) {
        if (model.cellType == kSPEidtCellEidt ||
            model.cellType == kSPEidtCellNormal) {
            if (!model.ratio.length) {
                return NO;
            } else {
                i += [model.ratio integerValue];
            }
        }
    }
    
    if (i> 100) {
        return NO;
    }
    
    if (!self.reason.length) {
        return NO;
    }
    
    return YES;
}

- (void)publishOrSaveDraft:(BOOL)isDraft {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.list.count];
    for (SPEditRecordModel *model in self.list) {
        if (model.cellType == kSPEidtCellEidt ||
            model.cellType == kSPEidtCellNormal) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            dict[@"stock"] = model.stockCode;
            dict[@"ratio"] = model.ratio;
            [array addObject:dict];
        }
    }
    
    NSString *position = [NSString jsonStringWithObject:array];
    
    NSDictionary *dict = @{@"desc": self.reason,
                           @"is_publish": isDraft?@(0):@(1),
                           @"position_data": position,
                           @"record_id": self.recordId?:@""};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = isDraft?@"保存中":@"提交中";
    
    __weak StockPoolAddAndEditViewController *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_StockPoolPublish parameters:dict completion:^(id data, NSError *error){
        
        if (isDraft) {
            hud.label.text = @"保存成功";
            [hud hideAnimated:YES afterDelay:1];
            hud.completionBlock = ^{
                [wself dismissViewControllerAnimated:YES completion:nil];
            };
        } else {
            if (!error) {
                hud.label.text = @"发布成功";
                [hud hideAnimated:YES afterDelay:1];
                hud.completionBlock = ^{
                    if (wself.isEdit) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kStockPoolRecordChangedSuccessed object:@(2)];
                    } else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kStockPoolRecordChangedSuccessed object:@(1)];
                    }
                    
                    [wself dismissViewControllerAnimated:YES completion:nil];
                };
            } else {
                hud.label.text = @"发布失败";
                [hud hideAnimated:YES afterDelay:1];
            }
        }
    }];
}

- (void)sendDeleteRecordRequest {
    NSDictionary *dict = @{@"record_id": self.recordId?:@""};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text =@"删除中";
    
    __weak StockPoolAddAndEditViewController *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_StockPoolDeleteRecord parameters:dict completion:^(id data, NSError *error){
        
        if (!error) {
            hud.label.text = @"删除成功";
            [hud hideAnimated:YES afterDelay:1];
            hud.completionBlock = ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kStockPoolRecordChangedSuccessed object:@(3)];
                [wself dismissViewControllerAnimated:YES completion:nil];
            };
        } else {
            hud.label.text = @"删除失败";
            [hud hideAnimated:YES afterDelay:1];
        }
    }];
}

#pragma mark - SPEditTableViewCellDelegate
- (void)spEditTableViewCell:(SPEditTableViewCell *)cell optionPressed:(id)sender {
    if (cell.model.cellType == kSPEidtCellEidt) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self deleteWithIndex:indexPath];
    } else {
        
    }
}

- (void)spEditTableViewCell:(SPEditTableViewCell *)cell stockNamePressed:(id)sender {
    StockPoolSearchViewController *vc = [[StockPoolSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.selectedBlock = ^(NSString *stockName, NSString *stockCode){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        SPEditRecordModel *model = self.list[indexPath.row];
        model.stockCode = stockCode;
        model.stockName = stockName;
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    };
}

#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView {
    self.reason = textView.text;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isEdit) {
        return self.list.count?3:0;
    } else {
        return self.list.count?2:0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.list.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SPEditRecordModel *model = self.list[indexPath.row];
        
        if (model.cellType == kSPEidtCellNormal ||
            model.cellType == kSPEidtCellEidt) {
            SPEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPEditTableViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.enabled = (model.cellType == kSPEidtCellNormal)?NO:YES;
            cell.model = model;
            
            return cell;
        } else if (model.cellType == kSPEidtCellAdd) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPEditTableViewCellAddID"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SPEditTableViewCellAddID"];
                cell.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F3FBFF"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth-30, 36)];
                btn.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#76A5BC"].CGColor;
                btn.layer.borderWidth = TDPixel;
                btn.layer.cornerRadius = 3.0f;
                btn.clipsToBounds = YES;
                [btn setTitle:@"添加" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3371E2"] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                btn.backgroundColor = [UIColor whiteColor];
                [btn addTarget:self action:@selector(addRecordPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
            }
            
            return cell;
        }
    } else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPEditTableViewCellContentID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SPEditTableViewCellContentID"];
            cell.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F3FBFF"];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 268)];
            textView.backgroundColor = [UIColor whiteColor];
            textView.font = [UIFont systemFontOfSize:15.0f];
            textView.textColor = TDTitleTextColor;
            textView.delegate = self;
            
            textView.placeholderColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
            textView.placeholderLabel.font = [UIFont systemFontOfSize:14.0f];
            textView.placeholderLabel.frame = CGRectMake(20, 19, 150, 16);
            textView.placeholder = @"写一下你的持仓理由吧~";
            textView.text = self.reason;
            [cell.contentView addSubview:textView];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    } else if (indexPath.section == 2) {
        // 删除
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPEditTableViewCellDeleteID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SPEditTableViewCellDeleteID"];
            cell.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F3FBFF"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth-30, 36)];
            btn.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#76A5BC"].CGColor;
            btn.layer.borderWidth = TDPixel;
            btn.layer.cornerRadius = 3.0f;
            btn.clipsToBounds = YES;
            [btn setTitle:@"删除该记录" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#FF523B"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            btn.backgroundColor = [UIColor whiteColor];
            [btn addTarget:self action:@selector(deleteRecordPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section <= 2) {
        return 40;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F3FBFF"];
    
    if (section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 100, 16)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = TDDetailTextColor;
        label.text = @"股票信息";
        [view addSubview:label];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(165, 24, 100, 16)];
        label2.font = [UIFont systemFontOfSize:14.0f];
        label2.textColor = TDDetailTextColor;
        label2.text = @"仓位";
        [view addSubview:label2];
    } else if (section == 1){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, 100, 16)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = TDLightGrayColor;
        label.text = @"持仓理由";
        [view addSubview:label];
    }
    
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 46;
    } else if (indexPath.section == 1){
        return 268;
    } else if (indexPath.section == 2) {
        return 60;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

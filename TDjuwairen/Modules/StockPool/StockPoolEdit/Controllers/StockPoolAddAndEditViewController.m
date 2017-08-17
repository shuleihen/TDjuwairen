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

@interface StockPoolAddAndEditViewController ()
<UITableViewDelegate, UITableViewDataSource, SPEditTableViewCellDelegate,
UITextViewDelegate, MBProgressHUDDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSString *reason;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNav];
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F3FBFF"];
    [self.view addSubview:self.tableView];
    
    [self queryRecordList];
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
        hud.labelFont = [UIFont systemFontOfSize:14.0f];
        hud.labelText = mesage;
        [hud hide:YES afterDelay:0.6];
    };
    
    int i=0;
    for (SPEditRecordModel *model in self.list) {
        if (model.cellType == kSPEidtCellEidt ||
            model.cellType == kSPEidtCellNormal) {
            if (!model.ratio.length) {
                ShowHud(@"添加新股的仓位不得为0");
                return;
            } else {
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
    [ma GET:API_StockPoolGetRecordPoint parameters:@{@"record_id":self.recordId?:@""} completion:^(id data, NSError *error){
        
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
    
    NSMutableArray *marray = [NSMutableArray arrayWithArray:array];
    [marray addObject:edit];
    [marray addObject:add];
    
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

- (void)deleteWithIndex:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.list removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

- (BOOL)canSave {
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
    hud.labelText = isDraft?@"保存中":@"提交中";
    
    __weak StockPoolAddAndEditViewController *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_StockPoolPublish parameters:dict completion:^(id data, NSError *error){
        
        if (isDraft) {
            hud.labelText = @"保存成功";
            hud.delegate = wself;
            [hud hide:YES afterDelay:1];
        } else {
            if (!error) {
                hud.labelText = @"发布成功";
                hud.delegate = wself;
                [hud hide:YES afterDelay:1];
            } else {
                hud.labelText = @"发布失败";
                [hud hide:YES afterDelay:1];
            }
        }
    }];
}
#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return self.list.count?2:0;
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
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
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
    } else {
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
    } else {
        return 268;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

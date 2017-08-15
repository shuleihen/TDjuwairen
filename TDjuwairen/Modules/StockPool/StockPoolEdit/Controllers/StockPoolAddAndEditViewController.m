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


@interface StockPoolAddAndEditViewController ()
<UITableViewDelegate, UITableViewDataSource, SPEditTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
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
        
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SPEditTableViewCellAddID"];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)publishPressed:(id)sender {
    
}

- (void)queryRecordList {
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(kScreenWidth/2, (kScreenHeight-64)/2);
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_StockPoolGetRecordPoint parameters:@{@"record_id":@""} completion:^(id data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error && data && [data isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:((NSArray *)data).count];
            for (NSDictionary *dict in data) {
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

#pragma mark - SPEditTableViewCellDelegate
- (void)spEditTableViewCell:(SPEditTableViewCell *)cell optionPressed:(id)sender {
    if (cell.enabled) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self deleteWithIndex:indexPath];
    } else {
        
    }
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
        if (model.cellType == kSPEidtCellNormal) {
            SPEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPEditTableViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.enabled = NO;
            
            return cell;
        } else if (model.cellType == kSPEidtCellEidt) {
            SPEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPEditTableViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.enabled = YES;
            
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
            textView.placeholderColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
            textView.placeholderLabel.font = [UIFont systemFontOfSize:14.0f];
            textView.placeholderLabel.frame = CGRectMake(20, 19, 150, 16);
            textView.placeholder = @"写一下你的持仓理由吧~";
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

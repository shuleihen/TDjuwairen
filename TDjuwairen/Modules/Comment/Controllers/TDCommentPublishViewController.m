//
//  TDCommentPublishViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDCommentPublishViewController.h"
#import "UITextView+Placeholder.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"

@interface TDCommentPublishViewController ()<UITextViewDelegate>
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation TDCommentPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TDViewBackgrouondColor;
    self.title = @"评论";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishPressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                         forState:UIControlStateDisabled];
    right.enabled = NO;
    self.navigationItem.rightBarButtonItem = right;
    
    [self setupUI];
}

- (void)setupUI {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 200-TDPixel, kScreenWidth, TDPixel)];
    sep.backgroundColor = TDSeparatorColor;
    [view addSubview:sep];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    textView.delegate = self;
    textView.placeholder = @"写评论...";
    textView.placeholderColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.textContainerInset = UIEdgeInsetsMake(15, 12, 0, 12);
    textView.textColor = TDTitleTextColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, kScreenWidth-10, 20)];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = TDDetailTextColor;
    label.text = @"还能输入200个字";
    [view addSubview:label];
    self.countLabel = label;
    
    [view addSubview:textView];
    [self.view addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)publishPressed:(id)sender {
    
    if (!self.masterId.length ||
        !self.comment.length) {
        return;
    }
    
    [self.view endEditing:YES];
    
    NSDictionary *dictM = nil;
    NSString *apiStr = @"";
    
    if (self.publishType == kCommentPublishStockPool) {
        dictM = @{@"master_id": self.masterId,@"content": self.comment};
        apiStr = API_StockPoolAddComment;
    } else if (self.publishType == kCommentPublishStockPoolReplay){
        apiStr = API_StockPoolReplyComment;
        dictM = @{@"comment_id": self.commentId,@"content": self.comment};
    }

    __weak typeof(self)wSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"发布中";
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:apiStr parameters:dictM completion:^(id data, NSError *error) {
        
        if (!error) {
            hud.label.text = @"发布成功";
            hud.completionBlock = ^{
                [wSelf.navigationController popViewControllerAnimated:YES];
                
                if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(commentPublishSuccessed)]) {
                    [wSelf.delegate commentPublishSuccessed];
                }
            };
            [hud hideAnimated:YES afterDelay:0.7];
            
        } else {
            hud.label.text = @"发布失败";
            [hud hideAnimated:YES afterDelay:0.7];
        }
        
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *string = [self.comment stringByReplacingCharactersInRange:range withString:text];
    return (string.length <= 200);
}

- (void)textViewDidChange:(UITextView *)textView {
    self.comment = textView.text;
    self.navigationItem.rightBarButtonItem.enabled = self.comment.length;

    self.countLabel.text = [NSString stringWithFormat:@"还能输入%ld个字",(long)(200-self.comment.length)];
}


@end

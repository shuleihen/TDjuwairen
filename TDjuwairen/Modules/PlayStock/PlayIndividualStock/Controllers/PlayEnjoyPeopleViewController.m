//
//  PlayEnjoyPeopleViewController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#define REDCOLOR  [UIColor hx_colorWithHexRGBAString:@"#e64920"]
#define GREENCOLOR  [UIColor hx_colorWithHexRGBAString:@"#148349"]


#import "PlayEnjoyPeopleViewController.h"
#import "STPopup.h"
#import "PlayItemPersonView.h"
#import "NetworkManager.h"
#import "PSIndividualUserListModel.h"
#import "PSIndividualUserModel.h"

@interface PlayEnjoyPeopleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *label_join;
@property (weak, nonatomic) IBOutlet UILabel *label_price;
@property (weak, nonatomic) IBOutlet UILabel *label_state;
@property (weak, nonatomic) IBOutlet UILabel *label_end_price;
@property (weak, nonatomic) IBOutlet UILabel *recentPeopleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation PlayEnjoyPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




- (void)setGuessID:(NSString *)guessID {
    _guessID = guessID;
    [self loadGuessUserList];
}


- (IBAction)closeClick:(id)sender {
    [self.popupController dismiss];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.view.layer.cornerRadius = 4;
    self.view.layer.masksToBounds = YES;
}


#pragma mark - 获取竞猜用户列表
- (void)loadGuessUserList {
    
    if (self.guessID.length <= 0) {
        return;
    }

    NetworkManager *ma = [[NetworkManager alloc] init];

    [ma POST:API_GetGuessIndividualUserList parameters:@{@"guess_id":self.guessID} completion:^(id data, NSError *error){
        if (!error && data) {
            
            PSIndividualUserModel *userModel = [[PSIndividualUserModel alloc] initWithDictionary:data];
            self.label_title.text = [NSString stringWithFormat:@"%@(%@)",userModel.guess_stock_name,userModel.guess_stock];
            self.label_join.text = userModel.guess_item_count;
            self.label_price.text = userModel.guess_avg_points;
            self.label_end_price.text = userModel.guess_end_price;
            self.label_state.text = userModel.guessStatusStr;
            self.recentPeopleLabel.text = [NSString stringWithFormat:@"以上为与当前价最接近的%ld位用户",(long)MIN(userModel.guess_users.count, 5)];
            
            for (UIView *v in self.contentView.subviews) {
                if ([v isKindOfClass:[PlayItemPersonView class]]) {
                    [v removeFromSuperview];
                }
            }
            
            CGFloat width = (_contentView.frame.size.width)/5;
            for (int i = 0; i<MIN(userModel.guess_users.count, 5); i++) {
                PlayItemPersonView *vi = [[PlayItemPersonView alloc] init];
                vi.frame = CGRectMake(i*width, 0, width, 66);
                vi.userModel = userModel.guess_users[i];
                [_contentView addSubview:vi];
            }
            
        } else {
        }
        
        
    }];
}
















@end

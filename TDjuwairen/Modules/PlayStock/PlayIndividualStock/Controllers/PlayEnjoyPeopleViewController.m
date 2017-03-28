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
#import "PlayItemPersonView.h"U
@interface PlayEnjoyPeopleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *label_join;
@property (weak, nonatomic) IBOutlet UILabel *label_price;
@property (weak, nonatomic) IBOutlet UILabel *label_state;
@property (weak, nonatomic) IBOutlet UILabel *label_end_price;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation PlayEnjoyPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = (_contentView.frame.size.width-40)/5;
    for (int i = 0; i<5; i++) {
        PlayItemPersonView *vi = [[PlayItemPersonView alloc] init];
        vi.frame = CGRectMake(i*width, 0, width, 66);
        [_contentView addSubview:vi];
    }
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

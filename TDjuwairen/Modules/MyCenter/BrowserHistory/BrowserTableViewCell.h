//
//  BrowserTableViewCell.h
//  juwairen
//
//  Created by tuanda on 16/5/27.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *SharpImage;
@property (weak, nonatomic) IBOutlet UILabel *SharpTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *SelectImageView;

-(void)setCellWithDic:(NSDictionary *)dic;
@end

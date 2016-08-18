//
//  AllNoResultTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/18.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AllNoResultTableViewCellDelegate <NSObject>

- (IBAction)submitClick:(id)sender;

@end
@interface AllNoResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *promptLab;

@property (nonatomic,assign) id<AllNoResultTableViewCellDelegate>delegate;

- (IBAction)submitClick:(id)sender;

@end

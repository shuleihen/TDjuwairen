//
//  TDTopicTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDTopicTableViewCell.h"
#import "TDCommentTableViewCell.h"
#import "TDAvatar.h"
#import "UIImageView+WebCache.h"

@implementation TDTopicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _avatar = [[TDAvatar alloc] initWithFrame:CGRectMake(12, 13, 40, 40)];
        [self.contentView addSubview:_avatar];
        
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 12, kScreenWidth-76, 16)];
        _nickNameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nickNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"];
        [self.contentView addSubview:_nickNameLabel];
        
        _topicTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 38, kScreenWidth-76, 16)];
        _topicTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        _topicTitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        [self.contentView addSubview:_topicTitleLabel];
        
        _topicTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _topicTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        _topicTitleLabel.numberOfLines = 0;
        _topicTimeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        [self.contentView addSubview:_topicTimeLabel];
        
        _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replyBtn setImage:[UIImage imageNamed:@"icon_reply.png"] forState:UIControlStateNormal];
        [_replyBtn addTarget:self action:@selector(replyPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_replyBtn];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
        [self.contentView addSubview:_tableView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopicCellData:(TDTopicCellData *)topicCellData {
    _topicCellData = topicCellData;
    
    self.topicTitleLabel.frame = topicCellData.topickTitleFrame;
    self.topicTimeLabel.frame = CGRectMake(64, CGRectGetMaxY(topicCellData.topickTitleFrame)+3, 140, 16);
    self.replyBtn.frame = CGRectMake(kScreenWidth-12-15, CGRectGetMaxY(topicCellData.topickTitleFrame)+3, 15, 16);
    self.tableView.frame = topicCellData.topickCommentTableViewRect;
    
    TDTopicModel *topic = topicCellData.topicModel;
    self.topicTitleLabel.text = topic.topicTitle;
    self.nickNameLabel.text = topic.userNickName;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:topic.userAvatar] placeholderImage:TDDefaultUserAvatar];
    self.topicTimeLabel.text = topic.topicTime;
    
    [self.tableView reloadData];
}

- (void)replyPressed:(id)sender {
    [self.delegate replyWithCommentId:self.topicCellData.topicModel.topicId];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicCellData.topicModel.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDCommentTableViewCellID"];
    if (cell == nil) {
        cell = [[TDCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TDCommentTableViewCellID"];
    }
    
    TDCommentCellData *cellData = self.topicCellData.topicModel.comments[indexPath.row];
    cell.commentCellData = cellData;
    cell.replyBlock = ^(NSString *commentId){
        [self.delegate replyWithCommentId:commentId];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDCommentCellData *cellData = self.topicCellData.topicModel.comments[indexPath.row];
    return cellData.cellHeight;
}
@end

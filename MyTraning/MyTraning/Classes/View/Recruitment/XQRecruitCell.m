//
//  XQRecruitCell.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQRecruitCell.h"
@interface XQRecruitCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descContentLabel;

@end
@implementation XQRecruitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItemDict:(NSDictionary *)itemDict
{
    _itemDict = itemDict;
    self.headerImageView.image = [UIImage imageNamed:[itemDict objectForKey:@"image"]];
    self.titleLabel.text = [itemDict objectForKey:@"title"];
    self.descContentLabel.text = [itemDict objectForKey:@"description"];
}



@end

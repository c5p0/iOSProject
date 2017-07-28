//
//  XQHomeCollectionViewCell.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQHomeCollectionViewCell.h"
@interface XQHomeCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *descContentLabel;

@end
@implementation XQHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setItemDict:(NSDictionary *)itemDict
{
    _itemDict = itemDict;
    self.headImageView.image = [UIImage imageNamed:[itemDict objectForKey:@"image"]];
    self.descContentLabel.text = [itemDict objectForKey:@"title"];
}
- (IBAction)itemClick:(id)sender {
}

@end

//
//  ReImageTableViewCell.m
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-9.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "ReImageTableViewCell.h"

@interface ReImageTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *contentImageView;

@end


@implementation ReImageTableViewCell

-(void)setDic:(NSDictionary *)dic
{
    [super setDic:dic];
    [self.contentImageView setImageWithURL:[NSURL URLWithString:dic[@"retweeted_status"][@"thumbnail_pic"]]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

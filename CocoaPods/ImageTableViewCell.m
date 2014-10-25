//
//  ImageTableViewCell.m
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-9.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "ImageTableViewCell.h"

@interface ImageTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *contentImage;

@end

@implementation ImageTableViewCell
-(void)setDic:(NSDictionary *)dic
{
    [super setDic:dic];
    [self.contentImage setImageWithURL:[NSURL URLWithString:dic[@"thumbnail_pic"]]];
}
@end

//
//  TextTableViewCell.m
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-8.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "TextTableViewCell.h"

@interface TextTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *weiboTextLabel;

@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) MyCellBlock block;

@end

@implementation TextTableViewCell

//获取传入的block块
-(void)setMyCellBlock:(MyCellBlock)block
{
    self.block = block;
}

//获取传入的参数，用于给我们的cell中的标签赋值
-(void) setDic:(NSDictionary *)dic
{
    
    //设置头像
   [self.headImage setImageWithURL:[NSURL URLWithString:dic[@"user"][@"profile_image_url"]]];
    
    //设置昵称
    self.nameLabel.text = dic[@"user"][@"name"];
    
    //设置时间
    NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";

    //必须设置，否则无法解析
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
   NSDate *date=[iosDateFormater dateFromString:dic[@"created_at"]];
  
     //目的格式
     NSDateFormatter *resultFormatter=[[NSDateFormatter alloc]init];
     [resultFormatter setDateFormat:@"MM月dd日 HH:mm"];
    self.dateLabel.text = [resultFormatter stringFromDate:date];
    
    //设置微博博文
    self.weiboTextLabel.text = dic[@"text"];
    
}


//通过block回调来返回按钮的tag
- (IBAction)tapCellButton:(id)sender {
    UIButton *button = sender;
    self.block(self, button.tag);
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

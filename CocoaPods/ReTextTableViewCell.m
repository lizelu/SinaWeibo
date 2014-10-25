//
//  ReTextTableViewCell.m
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-9.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "ReTextTableViewCell.h"

@interface ReTextTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *weiboTextLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textHeightConstraint;

@property (strong, nonatomic) IBOutlet UITextView *reTextView;

@end

@implementation ReTextTableViewCell

-(void)setDic:(NSDictionary *)dic
{
    [super setDic:dic];
    //移除约束
    [self removeConstraint:self.textHeightConstraint];
    
    //给据text的值求出textLabel的高度
    NSString *text = dic[@"text"];
    NSDictionary * dic1 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    CGRect frame = [text boundingRectWithSize:CGSizeMake(260, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil];
    
    //创建新的约束
    NSString *heightValue = [NSString stringWithFormat:@"V:[_weiboTextLabel(%lf)]",frame.size.height+10];
    NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:heightValue options:0 metrics:nil views:NSDictionaryOfVariableBindings(_weiboTextLabel)];
    
    self.textHeightConstraint = constraint[0];
    [self addConstraint:self.textHeightConstraint];
    
    self.weiboTextLabel.text = text;
    
    self.reTextView.text = dic[@"retweeted_status"][@"text"];

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

//
//  TextTableViewCell.h
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-8.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import <UIKit/UIKit.h>

//TableView要回调的block,用于把cell中的按钮的tag传给TableView
typedef  void (^MyCellBlock) (UITableViewCell * cell, int tag);

@interface TextTableViewCell : UITableViewCell
//接收block块
-(void)setMyCellBlock:(MyCellBlock) block;

//接收字典
-(void) setDic:(NSDictionary *)dic;

@end

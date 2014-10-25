//
//  MainTableViewController.h
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-8.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UITableViewController
//接收请求参数
@property (nonatomic, strong) NSArray *dataSource;

//声明AF的管理者
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, assign) int count;

@property (nonatomic, assign) NSString *user_token;

@property (nonatomic, strong) NSUserDefaults *user;

@property (nonatomic, strong) NSString *url;

- (IBAction)tapRefresh:(id)sender;
- (IBAction)tapMore:(id)sender;


@end

//
//  PublicTableViewController.m
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-15.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "PublicTableViewController.h"

@interface PublicTableViewController ()

@end

@implementation PublicTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self tapRefresh:nil];
}
- (IBAction)tapRefresh:(id)sender {
    super.url = public_timeline;
    [super tapRefresh:sender];
}



- (IBAction)tapMore:(id)sender {
    [super tapMore:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  UserTableViewController.m
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-15.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "UserTableViewController.h"

@interface UserTableViewController ()

@end

@implementation UserTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self tapRefresh:nil];
}
- (IBAction)tapRefresh:(id)sender {
    super.url = user_timeline;
    [super tapRefresh:sender];
}

- (IBAction)tapLoginOut:(id)sender {
    
       NSUserDefaults *test = [NSUserDefaults standardUserDefaults];
    [test removeObjectForKey:@"token"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
   UIViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    
    [self presentViewController:login animated:YES completion:^{
    }];

    
    
    
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

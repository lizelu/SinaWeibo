//
//  LoginViewController.m
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-15.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *bgImage = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login.jpg"]];
    self.view.backgroundColor = bgImage;
    
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tapLogin:) userInfo:nil repeats:NO];
    
    // Do any additional setup after loading the view.
}
- (IBAction)tapLogin:(id)sender {
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = myRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginViewController"};
    [WeiboSDK sendRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"收到网络回调";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];


}

-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];


}

-(void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{

    
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

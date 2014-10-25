//
//  CommentsTableViewController.m
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-8.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "CommentsTableViewController.h"
#import "TextTableViewCell.h"

@interface CommentsTableViewController ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) UIBarButtonItem *barButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refrashBar;

@property (strong, nonatomic) NSUserDefaults *user;
@end

@implementation CommentsTableViewController

- (IBAction)tapRefresh:(id)sender {
    
    //请求评论数拼接参数
    NSDictionary *dic = @{@"access_token":[self.user objectForKey:@"token"], @"id":self.userInfo[@"id"]};
    
    
    
    __weak __block CommentsTableViewController *copy_self = self;
    
    AFHTTPRequestOperation *operation = [self.manager GET:comments parameters:dic success:^(AFHTTPRequestOperation *operation, NSData *data) {
        
        NSError *error = nil;
        
        NSDictionary * tempDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        copy_self.dataSource = tempDic[@"comments"];
        
        [copy_self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网路异常");
    }];
    
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation start];
    
    if ([sender isKindOfClass:[UIRefreshControl class]]) {
        [sender endRefreshing];
    }

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [NSUserDefaults standardUserDefaults];
    
    
    self.barButton = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStyleDone target:self action:@selector(tapBar:)];

    self.navigationItem.rightBarButtonItems = @[self.refrashBar,self.barButton];
    
    self.manager = [[AFHTTPRequestOperationManager alloc] init];
    
    [self tapRefresh:nil];
}

-(void) tapBar : (UIBarButtonItem *) sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *des = [storyboard instantiateViewControllerWithIdentifier:@"CommentView"];
    
    
    
    [des setValue:self.userInfo forKeyPath:@"userInfo"];
    
    [self.navigationController pushViewController:des animated:YES];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataSource.count;
}

//根据微博博文调整cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取要显示的博文
    NSString *text = self.dataSource[indexPath.row][@"text"];
    
    NSDictionary * dic1 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    CGRect frame = [text boundingRectWithSize:CGSizeMake(260, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil];
    
    CGFloat height = frame.size.height + 70;
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取cell中的数据
    NSDictionary *dataDic = self.dataSource[indexPath.row];
    
    TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
    
    [cell setDic:dataDic];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

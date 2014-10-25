//
//  MainTableViewController.m
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-8.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "MainTableViewController.h"
#import "TextTableViewCell.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController
- (IBAction)tapRefresh:(id)sender {
    
    
    //用AFNetWorking Get请求的参数
    NSDictionary *dic = @{@"access_token" : [self.user objectForKey:@"token"], @"count" : @(self.count)};
    
    //发起请求
    
    __weak __block MainTableViewController *copy_self = self;
    
    AFHTTPRequestOperation *afOp = [self.manager GET:self.url parameters:dic success:^(AFHTTPRequestOperation *operation, NSData *mydate) {
        
        NSError *error = nil;
        
        //对相应结果的解析
        NSDictionary *tempData = [NSJSONSerialization JSONObjectWithData:mydate options:NSJSONReadingAllowFragments error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return ;
        }
        
        //NSLog(@"%@",tempData[@"statuses"]);
        
        //从请求中取出我们想要的值
        copy_self.dataSource = tempData[@"statuses"];
        
        //重新加载tableView,不然表格上没有数据
        [copy_self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
    //设置解析方式
    afOp.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [afOp start];
    
    if ([sender isKindOfClass:[UIRefreshControl class]]) {
        [sender endRefreshing];
    }

    
}
- (IBAction)tapMore:(id)sender {
    self.count += 10;
    [self tapRefresh:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [NSUserDefaults standardUserDefaults];

    //初始化manager
    self.manager = [[AFHTTPRequestOperationManager alloc] init];
    self.count = 10;
    self.url = home_timeline;
    
    
    [self tapRefresh:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


//根据微博博文调整cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataSource.count-1) {
        //获取要显示的博文
        NSString *text = self.dataSource[indexPath.row][@"text"];
        
        NSDictionary * dic1 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        
        CGRect frame = [text boundingRectWithSize:CGSizeMake(260, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil];
        
        CGFloat height;
        
        if (self.dataSource[indexPath.row][@"thumbnail_pic"] == nil)
        {
            if (self.dataSource[indexPath.row][@"retweeted_status"])
            {
                //获取要显示的博文
                NSString *text1 = self.dataSource[indexPath.row][@"retweeted_status"][@"text"];
                
                CGRect frame1 = [text1 boundingRectWithSize:CGSizeMake(260, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil];
                
                if (self.dataSource[indexPath.row][@"retweeted_status"][@"thumbnail_pic"])
                {
                    height = frame.size.height + 210 +frame1.size.height;
                }
                else
                {
                    height = frame.size.height + 110 +frame1.size.height;
                
                }
            }
            else
            {
             height = frame.size.height + 110;
            }
        }
        else
        {
            height = frame.size.height + 200;
        }

        return height;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextTableViewCell *cell;
    
    if (indexPath.row < self.dataSource.count-1) {
        //获取cell中的数据
        NSDictionary *dataDic = self.dataSource[indexPath.row];
        
        
        
        if (dataDic[@"thumbnail_pic"] == nil)
        {
            if (dataDic[@"retweeted_status"])
            {
                if (dataDic[@"retweeted_status"][@"thumbnail_pic"])
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"reimageCell" forIndexPath:indexPath];
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"retextCell" forIndexPath:indexPath];
                }
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
            }
            
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
        }
        
        
        
        
        
        [cell setDic:dataDic];
        
        //回调点击cell中的按钮触发的block
        
        __weak __block MainTableViewController *copy_self = self;
        
        [cell setMyCellBlock:^(UITableViewCell *cell, int tag) {
            
            switch (tag) {
                case 1:
                {
                    NSLog(@"转发");
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    
                    id vc = [storyboard instantiateViewControllerWithIdentifier:@"CommentView"];
                    
                    [vc setValue:dataDic forKeyPath:@"userInfo"];
                    [vc setValue:@1 forKeyPath:@"tag"];
                    [copy_self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                    
                case 2:
                {
                    NSLog(@"评论");
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    
                    id vc = [storyboard instantiateViewControllerWithIdentifier:@"CommentView"];
                    
                    [vc setValue:dataDic forKeyPath:@"userInfo"];
                    [vc setValue:@2 forKeyPath:@"tag"];
                    
                    [copy_self.navigationController pushViewController:vc animated:YES];
                    
                    
                }
                    break;
                    
                case 3:
                {
                    NSLog(@"赞");
                    
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    }
    else
    {
         cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell" forIndexPath:indexPath];
    }
    
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TextTableViewCell *cell = sender;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    
    id vc = segue.destinationViewController;
    [vc setValue:dic forKeyPath:@"userInfo"
     ];
}


@end

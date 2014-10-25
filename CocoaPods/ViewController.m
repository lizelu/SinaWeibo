//
//  ViewController.m
//  CocoaPods
//
//  Created by ibokan on 14-9-2.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "ViewController.h"

#import "ToolView.h"
#import "FunctionView.h"
#import "ImageModelClass.h"
#import "HistoryImage.h"
#import "MoreView.h"



@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UITextView *commentsTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstrains;


@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@property (strong, nonatomic) NSUserDefaults *user ;


//自定义组件
@property (nonatomic, strong) ToolView *toolView;

@property (nonatomic, strong) FunctionView *functionView;

@property (nonatomic, strong) MoreView *moreView;

//系统组件

@property (strong, nonatomic) NSDictionary *keyBoardDic;

@property (strong, nonatomic) NSString *sendString;

//数据model
@property (strong, nonatomic) ImageModelClass  *imageMode;

@property (strong, nonatomic)HistoryImage *tempImage;









@end

@implementation ViewController


-(void)post:(NSString *)strUrl Content:(NSString *)state
{
    

        
        NSURL *url = [NSURL URLWithString:strUrl];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"POST";
        
        NSString *str = [NSString stringWithFormat:@"access_token=%@&id=%@&%@=%@",[self.user objectForKey:@"token"],self.userInfo[@"id"],state,self.commentsTextView.text];
        
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        request.HTTPBody = data;
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSError *error;
            
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (error) {
                
                NSLog(@"%@", [error localizedDescription]);
                
            }
            
            NSLog(@"%@", dic);
            
        }];     

}


- (IBAction)tapComments:(id)sender {
    
if (![self.commentsTextView.text isEqualToString:@""]) {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    id vc;
    if ([self.tag isEqualToValue:@2])
    {
        [self post:comments_create Content:@"comment"];
        vc = [storyboard instantiateViewControllerWithIdentifier:@"CommentList"];
       
        [vc setValue:self.userInfo forKeyPath:@"userInfo"];
        [vc viewDidLoad];

        
    }
    if ([self.tag isEqualToValue:@1])
    {
        [self post:repost_test Content:@"status"];
         vc = [storyboard instantiateViewControllerWithIdentifier:@"guanzhu"];
        [vc viewDidLoad];
       
        
    }
    
    
    [self.navigationController pushViewController:vc animated:YES];
}

}
- (IBAction)tapDone:(id)sender {
    [self.commentsTextView resignFirstResponder];
}

//手势切换键盘
- (IBAction)tapS:(UITapGestureRecognizer *)sender
{
    self.commentsTextView.inputView = nil;
    
    if ([self.commentsTextView isFirstResponder])
    {
        [self.commentsTextView reloadInputViews];
    }
    else
    {
        [self.commentsTextView becomeFirstResponder];
    }
    
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.user = [NSUserDefaults standardUserDefaults];
    
    
    //TextView的键盘定制回收按钮
    UIToolbar * toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapDone:)];
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * item3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[item2,item1,item3];
    
    self.commentsTextView.inputAccessoryView =toolBar;
    
    if ([self.tag isEqualToValue:@2]) {
        self.navigationItem.title = @"我要评论";
    }
    if ([self.tag isEqualToValue:@1]) {
        self.navigationItem.title = @"我要转发";
    }

    
    self.commentsTextView.delegate = self;
    
    [self.headImage setImageWithURL:[NSURL URLWithString:self.userInfo[@"user"][@"profile_image_url"]]];
    self.titleLabel.text = self.userInfo[@"user"][@"name"];
    
    //设置时间
    NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    
    //必须设置，否则无法解析
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *date=[iosDateFormater dateFromString:self.userInfo[@"created_at"]];
    
    //目的格式
    NSDateFormatter *resultFormatter=[[NSDateFormatter alloc]init];
    [resultFormatter setDateFormat:@"MM月dd日 HH:mm"];
    self.dateLabel.text = [resultFormatter stringFromDate:date];
    
  
    
    //设置新的约束
    [self.view removeConstraint:self.heightConstrains];
    NSString *content = self.userInfo[@"text"];
    NSDictionary * dic1 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGRect frame = [content boundingRectWithSize:(CGSizeMake(240, 1000)) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil];
    CGFloat height = frame.size.height;
    
    
    NSString *heightValue = [NSString stringWithFormat:@"V:[_contentLabel(%lf)]", height];
    
    
    
    NSArray * heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:heightValue options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentLabel)];
    
    self.heightConstrains = heightConstraint[0];
    [self.view addConstraint:self.heightConstrains];
    self.contentLabel.text = content;
    
 ///////表情键盘
//    //从sqlite中读取数据
    self.imageMode = [[ImageModelClass alloc] init];
    
    //实例化FunctionView
    self.functionView = [[FunctionView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    self.functionView.backgroundColor = [UIColor blackColor];

    //设置资源加载的文件名
    self.functionView.plistFileName = @"emoticons";
    
      __weak __block ViewController *copy_self = self;
    //获取图片并显示
    [self.functionView setFunctionBlock:^(UIImage *image, NSString *imageText)
     {
         NSString *str = [NSString stringWithFormat:@"%@%@",copy_self.commentsTextView.text, imageText];
         
         copy_self.commentsTextView.text = str;
         
         //把使用过的图片存入sqlite
         NSData *imageData = UIImagePNGRepresentation(image);
         [copy_self.imageMode save:imageData ImageText:imageText];
     }];
    
    
    //实例化MoreView
    self.moreView = [[MoreView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.moreView.backgroundColor = [UIColor blackColor];
    [self.moreView setMoreBlock:^(NSInteger index) {
        NSLog(@"MoreIndex = %d",index);
    }];
    
    
    
    //进行ToolView的实例化
    self.toolView = [[ToolView alloc] initWithFrame:CGRectZero];
    self.toolView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.toolView];
    
    //给ToolView添加约束
    //开启自动布局
    self.toolView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //水平约束
    NSArray *toolHConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_toolView)];
    [self.view addConstraints:toolHConstraint];
    
    //垂直约束
    NSArray *toolVConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolView(44)]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_toolView)];
    [self.view addConstraints:toolVConstraint];
    
    
 
    //回调toolView中的方法
    [self.toolView setToolIndex:^(NSInteger index)
     {
         NSLog(@"%d", index);
         
         switch (index) {
             case 1:
                 [copy_self changeKeyboardToFunction];
                 break;
                 
             case 2:
                 [copy_self changeKeyboardToMore];
                 break;
                 
             default:
                 break;
         }
         
     }];
    
    
    //当键盘出来的时候通过通知来获取键盘的信息
    //注册为键盘的监听着
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];

}


//表情使用函数
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //纵屏
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        CGRect frame = self.functionView.frame;
        frame.size.height = 216;
        self.functionView.frame = frame;
        self.moreView.frame = frame;
        
    }
    //横屏
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        CGRect frame = self.functionView.frame;
        frame.size.height = 150;
        self.functionView.frame = frame;
        self.moreView.frame = frame;
    }
    
    
}


//当键盘出来的时候改变toolView的位置（接到键盘出来的通知要做的方法）
-(void) keyNotification : (NSNotification *) notification
{
    
    self.keyBoardDic = notification.userInfo;
    //获取键盘移动后的坐标点的坐标点
    CGRect rect = [self.keyBoardDic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    //把键盘的坐标系改成当前我们window的坐标系
    CGRect r1 = [self.view convertRect:rect fromView:self.view.window];
    
    [UIView animateWithDuration:[self.keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        //动画曲线
        [UIView setAnimationCurve:[self.keyBoardDic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        
        CGRect frame = self.toolView.frame;
        CGRect textViewFrame = self.commentsTextView.frame;
        
        frame.origin.y = r1.origin.y - frame.size.height;
        textViewFrame.size.height = 100;
        textViewFrame.origin.y = frame.origin.y - textViewFrame.size.height-22;
        
        
        //根据键盘的高度来改变toolView的高度
        self.toolView.frame = frame;
        self.commentsTextView.frame = textViewFrame;
    }];
}


//切换键盘的方法
-(void) changeKeyboardToFunction
{
    if ([self.commentsTextView.inputView isEqual:self.functionView])
    {
        self.commentsTextView.inputView = nil;
        [self.commentsTextView reloadInputViews];
    }
    else
    {
        self.commentsTextView.inputView = self.functionView;
        [self.commentsTextView reloadInputViews];
    }
    
    if (![self.commentsTextView isFirstResponder])
    {
        [self.commentsTextView becomeFirstResponder];
    }
}


-(void) changeKeyboardToMore
{
    if ([self.commentsTextView.inputView isEqual:self.moreView]) {
        self.commentsTextView.inputView = nil;
    }
    else
    {
        self.commentsTextView.inputView = self.moreView;
    }
    [self.commentsTextView reloadInputViews];
    
    if (![self.commentsTextView isFirstResponder])
    {
        [self.commentsTextView becomeFirstResponder];
    }
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

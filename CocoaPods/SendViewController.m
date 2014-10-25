//
//  SendViewController.m
//  CocoaPods
//
//  Created by 李泽鲁 on 14-9-18.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "SendViewController.h"
#import "FunctionView.h"
#import "ImageModelClass.h"
#import "HistoryImage.h"
#import "MoreView.h"
@interface SendViewController ()
@property (strong, nonatomic) IBOutlet UITextView *myTextView;
@property (nonatomic, strong) FunctionView *functionView;


@property (nonatomic, strong) MoreView *moreView;

//数据model
@property (strong, nonatomic) ImageModelClass  *imageMode;

@property (strong, nonatomic)HistoryImage *tempImage;

@property (strong, nonatomic) NSDictionary *keyBoardDic;

//存储纯文本的微博内容
@property (strong, nonatomic) NSString *sentText;


@end

@implementation SendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    //TextView的键盘定制回收按钮
    UIToolbar * toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapDone:)];
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tool1.png"] style:UIBarButtonItemStyleDone target:self action:@selector(changeKeyboardToFunction)];
    
    
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * item3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[item2,item0,item1,item3];
    
    self.myTextView.inputAccessoryView =toolBar;
    
    
    // Dispose of any resources that can be recreated.
    //    //从sqlite中读取数据
    self.imageMode = [[ImageModelClass alloc] init];
    
    //实例化FunctionView
    self.functionView = [[FunctionView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    self.functionView.backgroundColor = [UIColor blackColor];
    
    //设置资源加载的文件名
    self.functionView.plistFileName = @"emoticons";
    
    __weak __block SendViewController *copy_self = self;
    //获取图片并显示
    [self.functionView setFunctionBlock:^(UIImage *image, NSString *imageText)
     {
         NSString *str = [NSString stringWithFormat:@"%@%@",copy_self.myTextView.text, imageText];
         
         copy_self.myTextView.text = str;
         
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
    
    
    
    //当键盘出来的时候通过通知来获取键盘的信息
    //注册为键盘的监听着
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(keyboard) userInfo:nil repeats:NO];
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


//弹出键盘
-(void)keyboard
{
    [self.myTextView becomeFirstResponder];
}

- (IBAction)sentMessage:(id)sender {
    if (![self.myTextView.text isEqualToString:@""])
    {
        AFHTTPRequestOperationManager *mamager = [[AFHTTPRequestOperationManager alloc] init];
        //获取用户的token
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userToken = [defaults objectForKey:@"token"];
        
        NSDictionary *dataDic = @{@"access_token":userToken,
                                  @"status":self.myTextView.text};
        
        NSString *url = SENTMESSAGE;
        
        //执行post请求
        AFHTTPRequestOperation *op = [mamager POST:url parameters:dataDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"发送成功");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
            
        }];
        
        op.responseSerializer = [AFHTTPResponseSerializer serializer];
        [op start];
        
        //获取storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"weiboList"];
        //推到首页
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}

- (IBAction)tapDone:(id)sender {
    [self.myTextView resignFirstResponder];
    
}


//手势切换键盘
- (IBAction)tapS:(UITapGestureRecognizer *)sender
{
    self.myTextView.inputView = nil;
    
    if ([self.myTextView isFirstResponder])
    {
        [self.myTextView reloadInputViews];
    }
    else
    {
        [self.myTextView becomeFirstResponder];
    }
    
}



//切换键盘的方法
-(void) changeKeyboardToFunction
{
    if ([self.myTextView.inputView isEqual:self.functionView])
    {
        self.myTextView.inputView = nil;
        [self.myTextView reloadInputViews];
    }
    else
    {
        self.myTextView.inputView = self.functionView;
        [self.myTextView reloadInputViews];
    }
    
    if (![self.myTextView isFirstResponder])
    {
        [self.myTextView becomeFirstResponder];
    }
}


-(void) keyNotification : (NSNotification *) notification
{
    
    self.keyBoardDic = notification.userInfo;
    NSLog(@"%@", self.keyBoardDic);
    //获取键盘移动后的坐标点的坐标点
    CGRect rect = [self.keyBoardDic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    //把键盘的坐标系改成当前我们window的坐标系
    CGRect r1 = [self.view convertRect:rect fromView:self.view.window];
    
    [UIView animateWithDuration:[self.keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        //动画曲线
        [UIView setAnimationCurve:[self.keyBoardDic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];

        CGRect textViewFrame = self.myTextView.frame;
        
        textViewFrame.size.height = r1.origin.y - textViewFrame.origin.y -10;
        NSLog(@"%lf", textViewFrame.size.height);
        self.myTextView.frame = textViewFrame;

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

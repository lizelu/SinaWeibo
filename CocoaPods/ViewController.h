//
//  ViewController.h
//  CocoaPods
//
//  Created by ibokan on 14-9-2.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface ViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) NSDictionary *userInfo;

@property (strong, nonatomic) NSNumber *tag;

@end

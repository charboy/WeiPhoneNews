//
//  AppDelegate.h
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//
/*//解决 切换页面过快 因页面已经释放 但是异步请求还在下载 而造成的崩溃  1、加属性@property(retain,nonatomic)NSURLConnection *currentURLCon;//（课堂学的下载方式）
@property(retain,nonatomic)ASIHTTPRequest *req;//（ASI的下载方式）   2、在切换界面时  停止请求[self.currentURLCon cancel];
[self.req cancel];*/


#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end

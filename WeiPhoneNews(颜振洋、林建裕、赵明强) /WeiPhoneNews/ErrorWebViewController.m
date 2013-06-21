//
//  ErrorWebViewController.m
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//

#import "ErrorWebViewController.h"

@interface ErrorWebViewController ()

@end

@implementation ErrorWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //威锋新闻标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 38/2*4,38/2 )];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:38/2];
    titleLabel.text = @"威锋新闻";
    titleLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0  blue:255.0/255.0  alpha:1];
    titleLabel.shadowColor = [UIColor colorWithRed:25.0/255.0 green:87.0/255.0 blue:126.0/255.0 alpha:1];
    
    titleLabel.shadowOffset = CGSizeMake(0.0f, -2.0f);//阴影向上投影2像素
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 38/2*4,38/2 )];
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    
    
    UIView*viewTitle=[[UIView alloc]initWithFrame:CGRectMake(0,22, 320, 44)];
    viewTitle.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg3"]];
    [self.navigationController.view addSubview:viewTitle];
    self.wordLab1.textColor=[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1];
    self.wordLab2.textColor=[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1];
    //添加一个单击手势
    UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(tapAction)];
    tapGesture.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];
}
-(void)tapAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_imgviewError release];
    [_wordLab1 release];
    [_wordLab2 release];
    [super dealloc];
}
@end

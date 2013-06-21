//
//  WebViewController.h
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "WebNewsCell.h"
#import <QuartzCore/QuartzCore.h>

@interface WebViewController : UIViewController<ASIHTTPRequestDelegate,UIScrollViewDelegate,NSURLConnectionDataDelegate,UITableViewDataSource,UITableViewDelegate>

//存放网络解析到的数据
@property (retain, nonatomic) NSArray *urlArray;//正文数组
@property (copy, nonatomic) NSString *titleStr;//标题
@property (copy, nonatomic) NSString *dateStr;//日期
@property (copy, nonatomic) NSString *clickStr;//点击量
@property (copy, nonatomic) NSString *sourceStr;//来源
@property (copy, nonatomic) NSString *imageStr;//图片
@property (assign, nonatomic) CGFloat cellAddHight;//单元格要增加的高度
@property (assign,nonatomic) int addComment;//添加更多单元格的参数
@property (copy, nonatomic) NSString *mst;//更多评论

@property (retain, nonatomic) NSArray *commentArray;//评论数组
@property (copy, nonatomic) NSString *jsResult;//解析评论接口结果

//将要访问网页的地址，属性传参用
@property (copy,nonatomic) NSString *willToUrl;//接收上一页面传过来的网址
@property (retain,nonatomic) NSArray *weiArrayt;//
@property (retain,nonatomic) NSMutableData *getData;

//显示摘取内容的视图组件
@property (retain,nonatomic) UIScrollView *scrollView;//放置新闻、评论视图组件的滚动视图
@property (retain,nonatomic) UIView *mainView ;//承载新闻内容的视图组件
@property (retain,nonatomic) UIView *commentView;//承载评论内容的视图组件

@property (retain,nonatomic) UIImage *imageOnText;//图片
@property (retain,nonatomic) UIImageView *imageView;//显示图片的视图

@property (retain,nonatomic) UILabel *titleLabel;//标题
@property (retain,nonatomic) UILabel *sourceLabel;//来源
@property (retain,nonatomic) UILabel *textLabel;//正文
@property (retain,nonatomic) UILabel *headTextLB;//文章引言部分
@property (retain,nonatomic) UILabel *numberOfComment;//玩家点评

@property (retain,nonatomic) UITableView *commentTable;//评论列表

//同步推链接
@property (retain,nonatomic) UILabel *tbt;//提示有链接
@property (retain,nonatomic)UIButton * tbtWeb;//网址

//更多评论
@property (retain,nonatomic) UIButton *moreCommentBT;//更多评论按钮
@property (retain,nonatomic) UIView *moreCommentV;

@property (retain,nonatomic) NSArray*sortedDateArray;
@property (assign,nonatomic) int inde;

@property (retain,nonatomic) UILabel *moreComST;//剩下的评论
@end
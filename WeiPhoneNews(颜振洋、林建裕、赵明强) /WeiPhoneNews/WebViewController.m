//
//  WebViewController.m
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//

#import "WebViewController.h"
#import "ASIHTTPRequest.h"
#import "TFHpple.h"
#import "ASIHTTPRequest.h"
#import "GetDataFromHTML.h"//用于解析HTML数据
#import "WebNewsCell.h"
#import "GetLabelHight.h"//Label根据文字内容自适应高度
#import "CommentCell.h"//定制的评论单元格
#import "JSON.h"//解析包
#import "News.h"


@interface WebViewController ()

@end

@implementation WebViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        self.willToUrl = [[[NSString alloc]init]autorelease];
        self.imageOnText = [[[UIImage alloc]init]autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0  alpha:1];
    
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
    
    //连接主页传送过来的网址
//    NSLog(@"收到的网址%@",self.willToUrl);
    
    //调用异步连接方法，与主页传来的网址连接
    //    NSURL *weiPhoneUrl = [NSURL URLWithString:self.willToUrl];
    //    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:weiPhoneUrl];
    //    request.delegate = self;//ASIHTTPRequest.h 协议的代理
    //    [request startAsynchronous];//开启异步连接
    [self asiHttpReqAs:self.willToUrl];
    
    
    //返回按键
    UIButton *back=[[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 30)]autorelease];
    [back setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:back]autorelease];
    
    //制作上下翻页按钮
    //存放按钮的视图buttonsView
    UIView *buttonsView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)]autorelease];
    //设置上翻页按钮
    UIButton *up = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 49, 30)]autorelease];
    [up setBackgroundImage:[UIImage imageNamed:@"nav_left.png"] forState:UIControlStateNormal];
    //添加浏览上条新闻的方法
    [up addTarget:self action:@selector(lastNews) forControlEvents:UIControlEventTouchUpInside];
    
    //间隔按钮的中间按钮
    UIButton *center = [[[UIButton alloc]initWithFrame:CGRectMake(49, 0, 1, 29)]autorelease];
    [center setBackgroundImage:[UIImage imageNamed:@"nav_center.png"] forState:UIControlStateNormal];
    //下翻页按钮
    UIButton *down = [[[UIButton alloc]initWithFrame:CGRectMake(50, 0, 48.5, 30)]autorelease];
    [down setBackgroundImage:[UIImage imageNamed:@"nav_right.png"] forState:UIControlStateNormal];
    //添加浏览上条新闻的方法
    [down addTarget:self action:@selector(nestNews) forControlEvents:UIControlEventTouchUpInside];
    
    //将三个按钮添加进buttonsView
    [buttonsView addSubview:up];
    [buttonsView addSubview:center];
    [buttonsView addSubview:down];
    //将buttonsView转换为BarButtonItem
    UIBarButtonItem *buttonsBar = [[[UIBarButtonItem alloc]initWithCustomView:buttonsView]autorelease];
    //将建好的buttonsBar添加进导航条
    self.navigationItem.rightBarButtonItem = buttonsBar;
    
    
    //承载视图组件的滚动视图
    self.scrollView = [[[UIScrollView alloc]initWithFrame:CGRectZero]autorelease];
    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.delegate = self;//将自身作为代理的目的是为了页面效果能够显示当前的页面
    //    self.scrollView.contentSize = CGSizeMake(320, self.scrollView.frame.size.height);//设置页面的长度
    self.scrollView.pagingEnabled = NO;//不一页一页的翻
    //self.scrollView.showsVerticalScrollIndicator = NO;
    
    //承载新闻内容的main视图
    self.mainView = [[UIView alloc]initWithFrame:CGRectZero];
    _mainView.layer.cornerRadius = 10;
    _mainView.backgroundColor = [UIColor whiteColor];
    
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1];
    self.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:34/2];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;//文字居中
    
    //来源
    self.sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 52/2+5+34, 290, 24/2)];
    self.sourceLabel.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
    self.sourceLabel.textAlignment = NSTextAlignmentCenter;
    self.sourceLabel.font = [UIFont systemFontOfSize:12];
    
    //文章引言部分
    self.headTextLB = [[UILabel alloc]initWithFrame:CGRectZero];
    self.headTextLB.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:0.9];
    
    self.headTextLB.backgroundColor = [UIColor clearColor];
    self.headTextLB.font = [UIFont systemFontOfSize:15];
    
    //正文Label
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.textLabel.backgroundColor = [UIColor clearColor];////////
    self.textLabel.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:0.9];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    
    //图片框
    self.imageView = [[[UIImageView alloc]initWithFrame:CGRectZero]autorelease];
    
    
    //获得评论的方法
    [self jsonTheCommentOfWeb:self.willToUrl];
    
    //评论视图
    self.commentView = [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
    self.commentView.layer.cornerRadius = 10;
    self.commentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.commentView];
    UIImageView *newImage = [[UIImageView alloc]initWithFrame:CGRectMake(310-71, -1, 72, 72)];
    newImage.image = [UIImage imageNamed:@"new.png"];
    
    //玩家点评
    self.numberOfComment = [[UILabel alloc]initWithFrame:CGRectMake(11, 14, 110, 14)];
    self.numberOfComment.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    self.numberOfComment.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1];
    self.numberOfComment.text = [NSString stringWithFormat:@"玩家点评(%d)",self.commentArray.count];
    
    //评论列表
    self.commentTable = [[UITableView alloc]initWithFrame:CGRectMake(11, 32, 310-22, 300) style:UITableViewStylePlain];
    self.commentTable.delegate = self;
    self.commentTable.dataSource =self;
    
    //点击获得更多评论
    self.moreCommentV = [[UIView alloc]initWithFrame:CGRectMake(11, 330, 280, 50)];
    self.moreCommentV.layer.cornerRadius = 25;
    self.moreCommentV.layer.borderWidth = 1;
    self.moreCommentV.layer.borderColor = [UIColor grayColor].CGColor;
    self.moreCommentV.backgroundColor = [UIColor whiteColor];
    UIImageView *moreImage = [[UIImageView alloc]initWithFrame:CGRectMake(70, 12, 33, 30)];
    //moreImage.mutableCopy
    moreImage.image = [UIImage imageNamed:@"more.png"];
    
    
    
    
    //"更多"按钮
    self.moreCommentBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreCommentBT.frame = CGRectMake(100, 11, 80, 30);
    //    self.moreCommentBT.backgroundColor = [UIColor blackColor];
    //    NSString *coStr = [NSString stringWithFormat:@"更多评论（%d）",self.commentArray.count];
    [self.moreCommentBT setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0] forState:UIControlStateNormal] ;
    [self.moreCommentBT setTitle:@"更多评论" forState:UIControlStateNormal];
    [self.moreCommentBT addTarget:self action:@selector(moreUserComment) forControlEvents:UIControlEventTouchUpInside];
    //剩下的评论
    self.moreComST = [[UILabel alloc]initWithFrame:CGRectMake(180, 10, 80, 30)];
    _moreComST.textColor = [UIColor colorWithRed:99.0f/255.0f green:99.0f/255.0f blue:99.0f/255.0f alpha:1.0];
    //moreComST.backgroundColor = [UIColor blackColor];//
    
    
    //显示剩余评论内容
    if (self.commentArray.count>0) {
        if (self.commentArray.count-2>0) {
            self.mst = [NSString stringWithFormat:@"(%d)",self.commentArray.count-2];
        }
        else{
            self.mst = @"(0)";
        }
        if (self.commentArray.count == 1) {
            self.mst = @"(0)";
        }
        
    }
    //显示剩余评论内容
    _moreComST.text = _mst;
    
    
    //"同步推"
    self.tbt = [[UILabel alloc]initWithFrame:CGRectZero];
    _tbt.text = @"更多精彩咨询，请访问";
    //同步推链接
    self.tbtWeb = [UIButton buttonWithType:UIButtonTypeCustom];
    // self.tbtWeb.backgroundColor = [UIColor blackColor];
    [self.tbtWeb  setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:150.0f/255.0f blue:227.0f/255.0f alpha:1.0] forState:UIControlStateNormal] ;
    [self.tbtWeb setTitle:@"http://news.tongbu.com/" forState:UIControlStateNormal];
    [self.tbtWeb addTarget:self action:@selector(connectUrl) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:_mainView];
    [_mainView addSubview:self.titleLabel];
    
    [_mainView addSubview:self.imageView];
    [self.mainView addSubview:self.sourceLabel];
    [self.mainView addSubview:self.textLabel];
    [self.mainView addSubview:self.headTextLB];
    [self.mainView addSubview:self.tbt];
    
    [self.commentView addSubview:self.commentTable];
    [self.commentView addSubview:self.numberOfComment];
    [self.mainView addSubview:self.tbtWeb];
    [self.commentView addSubview:newImage];
    [self.commentView addSubview:self.moreCommentV];
    [self.moreCommentV addSubview:self.moreCommentBT];
    
    [self.moreCommentV addSubview:moreImage];
    [self.moreCommentV addSubview:_moreComST];
}

//网站异步下载的方法。参数：网络地址
- (void) asiHttpReqAs:(NSString *)sender//http://bbs.weiphone.com/read-htm-tid-6567671.html
{
    NSURL *weiPhoneUrl = [NSURL URLWithString:sender];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:weiPhoneUrl];
    request.delegate = self;//ASIHTTPRequest.h 协议的代理
    [request startAsynchronous];//开启异步连接
}
int flag001=1001;

//更多评论内容
- (void)moreUserComment
{
    if (flag001==1001) {
        flag001=1002;
        self.moreComST.text = @" ";
        [self.commentTable reloadData];
    }
//    NSLog(@"更多评论内容");
//    NSLog(@"添加的评论：%d",self.commentArray.count -2);
    
}


//同步推链接方法
- (void)connectUrl
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://news.tongbu.com/"]];
}

//返回主页方法
- (void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//浏览上条新闻
- (void)lastNews
{
    
    if(self.inde>0)
    {
        News*objectNews=[self.sortedDateArray objectAtIndex:--self.inde];
        self.willToUrl = objectNews.web;//获得上页面对应的网络地址
        self.clickStr =objectNews.lookNo;
        self.titleStr = objectNews.newsTitle;
        self.dateStr = objectNews.date;
        
        
        NSURL *weiPhoneUrl = [NSURL URLWithString:self.willToUrl];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:weiPhoneUrl];
        request.delegate = self;//ASIHTTPRequest.h 协议的代理
        [request startAsynchronous];//开启异步连接
        
        //重新解析与更新网页对应的评论内容
        [self jsonTheCommentOfWeb:objectNews.web];
        if (self.commentArray.count ==0) {
            self.numberOfComment.text = @"玩家点评(0)";
            _moreComST.text = @"(0)";
        }
        [self.commentTable reloadData];
    }
}

//浏览下条新闻
- (void)nestNews
{
    if(self.inde<self.sortedDateArray.count-1){
        News*objectNews=[self.sortedDateArray objectAtIndex:++self.inde];
        self.willToUrl = objectNews.web;
        self.clickStr =objectNews.lookNo;
        self.titleStr = objectNews.newsTitle;
        self.dateStr = objectNews.date;
        
        NSURL *weiPhoneUrl = [NSURL URLWithString:self.willToUrl];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:weiPhoneUrl];
        request.delegate = self;//ASIHTTPRequest.h 协议的代理
        [request startAsynchronous];//开启异步连接
        
        //重新解析与更新网页对应的评论内容
        [self jsonTheCommentOfWeb:objectNews.web];
        if (self.commentArray.count ==0) {
            self.numberOfComment.text = @"玩家点评(0)";
            _moreComST.text = @"(0)";
        }
        [self.commentTable reloadData];
    }
    else
    {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"对不起，已经是最后一条新闻，想浏览更多，请回首页更新新闻" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }
}

//对获得的评论接口进行json解析方法。 传递的参数：与详细页对应的网络地址
- (void)jsonTheCommentOfWeb:(NSString *)sender
{
    //----------------JSON解析评论内容
    //截取形如http://www.weiphone.com/apple/news/2013-06-15/CNET_Three_reasons_why_game_developers_prefer_iOS_556353.shtml网址之中接口的id数字
    NSRange cutUrlStr = {self.willToUrl.length-12,6};
    NSString *idStr = [sender substringWithRange:cutUrlStr];
//    NSLog(@"截取的字符串----------%@",idStr);
    
    //评论的json接口
    NSString * urlString = [NSString stringWithFormat:@"http://www.weiphone.com/publish/comment_v3.php?article_id=%@",idStr];
//    NSLog(@"评论地址:%@",urlString);
    NSURL *jsonUrl = [NSURL URLWithString:urlString];
    NSURLRequest *jsonReq = [NSURLRequest requestWithURL:jsonUrl];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:jsonReq returningResponse:nil error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [jsonStr JSONValue];
    self.commentArray = [jsonDictionary objectForKey:@"list"];
//    NSLog(@"self.commentArray====%@",self.commentArray);
//    NSLog(@"self.commentArray.count====%d",self.commentArray.count);
    for (int i=0; i<_commentArray.count; i++) {
        self.jsResult = [[_commentArray objectAtIndex:i]objectForKey:@"content"];
        //NSString *js3 = [js2 objectForKey:@"content"];
//        NSLog(@"评论：----------------%@",self.jsResult);
        self.numberOfComment.text = [NSString stringWithFormat:@"玩家点评(%d)",self.commentArray.count];
    }
    //显示剩余评论内容
    if (self.commentArray.count>0) {
        if (self.commentArray.count-2>0) {
            self.mst = [NSString stringWithFormat:@"(%d)",self.commentArray.count-2];
        }
        else{
            self.mst = @"(0)";
        }
        if (self.commentArray.count == 1) {
            self.mst = @"(0)";
        }
        
    }
    //显示剩余评论内容
    _moreComST.text = _mst;

    
}


#pragma mark - ASIHTTPRequest异步连接的代理方法
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //开始使用TFHpple解析网络数据
    TFHpple *weiTf = [[TFHpple alloc]initWithHTMLData:[request responseData]];
    
    //封装需要返回的是：标题高度、文字，资源label文字，引言文字、高度，图片的数据，正文文字、高度。
    //文章标题
    GetDataFromHTML *getHTML = [[GetDataFromHTML alloc]init];

    //显示标题
    self.titleLabel.text = self.titleStr;
    
    //使Label自己适应文本的高度
    GetLabelHight *getHighLabel = [[[GetLabelHight alloc]init]autorelease];
    CGFloat titleLBHigh = [getHighLabel highOfLabel:self.titleLabel numberTextOfLabel:self.titleStr andFontSize:20];
//    NSLog(@"heghL%f",titleLBHigh);
    self.titleLabel.frame = CGRectMake(30, 10, 250, titleLBHigh);
    
    //使用协议获得发表时间
//    self.dateStr = [getHTML startAnalysisTF:weiTf andXpath:@"//div[contains(concat(' ', @class, ' '), ' timer ')]/text()"];
////    NSLog(@"发表时间-->%@",self.dateStr);
    
    
    //新闻来源
    self.sourceStr = [getHTML startAnalysisTF:weiTf andXpath:@"//div[contains(concat(' ', @class, ' '), ' author ')]//span[2]"];
    if (self.sourceStr.length == 0) {
        self.sourceStr = @"来源：未知";
    }
//    NSLog(@"来源-->%@",self.sourceStr);
    //截取日期字符串中想要的
    NSString *tm = nil;
    NSArray *tmArry =nil;
    NSString *tm1 = nil;
    NSString *tm2 = nil;
    NSString *tm3 = nil;
    if (self.sourceStr.length >0) {
        //截取日期字符串中想要的
        NSRange range = {0,10};
        tm = [self.dateStr substringWithRange:range];
        tmArry = [tm componentsSeparatedByString:@"/"];
        tm1 = [tmArry objectAtIndex:0];
        tm2 = [tmArry objectAtIndex:1];
        tm3 = [tmArry objectAtIndex:2];
    }
    
    self.sourceLabel.text = [NSString stringWithFormat:@"%@    %@年%@月%@日   %@次浏览",self.sourceStr,tm1,tm2,tm3,self.clickStr];
//    NSLog(@"-------self.clickStr%@",self.clickStr);
    //文章中的图片//p[2]//a//img
    
    self.imageStr = [getHTML startAnalysisTF:weiTf andXpath:@"//div[contains(concat(' ', @class, ' '), ' content_text ')]//p[2]//img//@src"];
    if (self.imageStr.length == 0) { 
        self.imageStr = [getHTML startAnalysisTF:weiTf andXpath:@"//div[contains(concat(' ', @class, ' '), ' content ')]//div[1]//div//div[2]//div[2]//p//a//img//@src"];
    }
//    NSLog(@"文章中的图片-->%@",self.titleStr);
    
    [self downLoadImage:_imageStr];
    
    
    //----------------------取得引言、正文内容
    //网络数据存储进数组
    self.weiArrayt = [weiTf searchWithXPathQuery:@"//div[contains(concat(' ', @class, ' '), ' content_text ')]//span"];
    
//    NSLog(@"数组里元素个数：%u",self.weiArrayt.count);
    
    //每个文字片段
    NSString *stb = [[[NSString alloc]init]autorelease];
    //引言段落
    NSString *st = [[[NSString alloc]init]autorelease];
    
    //拼接正文的字符串
    NSMutableString *str = [[[NSMutableString alloc]init]autorelease];
    
    //遍历出的文字内容
    
    for(int i=1;i<[self.weiArrayt count];i++)
    {
        TFHppleElement *element = [self.weiArrayt objectAtIndex:i];
        //单段落内容
        stb = [element content];
        
        element = [self.weiArrayt objectAtIndex:0];
        //单段落内容
        st = [element content];
        //NSLog(@"段落内容：%@",st);
        
        //拼接段落
        if (stb!=nil) {
            [str appendString:stb];
        }
        
    }
    
    
    if (self.weiArrayt.count == 1) {
        //http://www.weiphone.com/iPad/news/2013-06-15/Apple_released_iOS_7_Beta_1_running_on_the_iPad_photo_556318.shtml
        self.weiArrayt = [weiTf searchWithXPathQuery:@"//div[contains(concat(' ', @class, ' '), ' content_text ')]//text() "];///div[5]/div/div[1]/div[2]/div[4]
//        NSLog(@"nil2数组里元素个数：%u",self.weiArrayt.count);
        //遍历出数组内的文字内容
        for(int i=1;i<[self.weiArrayt count];i++)
        {
            TFHppleElement *element = [self.weiArrayt objectAtIndex:i];
            //单段落内容
            stb = [element content];
            
            //首段段落内容
            element = [self.weiArrayt objectAtIndex:3];
            st = [element content];
            
//            NSLog(@"nil2段落内容：%@",stb);
            //拼接段落,获取正文内容
            [str appendString:stb];
            
        }
        
    }
    
    //如果之前文章的解析为空，我们采用另外一个可能对的路径
    if (self.weiArrayt.count == 0)
    {
        
        self.weiArrayt = [weiTf searchWithXPathQuery:@"//div[contains(concat(' ', @class, ' '), ' content_text ')]//text()"];
//        NSLog(@"nil数组里元素个数：%u",self.weiArrayt.count);
        //遍历出数组内的文字内容
        for(int i=1;i<[self.weiArrayt count];i++)
        {
            TFHppleElement *element = [self.weiArrayt objectAtIndex:i];
            //单段落内容
            stb = [element content];
            
            //首段段落内容
            element = [self.weiArrayt objectAtIndex:3];
            st = [element content];
            
//            NSLog(@"nil段落内容：%@",stb);
            //拼接段落,获取正文内容
            [str appendString:stb];
            
        }
        
        
    }
    
    if (self.weiArrayt.count == 0) {
        self.weiArrayt = [weiTf searchWithXPathQuery:@"//div[contains(concat(' ', @class, ' '), ' content ')]//div//div//div[2]//div[2]"];
        //        NSLog(@"nil数组里元素个数：%u",self.weiArrayt.count);
        //遍历出数组内的文字内容
        for(int i=1;i<[self.weiArrayt count];i++)
        {
            TFHppleElement *element = [self.weiArrayt objectAtIndex:i];
            //单段落内容
            stb = [element content];
            
            //首段段落内容
            element = [self.weiArrayt objectAtIndex:0];
            st = [element content];
            
            NSLog(@"nil段落内容：%@",stb);
            //拼接段落,获取正文内容
            if (stb!=nil) {
                [str appendString:stb];
            }


        }

    }
    
    
    //引言部分
    self.headTextLB.text = st;
//    NSLog(@"首段内容:%@",st);
    CGFloat headLBHigh = [getHighLabel highOfLabel:self.headTextLB numberTextOfLabel:st andFontSize:15];
//    NSLog(@"headLBHigh：%f",headLBHigh);
    
    
    //正文部分
    //显示文章内容
    NSString *rightStr1 = [str stringByReplacingOccurrencesOfString:@"[文章纠错]" withString:@""];
    NSString *rightStr2 = [rightStr1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *rightStr3 = [rightStr2 stringByReplacingOccurrencesOfString:@"以下为文章全文：" withString:@""];
    self.textLabel.text = rightStr3;
    
    //正文Label自适应高度
    CGFloat textLBHigh = [getHighLabel highOfLabel:self.textLabel numberTextOfLabel:rightStr3 andFontSize:15];
//    NSLog(@"textLBHigh%f",textLBHigh);
    
    //评论
    NSArray *  commentArray = [weiTf searchWithXPathQuery:@"//html//body[contains(concat(' ', @class, ' '), '  ')]//div[contains(concat(' ', @class, ' '), ' container_wrap ')]//div[contains(concat(' ', @class, ' '), ' container ')]//div[contains(concat(' ', @class, ' '), ' content ')]//div[@id='comment']//div[@id='commt_new']//div[1]//div[1]//div[1]//a[2]"];//为什么 /@src 反而取不到属性里面的字符串[contains(concat(' ', @class, ' ')   [contains(concat(' ', @id, ' '), ' commt_new ')]
    //NSLog(@"%@",commentArray);
    
    NSString * commentStr = [[[NSString alloc]init]autorelease];
    //遍历出数组内容
    for(int i=0;i<[commentArray count];i++)
    {
        TFHppleElement *element = [commentArray objectAtIndex:i];
        //单段落内容
        commentStr = [element content];
    }
//    NSLog(@"评论：%@",commentStr);
    
    //
    _mainView.frame = CGRectMake(5, 7, 310, self.textLabel.frame.size.height+348+100);
    
    //根据之前的标题、正文的高度，图片自动调整坐标
    //引言自适应
    self.headTextLB.frame = CGRectMake(22/2, 10+titleLBHigh+52/2, 310-22, headLBHigh);
    //图片自适应
    self.imageView.frame = CGRectMake(22/2+20, 10+titleLBHigh+52/2+headLBHigh+22/2, 500/2, 348/2);
    //正文自适应
    self.textLabel.frame = CGRectMake(22/2, 10+titleLBHigh+headLBHigh+11+54/2+348/2, 310-22, textLBHigh);
    //main视图自适应
    self.mainView.frame = CGRectMake(5, 5, 310, 10+titleLBHigh+52/2+24+headLBHigh+42/2+348/2+42+self.textLabel.frame.size.height+54/2);
//    NSLog(@"mainView高度--%f",10+titleLBHigh+52/2+24+headLBHigh+42/2+348/2+42/2+self.textLabel.frame.size.height);
    
    //评论视图自适应
    self.commentView.frame = CGRectMake(5, self.mainView.frame.size.height+10, 310, 460);
    self.tbt.backgroundColor = [UIColor clearColor];
    //同步推链接自适应
    self.tbt.frame = CGRectMake(11, 10+titleLBHigh+headLBHigh+15+300/2+24/2+self.textLabel.frame.size.height+54/2, 200, 20);
//    NSLog(@"同步推y轴--%f",10+titleLBHigh+headLBHigh+52/2+300/2+self.textLabel.frame.size.height);
    self.tbtWeb.backgroundColor = [UIColor clearColor];
    self.tbtWeb.frame = CGRectMake(11, 10+titleLBHigh+headLBHigh+15+300/2+self.textLabel.frame.size.height+self.tbt.frame.size.height+11+54/2, 200, 20);
//    NSLog(@"同步推链接y轴--====%f",10+titleLBHigh+headLBHigh+52/2+348/2+self.textLabel.frame.size.height+self.tbt.frame.size.height);
    
    //scroll滚动视图自适应
    self.scrollView.frame = CGRectMake(0, 0, 320, self.mainView.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(320, self.mainView.frame.size.height*2);//设置页面的长度
}

- (void) downLoadImage:(NSString *)imgeurl
{
//    NSLog(@"图片下载");
    NSURL *url = [NSURL URLWithString:imgeurl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
}

//异步下载代理方法
//开始
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.getData = [[[NSMutableData alloc]init]autorelease];
}
//接收
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.getData appendData:data];
}
//完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"完成图片下载");
    self.imageOnText = [UIImage imageWithData:self.getData];
    
    self.imageView.image = self.imageOnText;
    //    self.imageView.layer.borderWidth = 1.5;
    //    self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.imageView.contentMode = UIViewContentModeScaleToFill;
//    NSLog(@"self,imageOnText%@",self.imageOnText);
    //imageView.image = [UIImage imageNamed:@"1.png"];
}


#pragma mark - 单元格代理方法

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (flag001==1001) {
        if (self.commentArray.count>2) {
            return 2;//添加更多单元格的效果
        }
        //return self.commentArray.count;
        return self.commentArray.count;
    }else{
        flag001=1001;
        return self.commentArray.count;
    }
//    NSLog(@"添加的评论：%d",self.addComment);
    
//    NSLog(@"添加的评论：%d",self.commentArray.count -2);
    
}

////设置单元格内容的代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //确定一个静态的变量
    static NSString *cellStr = @"cell";
    //实例一个myCell类的对象cell。
    //dequeueReusableCellWithIdentifier是从队列中根据标示符取出一个暂时不用的cell
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    //判断单元格是否为空，为空，创建；不为空，跳过，不创建。这样就不会出现多次创建单元格的情况，有助于程序的性能
    if (cell == nil)
    {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    cell.userInteractionEnabled = NO;
//    NSLog(@"单元格--");
    
    //用户名
    NSString *name = [[_commentArray objectAtIndex:indexPath.row]objectForKey:@"user_name"];//Palo Alto将迎
    cell.name.text = name;
    
    //评论内容
    NSString *comment = [[_commentArray objectAtIndex:indexPath.row]objectForKey:@"content"];
    cell.comment.text = comment;
    GetLabelHight *getHight = [[GetLabelHight alloc]init];
    //调用单元格自适应方法
    CGFloat comLBHigh = [getHight highOfLabel:cell.comment numberTextOfLabel:cell.comment.text andFontSize:12];
    //得到单元格自适应的高
    self.cellAddHight = comLBHigh;
    
//    NSLog(@"comLBHigh :%f",comLBHigh);
    cell.comment.frame = CGRectMake(cell.headImage.frame.size.width+11,11+25/2+cell.name.frame.size.height, 200, comLBHigh);
    cell.sayImage.frame = CGRectMake(cell.comment.frame.origin.x, 25+cell.name.frame.size.height+cell.comment.frame.size.height+11, 120, 40);
    
    //评论时间
    NSString *time = [[_commentArray objectAtIndex:indexPath.row]objectForKey:@"add_time"];
    NSString *cstr = [[time componentsSeparatedByString:@"2013-"]objectAtIndex:1];
    cell.time.text = cstr;
    //cell.headImage.contentMode = UIViewContentModeScaleToFill;
    
    //其它
    NSString *other1 = [[_commentArray objectAtIndex:indexPath.row]objectForKey:@"score_1"];
    NSString *other2 = [[_commentArray objectAtIndex:indexPath.row]objectForKey:@"score_2"];
    cell.other.text = [NSString stringWithFormat:@"   顶(%@)  踩(%@)",other1,other2];
    
    //获得当前评论内容的高度，赋值给cell，之后定制单元格高度的时候我们只要用到cell的高，其它参数设为0对单元格的定制是不会有影响的
    [cell setFrame:CGRectMake(0, 0, 0, self.cellAddHight)];
    
    return cell;
    
}

- (float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 通过indexPath确定定制高度的是第几行
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    // 返回自适应高度
    return 99+cell.frame.size.height
    ;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
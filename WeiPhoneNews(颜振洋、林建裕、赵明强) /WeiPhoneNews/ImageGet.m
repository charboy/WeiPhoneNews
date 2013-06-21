//
//  ImageGet.m
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//

#import "ImageGet.h"
#import "TFHpple.h"
#import "XPathQuery.h"
@implementation ImageGet
-(void)GetTitleImageArray{
    self.imgArrayN=[[NSMutableArray alloc]init];
    self.imgWebArrayN=[[NSMutableArray alloc]init];
    self.wordArrayN=[[NSMutableArray alloc]init];
    self.headerArrayN=[[NSMutableArray alloc]init];
    self.head=[[Header alloc]init];
    self.headerobject1=[[Header alloc]init];
    self.headerobject2=[[Header alloc]init];
    self.headerobject3=[[Header alloc]init];
    //网络异步下载
    NSURL*url=[NSURL URLWithString:@"http://www.weiphone.com/"];
    ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:url];
    req.delegate=self;
    [req startAsynchronous];
    
//    return self.headerArrayN;
}
int flag=0;
- (void)requestFinished:(ASIHTTPRequest *)request{
    if (flag==0) {
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:[request responseData]];//创建基于xpath解析html的类对象
        //获取图片地址
        self.imgArray=[xpathParser searchWithXPathQuery:@"//div[@id='hot5_big']//div//a//@src"];
        @synchronized(self){
            for(int i=0;i<self.imgArray.count;i++){
                NSString *myTitle = [[self.imgArray objectAtIndex:i] content];
                [self.imgWebArrayN addObject:myTitle];
            }
        }
        self.wordArray=[xpathParser searchWithXPathQuery:@"//div[@id='hot5_big']//div//h3//a/text()"];
        @synchronized(self){
            for(int i=0;i<self.wordArray.count;i++){
                [self.wordArrayN addObject:[[self.wordArray objectAtIndex:i] content]];
            }
        }
        for(int i=0; i<3; i++){
            Header*headerobject=[[Header alloc]init];
            headerobject.headerImgWeb=[self.imgWebArrayN objectAtIndex:i];
            headerobject.headerTitle=[self.wordArrayN objectAtIndex:i];
            [self.headerArrayN addObject:headerobject];
        }
        self.headerobject1=[self.headerArrayN objectAtIndex:flag];
        flag=1;
        ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.headerobject1.headerImgWeb]];//再次异步下载图片
        req.delegate=self;
        [req startAsynchronous];
    }else if(flag==1){
        self.imgView=[[UIImageView alloc]initWithFrame:CGRectMake(320*0, 0, 320, 480-20-44)];
        self.headerobject1.headerImage=[UIImage imageWithData:[request responseData]];
        self.imgView.image=self.headerobject1.headerImage;
        [self.imgArrayN addObject:self.headerobject1];
        self.headerobject2=[self.headerArrayN objectAtIndex:flag];
        flag=2;
        ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.headerobject2.headerImgWeb]];//再次异步下载图片
        req.delegate=self;
        [req startAsynchronous];
    }else if(flag==2){
        self.imgView=[[UIImageView alloc]initWithFrame:CGRectMake(320*1, 0, 320, 480-20-44)];
        self.headerobject2.headerImage=[UIImage imageWithData:[request responseData]];
        self.imgView.image=self.headerobject2.headerImage;
        [self.imgArrayN addObject:self.headerobject2];
        self.headerobject3=[self.headerArrayN objectAtIndex:flag];
        flag=3;
        ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.headerobject3.headerImgWeb]];//再次异步下载图片
        req.delegate=self;
        [req startAsynchronous];
    }else if(flag==3){
        self.imgView=[[UIImageView alloc]initWithFrame:CGRectMake(320*2, 0, 320, 480-20-44)];
        self.headerobject3.headerImage=[UIImage imageWithData:[request responseData]];
        self.imgView.image=self.headerobject3.headerImage;
        [self.imgArrayN addObject:self.headerobject3];
        
        //获取Header对象数组
        [self.delegate GetTitleImageArrayN:self.imgArrayN];
        flag=4;
    }
}

@end

//
//  GetDataFromHTML.m
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//

#import "GetDataFromHTML.h"
#import "TFHpple.h"

@implementation GetDataFromHTML

//获得详细页面网络数据的方法。        传递参数：需要解析的页面            xpath抓取路径
- (NSString *) startAnalysisTF:(TFHpple *) weiTf andXpath:(NSString *) aXpath
{
    //获得网页上解析的数据
    NSArray *  commentArray = [weiTf searchWithXPathQuery:aXpath];
    
    NSString * commentStr = [[[NSString alloc]init]autorelease];
    
    //遍历出数组内容
    for(int i=0;i<[commentArray count];i++)
    {
        TFHppleElement *element = [commentArray objectAtIndex:i];
        //获得
        commentStr = [element content];
    }
    
//    NSLog(@"commentStr得到的字符串：%@",commentStr);
    
    return commentStr;
}



@end

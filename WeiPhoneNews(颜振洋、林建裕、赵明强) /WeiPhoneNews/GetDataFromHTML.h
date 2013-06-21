//
//  GetDataFromHTML.h
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"


@interface GetDataFromHTML : NSObject

//获得详细页面网络数据的方法。传递参数：需要解析的页面                 xpath抓取路径
- (NSString *) startAnalysisTF:(TFHpple *)weiTf andXpath:(NSString *)aXpath;

@end

//
//  News.h
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
@property(retain,nonatomic)NSString*newsTitle;//新闻标题
@property(retain,nonatomic)NSString*lookNo;//浏览次数
@property(retain,nonatomic)NSString*date;//发表时间
@property(retain,nonatomic)NSString*web;//文章详细网页地址
@property(retain,nonatomic)NSString*imgWeb;//图片地址
@end

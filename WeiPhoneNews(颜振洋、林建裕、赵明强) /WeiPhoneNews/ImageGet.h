//
//  ImageGet.h
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "Header.h"
#import "GetImageProtocol.h"
@interface ImageGet : NSObject<ASIHTTPRequestDelegate>
@property(retain,nonatomic)UIImageView*imgView;
@property(retain,nonatomic)NSArray*imgArray,*imgWebArray,*wordArray;
@property(retain,nonatomic)NSMutableArray*imgArrayN,*imgWebArrayN,*wordArrayN;
@property(retain,nonatomic)NSMutableArray*headerArrayN;
@property(retain,nonatomic)Header*headerobject1,*headerobject2,*headerobject3;
@property(retain,nonatomic)Header*head;
@property(assign,nonatomic)id<GetImageProtocol>delegate;
-(void)GetTitleImageArray;
@end

//
//  WebNewsCell.h
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//

#import <UIKit/UIKit.h>
//详细页面的信息
@interface WebNewsCell : UITableViewCell
@property (retain,nonatomic) UILabel *titleLabel;
@property (retain,nonatomic) UILabel *otherLabel;
@property (retain,nonatomic) UILabel *headEasay;
@property (retain,nonatomic) UILabel *bodyEasay;
@property (retain,nonatomic) UIImageView *image;
@end

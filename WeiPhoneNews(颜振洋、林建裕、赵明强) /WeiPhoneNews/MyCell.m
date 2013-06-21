//
//  MyCell.m
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //标题
        self.newsLab=[[UILabel alloc]initWithFrame:CGRectMake(14, 13, 250, 15)];
        self.newsLab.numberOfLines=0;
        [self.contentView addSubview:self.newsLab];
        [self.newsLab setBackgroundColor:[UIColor clearColor]];
        [self.newsLab setTextColor:[UIColor colorWithRed:52/255.0 green:58/255.0 blue:73/255.0 alpha:1]];
        [self.newsLab setHighlightedTextColor:[UIColor colorWithRed:153/255.0 green:156/255.0 blue:178/255.0 alpha:1]];
        self.newsLab.font=[UIFont systemFontOfSize:15];//设置字体大小
        
        //新闻种类和浏览次数
        self.titleFromLab=[[UILabel alloc]initWithFrame:CGRectMake(14, 41, 140, 11)];
        [self.contentView addSubview:self.titleFromLab];
        [self.titleFromLab setBackgroundColor:[UIColor clearColor]];
        [self.titleFromLab setTextColor:[UIColor colorWithRed:121/255.0 green:123/255.0 blue:141/255.0 alpha:1]];
        [self.titleFromLab setHighlightedTextColor:[UIColor colorWithRed:183/255.0 green:186/255.0 blue:202/255.0 alpha:1]];
        self.titleFromLab.font=[UIFont systemFontOfSize:11];//设置字体大小
        //时间
        self.dateLab=[[UILabel alloc]initWithFrame:CGRectMake(230, 41,140, 11)];
        [self.contentView addSubview:self.dateLab];
        [self.dateLab setBackgroundColor:[UIColor clearColor]];
        [self.dateLab setTextColor:[UIColor colorWithRed:121/255.0 green:123/255.0 blue:141/255.0 alpha:1]];
        [self.dateLab setHighlightedTextColor:[UIColor colorWithRed:183/255.0 green:186/255.0 blue:202/255.0 alpha:1]];
        self.dateLab.font=[UIFont systemFontOfSize:11];//设置字体大小
        self.jinru=[[UIImageView alloc]initWithFrame:CGRectMake(298, 24, 11, 17)];
        self.jinru.image=[UIImage imageNamed:@"cell_accessory.png"];
        [self.contentView addSubview:self.jinru];
        
        //未选中时的背景颜色
        [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

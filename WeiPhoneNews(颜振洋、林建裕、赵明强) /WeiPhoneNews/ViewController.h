//
//  ViewController.h
//  WeiPhoneNews
//
//  Created by 颜振洋 on 13-6-18.
//  Copyright (c) 2013年 颜振洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"//下拉刷新
#import "EGORefreshTableFooterView.h"//上拉刷新
#import "Header.h"
#import "GetImageProtocol.h"
@interface ViewController : UIViewController<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,UIScrollViewDelegate,GetImageProtocol>
//上下拉刷新
{
//    EGORefreshTableHeaderView*_refreshHeaderView;
//    EGORefreshTableFooterView*_refreshFooterView;
    BOOL _reloading;
}
@property (retain,nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (retain,nonatomic) EGORefreshTableFooterView *refreshFooterView;
//表格数据显示
//表格设置
@property(retain,nonatomic)UITableView*table;
@property(assign,nonatomic)int page;//新闻页面
@property(retain,nonatomic)NSArray*newsTitleArray,*lookNoArray,*dateArray,*webArray,*imgWebArray,*wordArray;
@property(retain,nonatomic)NSMutableArray*newsTitleArrayN,*lookNoArrayN,*dateArrayN,*webArrayN,*imgWebArrayN;
//排序
@property(retain,nonatomic)NSMutableArray*newsArrayN;
@property(retain,nonatomic)NSArray*sortedDateArray;//按时间排序后所有新闻数据数组(以News对象存储)
//图片显示
@property(retain,nonatomic)UIScrollView *scrollView;
@property(retain,nonatomic)UIPageControl*pageControl;
@property (retain,nonatomic) UILabel *underLabel,*underLabel1;
@property(assign,nonatomic)int index;
@property(retain,nonatomic)UIImageView*imgView;
@property(retain,nonatomic)NSArray*imgArray1,*imgWebArray1,*wordArray1;
@property(retain,nonatomic)NSMutableArray*imgArrayN1,*imgWebArrayN1,*wordArrayN1;
@property(retain,nonatomic)NSMutableArray*headerArrayN;
@property(retain,nonatomic)Header*headerobject1,*headerobject2,*headerobject3;
@property(retain,nonatomic)Header*head;
@property(assign,nonatomic) id <GetImageProtocol> delegate;

-(void)getData:(int)page;
-(NSArray*)sortedDate;


@end

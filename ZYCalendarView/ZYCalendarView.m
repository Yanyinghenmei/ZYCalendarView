//
//  ZYCalendarView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYCalendarView.h"
#import "ZYMonthView.h"
#import "JTDateHelper.h"

@implementation ZYCalendarView {
    CGSize lastSize;
    CGFloat monthViewHeight;
    
    ZYMonthView *monthView1;
    ZYMonthView *monthView2;
    ZYMonthView *monthView3;
    ZYMonthView *monthView4;
    ZYMonthView *monthView5;
    
    JTDateHelper *helper;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        // 暂定
        monthViewHeight = 300;
        helper = [JTDateHelper new];
    }
    return self;
}

- (void)layoutSubviews {
    // 修改大小
    [self resizeViewsIfWidthChanged];
    // 滚动
    [self viewDidScroll];
}

- (void)resizeViewsIfWidthChanged
{
    CGSize size = self.frame.size;
    
    // 首次加载
    if (!lastSize.width) {
        [self repositionViews];
    }
    
    // self的宽改变
    if(size.width != lastSize.width){
        lastSize = size;
        
        monthView1.frame = CGRectMake(0, monthView1.frame.origin.y, size.width, monthViewHeight);
        monthView2.frame = CGRectMake(0, monthView2.frame.origin.y, size.width, monthViewHeight);
        monthView3.frame = CGRectMake(0, monthView3.frame.origin.y, size.width, monthViewHeight);
        monthView4.frame = CGRectMake(0, monthView4.frame.origin.y, size.width, monthViewHeight);
        monthView5.frame = CGRectMake(0, monthView5.frame.origin.y, size.width, monthViewHeight);
        
        self.contentSize = CGSizeMake(size.width, self.contentSize.height);
    }
}

// 首次加载
- (void)repositionViews {
    CGSize size = self.frame.size;
    
    if (!monthView1) {
        monthView1 = [ZYMonthView new];
        monthView2 = [ZYMonthView new];
        monthView3 = [ZYMonthView new];
        monthView4 = [ZYMonthView new];
        monthView5 = [ZYMonthView new];
        
        monthView1.backgroundColor = [UIColor redColor];
        monthView2.backgroundColor = [UIColor yellowColor];
        monthView3.backgroundColor = [UIColor blueColor];
        monthView4.backgroundColor = [UIColor grayColor];
        monthView5.backgroundColor = [UIColor orangeColor];
        
        [self addSubview:monthView1];
        [self addSubview:monthView2];
        [self addSubview:monthView3];
        [self addSubview:monthView4];
        [self addSubview:monthView5];
    }
    
    self.contentSize = CGSizeMake(size.width, monthViewHeight * 5);
    
    [self resetMonthViewsFrame];
    
    self.contentOffset = CGPointMake(0, monthViewHeight * 2);
}

// 滚动了
- (void)viewDidScroll {
    if(self.contentSize.height <= 0){
        return;
    }
    
    if(self.contentOffset.y < monthViewHeight / 2.0){
        // 加载上一页(如果是当前日期的上一个月, 不加载)
        [self loadPreviousPage];
    }
    else if(self.contentOffset.y > monthViewHeight * 1.5){
        // 加载下一页
        [self loadNextPage];
    }
}

- (void)loadPreviousPage {
    
    CGSize size = self.frame.size;
    
    ZYMonthView *tmpView = monthView5;
    
    monthView5 = monthView4;
    monthView4 = monthView3;
    monthView3 = monthView2;
    monthView2 = monthView1;
    monthView1 = tmpView;
    
    [self resetMonthViewsFrame];
    
    self.contentOffset = CGPointMake(0, self.contentOffset.y + monthViewHeight);
    self.contentSize = CGSizeMake(size.width, monthViewHeight * 5);
}

- (void)loadNextPage {
    
    ZYMonthView *tmpView = monthView1;
    
    monthView1 = monthView2;
    monthView2 = monthView3;
    monthView3 = monthView4;
    monthView4 = monthView5;
    monthView5 = tmpView;
    
    [self resetMonthViewsFrame];
    
    self.contentOffset = CGPointMake(0, self.contentOffset.y - monthViewHeight);
}

- (void)resetMonthViewsFrame {
    CGSize size = self.frame.size;
    monthView1.frame = CGRectMake(0, 0, size.width, monthViewHeight);
    monthView2.frame = CGRectMake(0, monthViewHeight, size.width, monthViewHeight);
    monthView3.frame = CGRectMake(0, monthViewHeight * 2, size.width, monthViewHeight);
    monthView4.frame = CGRectMake(0, monthViewHeight * 3, size.width, monthViewHeight);
    monthView5.frame = CGRectMake(0, monthViewHeight * 4, size.width, monthViewHeight);
    self.contentSize = CGSizeMake(size.width, monthViewHeight * 5);
}

- (void)setDate:(NSDate *)date {
    _date = date;
    
    monthView3.date = [helper addToDate:date months:-2];
    monthView3.date = [helper addToDate:date months:-1];
    monthView3.date = date;
    monthView3.date = [helper addToDate:date months:1];
    monthView3.date = [helper addToDate:date months:2];
}

@end

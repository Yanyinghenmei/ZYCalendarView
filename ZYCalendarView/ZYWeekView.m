//
//  ZYWeekView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//
#define DayWidth [UIScreen mainScreen].bounds.size.width/7

#import "ZYWeekView.h"
#import "ZYDayView.h"
#import "JTDateHelper.h"

@implementation ZYWeekView {
    JTDateHelper *helper;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        helper = [JTDateHelper new];
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    
    NSDate *firstDate = [helper firstWeekDayOfWeek:_date];
    
    for (int i = 0; i < 7; i++) {
        ZYDayView *dayView = [[ZYDayView alloc] initWithFrame:CGRectMake(i*DayWidth, 0, DayWidth, DayWidth)];
        dayView.date = [helper addToDate:firstDate days:i];
        [self addSubview:dayView];
    }
}

@end

//
//  ZYWeekView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYWeekView.h"
#import "ZYDayView.h"
#import "JTDateHelper.h"

@implementation ZYWeekView

- (void)setDate:(NSDate *)date {
    _date = date;
    
    NSDate *firstDate = [_manager.helper firstWeekDayOfWeek:_date];
    
    if (self.subviews.count) {
        int index = 0;
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[ZYDayView class]]) {
                
                ZYDayView *dayView = (ZYDayView *)subView;
                
                [self configureDayView:dayView firstDate:firstDate index:index];
                
                index ++;
            }
        }
        
        if (index == 0) {
            for (int i = 0; i < 7; i++) {
                
                ZYDayView *dayView = [[ZYDayView alloc] initWithFrame:CGRectMake(_manager.dayViewWidth * i, 0, _manager.dayViewWidth, _manager.dayViewHeight)];
                dayView.manager = self.manager;
                
                [self configureDayView:dayView firstDate:firstDate index:index];
                
                [self addSubview:dayView];
            }
        }
        
    } else {
        
        for (int i = 0; i < 7; i++) {
            
            ZYDayView *dayView = [[ZYDayView alloc] initWithFrame:CGRectMake(_manager.dayViewWidth * i, 0, _manager.dayViewWidth, _manager.dayViewHeight)];
            dayView.manager = self.manager;
            
            [self configureDayView:dayView firstDate:firstDate index:i];
            
            [self addSubview:dayView];
        }
    }
}

- (void)configureDayView:(ZYDayView *)dayView firstDate:(NSDate *)firstDate index:(int)index {
    NSDate *dayDate = [_manager.helper addToDate:firstDate days:index];
    
    BOOL isSameMonth = [_manager.helper date:dayDate isTheSameMonthThan:_theMonthFirstDay];
    if (!isSameMonth) {
        if ([_manager.helper date:dayDate isAfter:[_manager.helper lastDayOfMonth:_theMonthFirstDay]]) {
            // 一个monthView中属于上个月的DayView没有title, 但是date和本月第一天相同
            dayDate = [_manager.helper lastDayOfMonth:_theMonthFirstDay];
        } else if ([_manager.helper date:dayDate isBefore:_theMonthFirstDay]) {
            // 一个monthView中属于下个月的DayView没有title, 但是date和本月最后一天相同
            dayDate = _theMonthFirstDay;
        }
        dayView.isEmpty = true;
    } else {
        dayView.isEmpty = false;
    }
    
    dayView.date = dayDate;
}

- (void)removeFromSuperview {
    [self.manager addToReusePoolWithView:self identifier:Identifier];
    [super removeFromSuperview];
}

@end

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
    
    for (int i = 0; i < 7; i++) {
        
        ZYDayView *dayView = [self.manager dequeueReusableDayViewWithIdentifier:Identifier];
        if (!dayView) {
            dayView = [ZYDayView new];
        }
        
        dayView.frame = CGRectMake(_manager.dayViewWidth * i, 0, _manager.dayViewWidth, _manager.dayViewHeight);
        dayView.manager = self.manager;
        
        NSDate *dayDate = [_manager.helper addToDate:firstDate days:i];
        
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
        
        [self addSubview:dayView];
    }
}

- (void)removeFromSuperview {
    [self.manager addToReusePoolWithViews:self.subviews identifier:Identifier];
    [super removeFromSuperview];
}

@end

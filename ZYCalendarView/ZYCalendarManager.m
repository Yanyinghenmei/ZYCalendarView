//
//  ZYCalendarManager.m
//  Example
//
//  Created by Daniel on 2016/10/30.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYCalendarManager.h"
#import "ZYDayView.h"

@implementation ZYCalendarManager

-(JTDateHelper *)helper {
    if (!_helper) {
        _helper = [JTDateHelper new];
    }
    return _helper;
}

- (NSMutableArray *)selectedDateArray {
    if (!_selectedDateArray) {
        _selectedDateArray = @[].mutableCopy;
    }
    return _selectedDateArray;
}

- (NSDateFormatter *)titleDateFormatter {
    if (!_titleDateFormatter) {
        _titleDateFormatter = [self.helper createDateFormatter];
        _titleDateFormatter.dateFormat = @"yyyy年MM月";
    }
    return _titleDateFormatter;
}

- (NSDateFormatter *)dayDateFormatter {
    if (!_dayDateFormatter) {
        _dayDateFormatter = [self.helper createDateFormatter];
        _dayDateFormatter.dateFormat = @"dd";
    }
    return _dayDateFormatter;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [self.helper createDateFormatter];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

// 单选或者范围选择,通过'selectedStartDay' 和 'selectedEndDay' 的setter方法把date保存到 'selectedDateArray'
// 单选: 'selectedDateArray' 中只保存一个 date
// 范围选择: 'selectedDateArray' 保存两个 date, 一个开始一个结束
// 多选: 由于多选的结果和 'selectedStartDay'及'selectedEndDay' 没有关系, 所以不再这里操作 'selectedDateArray'

- (void)setSelectedStartDay:(ZYDayView *)selectedStartDay {
    _selectedStartDay = selectedStartDay;
    
    if (_selectionType != ZYCalendarSelectionTypeMultiple) {
        if (self.selectedDateArray.count) {
            [self.selectedDateArray replaceObjectAtIndex:0 withObject:selectedStartDay.date];
        } else {
            [self .selectedDateArray addObject:selectedStartDay.date];
        }
    }
}

- (void)setSelectedEndDay:(ZYDayView *)selectedEndDay {
    _selectedEndDay = selectedEndDay;
    
    if (_selectionType == ZYCalendarSelectionTypeRange) {
        if (self.selectedDateArray.count == 2) {
            if (selectedEndDay) {
                [self.selectedDateArray replaceObjectAtIndex:1 withObject:selectedEndDay.date];
            } else {
                [self.selectedDateArray removeObjectAtIndex:1];
            }
        } else {
            [self.selectedDateArray addObject:selectedEndDay.date];
        }
    }
}

@end

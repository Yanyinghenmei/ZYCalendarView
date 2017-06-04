//
//  ZYDayView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYDayView.h"
#import "ZYMonthView.h"
#import "ZYCalendarManager.h"

@implementation ZYDayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateSelected];
        [self setImage:nil forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRangeState) name:@"changeRangeState" object:nil];
    }
    return self;
}

- (void)changeRangeState {
    if (_manager.selectionType == ZYCalendarSelectionTypeRange) {
        if (_manager.selectedDateArray.count == 2) {
            
            if ([_manager.helper date:_date
                     isTheSameDayThan:_manager.selectedDateArray[0].date]) {
                [self setBackgroundImage:[UIImage imageNamed:@"backImg_start"]
                                forState:UIControlStateSelected];
            } else if ([_manager.helper date:_date
                            isTheSameDayThan:_manager.selectedDateArray[1].date]) {
                [self setBackgroundImage:[UIImage imageNamed:@"backImg_end"]
                                forState:UIControlStateSelected];
            } else {
                [self setBackgroundImage:nil forState:UIControlStateNormal];
            }
            
            [self setSelectColor];
        } else {
            self.backgroundColor = [UIColor clearColor];
            [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectColor {
    
    if (_manager.selectedDateArray.count == 2 && _manager.selectionType == ZYCalendarSelectionTypeRange) {
        // 在开始和结束之间, 不包含首尾
        if ([_manager.helper date:_date isAfter:_manager.selectedDateArray[0].date andBefore:_manager.selectedDateArray[1].date]) {
            
            if (self.enabled) {
                self.backgroundColor = SelectedBgColor;
                [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                self.backgroundColor = [UIColor clearColor];
                [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
            }
            // 同一个月
            if ([_manager.helper date:_manager.selectedDateArray[0].date isTheSameMonthThan:_manager.selectedDateArray[1].date]) {
            }
            
            // 不同
            else {
                self.backgroundColor = SelectedBgColor;
                [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
        // 和开始日期相同(一个monthView中属于上个月的DayView没有title, 但是date和本月第一天相同)
        else if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray[0].date] && !self.enabled) {
            self.backgroundColor = SelectedBgColor;
            
            // 开始的是一个月的第一天
            if ([_manager.helper date:_date isTheSameDayThan:[_manager.helper firstDayOfMonth:_manager.selectedDateArray[0].date]] && !self.enabled) {
                self.backgroundColor = [UIColor clearColor];
                [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
            }
            
        }
        
        // 和结束日期相同(一个monthView中属于下个月的DayView没有title, 但是date和本月最后一天相同)
        else if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray[1].date] && !self.enabled) {
            self.backgroundColor = SelectedBgColor;
            
            // 结束是一个月最后一天
            if ([_manager.helper date:_date isTheSameDayThan:[_manager.helper lastDayOfMonth:_manager.selectedDateArray[1].date]] && !self.enabled) {
                self.backgroundColor = [UIColor clearColor];
                [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
            }
            
        }
    }
}

- (void)setDate:(NSDate *)date {
    _date = date;
    
    if (self.enabled) {
        
        // 过去的时间能否点击
        if (!_manager.canSelectPastDays &&
            ![_manager.helper date:_date isTheSameDayThan:_manager.date] &&
            [_date compare:_manager.date] == NSOrderedAscending) {
            self.enabled = false;
        }
        
        [self setTitle:[_manager.dayDateFormatter stringFromDate:_date] forState:UIControlStateNormal];
        
        // 当前时间
        if ([_manager.helper date:_date isTheSameDayThan:_manager.date] && self.enabled) {
            [self setImage:[UIImage imageNamed:@"circle_cir"] forState:UIControlStateNormal];
        }
        
        // 多选状态设置
        if (_manager.selectionType == ZYCalendarSelectionTypeMultiple) {
            for (ZYDayView *dayView in _manager.selectedDateArray) {
                self.selected = [_manager.helper date:_date isTheSameDayThan:dayView.date];
                if (self.selected) {
                    break;
                }
            }
            return;
        }
        
        // 开始
        if (_manager.selectedDateArray.count >= 1) {
            if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray[0].date]) {
                self.manager.selectedDateArray.firstObject.selected = false;
                [self.manager.selectedDateArray replaceObjectAtIndex:0 withObject:self];
                self.manager.selectedDateArray.firstObject.selected = true;
            }
        }
        
        if (_manager.selectedDateArray.count == 2) {
            if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray[1].date]) {
                self.manager.selectedDateArray[1].selected = false;
                [self.manager.selectedDateArray replaceObjectAtIndex:1 withObject:self];
                self.manager.selectedDateArray[1].selected = true;
            }
            
            if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray[0].date]) {
                [self setBackgroundImage:[UIImage imageNamed:@"backImg_start"]
                                forState:UIControlStateSelected];
            } else if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray[1].date]) {
                [self setBackgroundImage:[UIImage imageNamed:@"backImg_end"]
                                forState:UIControlStateSelected];
            } else {
                [self setBackgroundImage:nil forState:UIControlStateNormal];
            }
        }
    }
    [self setSelectColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setBackgroundImage:nil forState:UIControlStateSelected];
    
    // 多选
    if (_manager.selectionType == ZYCalendarSelectionTypeMultiple) {
        self.selected = !self.selected;
        if (self.selected) {
            [_manager.selectedDateArray addObject:self];
        } else {
            [_manager.selectedDateArray enumerateObjectsUsingBlock:^(ZYDayView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([_manager.helper date:_date isTheSameDayThan:obj.date]) {
                    [_manager.selectedDateArray removeObjectAtIndex:idx];
                }
            }];
        }
    }
    
    // 单选
    else if (_manager.selectionType == ZYCalendarSelectionTypeSingle) {
        if (self.manager.selectedDateArray.count) {
            [self.manager.selectedDateArray enumerateObjectsUsingBlock:^(ZYDayView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.selected = false;
            }];
            [self.manager.selectedDateArray removeAllObjects];
        }
        [self.manager.selectedDateArray addObject:self];
        self.manager.selectedDateArray.firstObject.selected = true;
    }
    
    // 范围选择
    else {
        if (_manager.selectedDateArray.count == 0) {
            [_manager.selectedDateArray addObject:self];
            _manager.selectedDateArray.firstObject.selected = true;
        } else if (_manager.selectedDateArray.count == 1) {
            if (_date == _manager.selectedDateArray.firstObject.date) {
                return;
            }
            if ([_manager.helper date:_date isBefore:_manager.selectedDateArray.firstObject.date]) {
                self.manager.selectedDateArray.firstObject.selected = false;
                [self.manager.selectedDateArray replaceObjectAtIndex:0 withObject:self];
                self.manager.selectedDateArray.firstObject.selected = true;
            } else {
                self.manager.selectedDateArray[0].selected = true;
                [self.manager.selectedDateArray addObject:self];
                self.manager.selectedDateArray[1].selected = true;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRangeState" object:nil];
            }
        } else if (_manager.selectedDateArray.count == 2) {
            self.manager.selectedDateArray[0].selected = false;
            self.manager.selectedDateArray[1].selected = false;
            
            [self.manager.selectedDateArray removeAllObjects];
            [self.manager.selectedDateArray addObject:self];
            self.manager.selectedDateArray.firstObject.selected = true;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRangeState" object:nil];
        }
    }
    
    if (self.manager.dayViewBlock) {
        self.manager.dayViewBlock(_manager, _date);
    }
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size = self.frame.size;
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size = self.frame.size;
    return frame;
}

@end

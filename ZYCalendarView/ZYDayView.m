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

- (void)setManager:(ZYCalendarManager *)manager {
    _manager = manager;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.tintColor = _manager.selectedBackgroundColor;
    
    [self setTitleColor:_manager.defaultTextColor forState:UIControlStateNormal];
    [self setTitleColor:_manager.selectedTextColor forState:UIControlStateSelected];
    [self setTitleColor:_manager.disableTextColor forState:UIControlStateDisabled];
    [self setImage:[[UIImage imageNamed:@"circle"] imageWithRenderingMode:_manager.imageRenderingMode] forState:UIControlStateSelected];
    
    [self setImage:nil forState:UIControlStateNormal];
    self.backgroundColor = [UIColor clearColor];
    
    [self initCommit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState) name:@"changeState" object:nil];
}

- (void)initCommit {
}

- (void)setDate:(NSDate *)date {
    _date = date;
    
    // 重置状态设置
    self.backgroundColor = [UIColor clearColor];
    
    [self changeState];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    // 多选
    if (_manager.selectionType == ZYCalendarSelectionTypeMultiple) {
        
        self.selected = !self.selected;
        if (self.selected) {
            [_manager.selectedDateArray addObject:_date];
        } else {
            [_manager.selectedDateArray enumerateObjectsUsingBlock:^(NSDate *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([_manager.helper date:_date isTheSameDayThan:obj]) {
                    [_manager.selectedDateArray removeObjectAtIndex:idx];
                }
            }];
        }
    }
    
    // 单选
    else if (_manager.selectionType == ZYCalendarSelectionTypeSingle) {
        if (_manager.selectedDateArray.count) {
            if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray[0]]) {
                self.selected = false;
                [_manager.selectedDateArray removeAllObjects];
            } else {
                self.selected = true;
                [_manager.selectedDateArray replaceObjectAtIndex:0 withObject:_date];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
            }
        } else {
            self.selected = true;
            [_manager.selectedDateArray addObject:_date];
        }
    }
    
    // 范围选择
    else {
        if (_manager.selectedDateArray.count == 0) {
            [_manager.selectedDateArray addObject:_date];
            self.selected = true;
        } else if (_manager.selectedDateArray.count == 1) {
            if ([_manager.helper date:_date isEqualOrBefore:_manager.selectedDateArray[0]]) {
                [_manager.selectedDateArray replaceObjectAtIndex:0 withObject:self.date];
            } else {
                [_manager.selectedDateArray addObject:_date];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
        } else if (_manager.selectedDateArray.count == 2) {
            [_manager.selectedDateArray removeAllObjects];
            [_manager.selectedDateArray addObject:_date];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
        }
    }
    
    if (self.manager.dayViewBlock) {
        self.manager.dayViewBlock(_manager, _date);
    }
}

// 修改颜色状态
- (void)changeState {
    
    if (_isEmpty) {
        
        self.selected = false;
        self.enabled = false;
        [self setTitle:@"" forState:UIControlStateNormal];
        
        // 多选模式需要对空的dayView背景色进行操作
        if (_manager.selectionType == ZYCalendarSelectionTypeRange &&
            _manager.selectedDateArray.count == 2) {
            
            if ([_manager.helper date:_date isEqualOrAfter:_manager.selectedDateArray[0] andEqualOrBefore:_manager.selectedDateArray[1]]) {
                
                // 和开始日期相同(一个monthView中属于上个月的DayView没有title, 但是date和本月第一天相同)
                // 开始的是一个月的第一天
                if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray[0]] &&
                    [_manager.helper date:_date isTheSameDayThan:[_manager.helper firstDayOfMonth:_manager.selectedDateArray[0]]]) {
                    self.backgroundColor = [UIColor clearColor];
                }
                // 和结束日期相同(一个monthView中属于下个月的DayView没有title, 但是date和本月最后一天相同)
                // 结束是一个月最后一天
                else if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray[1]] &&
                         [_manager.helper date:_date isTheSameDayThan:[_manager.helper lastDayOfMonth:_manager.selectedDateArray[1]]]) {
                    self.backgroundColor = [UIColor clearColor];
                } else {
                    self.backgroundColor = _manager.selectedBackgroundColor;
                }
            } else {
                self.backgroundColor = [UIColor clearColor];
            }
        } else {
            self.backgroundColor = [UIColor clearColor];
        }
    }
    
    // 非空dayView的状态
    else {
        
        self.enabled = true;
        [self setTitle:[_manager.dayDateFormatter stringFromDate:_date] forState:UIControlStateNormal];
        
        
        // 当前时间
        if ([_manager.helper date:_date isTheSameDayThan:_manager.date] && self.enabled) {
            [self setImage:[[UIImage imageNamed:@"circle_cir"] imageWithRenderingMode:_manager.imageRenderingMode] forState:UIControlStateNormal];
        } else {
            [self setImage:nil forState:UIControlStateNormal];
        }
        
        // 过去的时间能否点击
        if (!_manager.canSelectPastDays &&
            ![_manager.helper date:_date isTheSameDayThan:_manager.date] &&
            [_date compare:_manager.date] == NSOrderedAscending) {
            self.enabled = false;
        } else {
            self.enabled = true;
        }
        
        // 单选
        if (_manager.selectionType == ZYCalendarSelectionTypeSingle) {
            if (_manager.selectedDateArray.count && [_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray.firstObject]) {
                self.selected = true;
            } else {
                self.selected = false;
            }
        }
        
        // 多选
        else if (_manager.selectionType == ZYCalendarSelectionTypeMultiple) {
            self.selected = false;
            if (_manager.selectedDateArray.count) {
                for (NSDate *date in _manager.selectedDateArray) {
                    if ([_manager.helper date:_date isTheSameDayThan:date]) {
                        self.selected = true;
                        break;
                    }
                }
            }
        }
        
        // 范围选择
        else if (_manager.selectionType == ZYCalendarSelectionTypeRange) {
            self.selected = false;
            self.backgroundColor = [UIColor clearColor];
            // 设置起始按钮选中状态
            for (NSDate *date in _manager.selectedDateArray) {
                if ([_manager.helper date:_date isTheSameDayThan:date]) {
                    self.selected = true;
                    [self setBackgroundImage:nil forState:UIControlStateSelected];
                    break;
                }
            }
            
            if (_manager.selectedDateArray.count == 2) {
                // 设置背景色
                if ([_manager.helper date:_date
                                  isAfter:_manager.selectedDateArray[0]
                                andBefore:_manager.selectedDateArray[1]]) {
                    self.backgroundColor = _manager.selectedBackgroundColor;
                    self.selected = true;
                } else {
                    self.backgroundColor = [UIColor clearColor];
                    self.selected = false;
                }
                
                // 设置起始按钮背景图片
                if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray[0]]) {
                    [self setBackgroundImage:[[UIImage imageNamed:@"backImg_start"] imageWithRenderingMode:_manager.imageRenderingMode]
                                    forState:UIControlStateSelected];
                    self.selected = true;
                } else if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDateArray[1]]) {
                    [self setBackgroundImage:[[UIImage imageNamed:@"backImg_end"] imageWithRenderingMode:_manager.imageRenderingMode]
                                    forState:UIControlStateSelected];
                    self.selected = true;
                } else {
                    [self setBackgroundImage:nil forState:UIControlStateSelected];
                }
            }
            
        }
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

//
//  ZYDayView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYDayView.h"
#import "JTDateHelper.h"
#import "ZYMonthView.h"

@implementation ZYDayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
        [self setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateSelected];
        [self setImage:nil forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState) name:@"changeState" object:nil];
    }
    return self;
}

- (void)changeState {
    if (_manager.selectedDay1 && _manager.selectedDay2) {
        
        if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDay1.date]) {
            [self setBackgroundImage:[UIImage imageNamed:@"backImg_start"]
                            forState:UIControlStateSelected];
        } else if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDay2.date]) {
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

- (void)setSelectColor {
    if ([_manager.helper date:_date isEqualOrAfter:_manager.selectedDay1.date andEqualOrBefore:_manager.selectedDay2.date]) {
        
        // 同一个月
        if ([_manager.helper date:_manager.selectedDay1.date isTheSameMonthThan:_manager.selectedDay2.date]) {
            if (self.enabled) {
                self.backgroundColor = SelectedBgColor;
                [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                self.backgroundColor = [UIColor clearColor];
                [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
            }
        }
        
        // 不同
        else {
            self.backgroundColor = SelectedBgColor;
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    } else {
        self.backgroundColor = [UIColor clearColor];
        [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
    }
}

- (void)setDate:(NSDate *)date {
    _date = date;
    
    if (self.enabled) {
        
        [self setTitle:[_manager.dayDateFormatter stringFromDate:_date] forState:UIControlStateNormal];
        
        if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDay1.date]) {
            self.manager.selectedDay1.selected = false;
            self.manager.selectedDay1 = self;
            self.manager.selectedDay1.selected = true;
        } else if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDay2.date]) {
            self.manager.selectedDay2.selected = false;
            self.manager.selectedDay2 = self;
            self.manager.selectedDay2.selected = true;
        }
        
        if ([_manager.helper date:_date isTheSameDayThan:[NSDate date]] && self.enabled) {
            [self setImage:[UIImage imageNamed:@"circle_cir"] forState:UIControlStateNormal];
        }
        
        if (_manager.selectedDay1 && _manager.selectedDay2) {
            if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDay1.date]) {
                [self setBackgroundImage:[UIImage imageNamed:@"backImg_start"]
                                forState:UIControlStateSelected];
            } else if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedDay2.date]) {
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
    
    if (_manager.selectedDay1 && !_manager.selectedDay2) {
        if ([_manager.helper date:_date isBefore:_manager.selectedDay1.date]) {
            self.manager.selectedDay1.selected = false;
            self.manager.selectedDay1 = self;
            self.manager.selectedDay1.selected = true;
        } else {
            // 显示范围
            self.manager.selectedDay2.selected = false;
            self.manager.selectedDay2 = self;
            self.manager.selectedDay2.selected = true;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
        }
    } else if (_manager.selectedDay1 && _manager.selectedDay2) {
        self.manager.selectedDay1.selected = false;
        self.manager.selectedDay2.selected = false;
        
        self.manager.selectedDay1 = self;
        self.manager.selectedDay1.selected = true;
        self.manager.selectedDay2 = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
    } else if (!_manager.selectedDay1 && !_manager.selectedDay2) {
        self.manager.selectedDay1.selected = false;
        self.manager.selectedDay1 = self;
        self.manager.selectedDay1.selected = true;
    }
    
    
    if (self.manager.dayViewBlock) {
        self.manager.dayViewBlock(_date);
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

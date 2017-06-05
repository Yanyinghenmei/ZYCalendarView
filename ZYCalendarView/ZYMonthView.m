//
//  ZYMonthView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYMonthView.h"
#import "JTDateHelper.h"
#import "ZYWeekView.h"

@interface ZYMonthView ()
@property (nonatomic, strong)UILabel *titleLab;
@end

@implementation ZYMonthView {
    NSInteger weekNumber;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    [self reload];
}

- (void)reload {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 某月
    NSString *dateStr = [_manager.titleDateFormatter stringFromDate:_date];
    self.titleLab.text = dateStr;
    [self addSubview:_titleLab];
    
    weekNumber = [_manager.helper numberOfWeeks:_date];
    // 有几周
    
    NSDate *firstDay = [_manager.helper firstDayOfMonth:_date];
        
    for (int i = 0; i < weekNumber; i++) {
        
        ZYWeekView *weekView = [_manager dequeueReusableWeekViewWithIdentifier:Identifier];
        if (!weekView) {
            weekView = [ZYWeekView new];
            weekView.manager = self.manager;
        }
        weekView.frame = CGRectMake(0, _manager.dayViewHeight+_manager.dayViewGap*2 + (_manager.dayViewHeight+_manager.dayViewGap)*i, self.frame.size.width, _manager.dayViewHeight);
        
        weekView.theMonthFirstDay = firstDay;
        weekView.date = [_manager.helper addToDate:firstDay weeks:i];
        [self addSubview:weekView];
    }
    
    CGRect frame = self.frame;
    frame.size.height = weekNumber * (_manager.dayViewHeight+_manager.dayViewGap) + _manager.dayViewHeight + 2*_manager.dayViewGap;
    self.frame = frame;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, _manager.dayViewGap+10, self.frame.size.width-30, _manager.dayViewHeight-10)];
        _titleLab.font = [UIFont systemFontOfSize:20];
    }
    return _titleLab;
}

@end

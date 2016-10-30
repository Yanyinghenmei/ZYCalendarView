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
@property (nonatomic, strong)NSMutableArray *weeksViews;
@property (nonatomic, strong)UILabel *titleLab;
@end

@implementation ZYMonthView {
    JTDateHelper *helper;
    NSInteger weekNumber;
    CGFloat weekH;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    [self reload];
}

- (void)commonInit {
    helper = [JTDateHelper new];
    _weeksViews  =[NSMutableArray new];
    weekH = self.frame.size.width/7;
}

- (void)reload {
    // 某月
    NSDateFormatter *formatter = [helper createDateFormatter];
    formatter.dateFormat = @"yyyy年MM月";
    NSString *dateStr = [formatter stringFromDate:_date];
    self.titleLab.text = dateStr;
    
    weekNumber = [helper numberOfWeeks:_date];
    // 有几周
    if (_weeksViews.count) {
        [_weeksViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    NSDate *firstDay = [helper firstDayOfMonth:_date];
        
    for (int i = 0; i < weekNumber; i++) {
        ZYWeekView *weekView = [ZYWeekView new];
        weekView.frame = CGRectMake(0, weekH + weekH*i, self.frame.size.width, weekH);
        weekView.date = [helper addToDate:firstDay weeks:i];
        [self addSubview:weekView];
        [_weeksViews addObject:weekView];
    }
    
    CGRect frame = self.frame;
    frame.size.height = weekNumber * weekH + weekH;
    self.frame = frame;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, weekH)];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);//arc4random()%100+200
        [self commonInit];
    }
    return self;
}

@end

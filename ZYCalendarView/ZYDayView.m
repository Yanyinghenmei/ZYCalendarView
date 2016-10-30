//
//  ZYDayView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYDayView.h"
#import "JTDateHelper.h"

@implementation ZYDayView {
    JTDateHelper *helper;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        helper = [JTDateHelper new];
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:self.bounds];
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    
    NSDateFormatter *formatter = [helper createDateFormatter];
    formatter.dateFormat = @"dd";
    lab.text = [formatter stringFromDate:_date];
    
}

@end

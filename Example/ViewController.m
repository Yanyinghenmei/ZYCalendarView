//
//  ViewController.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ViewController.h"
#import "ZYCalendarView.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *weekTitlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:weekTitlesView];
    CGFloat weekW = self.view.frame.size.width/7;
    NSArray *titles = @[@"日", @"一", @"二", @"三",
                        @"四", @"五", @"六"];
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] initWithFrame:CGRectMake(i*weekW, 20, weekW, 44)];
        week.textAlignment = NSTextAlignmentCenter;
        week.textColor = ZYHEXCOLOR(0x666666);
        
        [weekTitlesView addSubview:week];
        week.text = titles[i];
    }
    
    
    ZYCalendarView *view = [[ZYCalendarView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    // 不可以点击已经过去的日期
    view.manager.canSelectPastDays = false;
    // 可以选择时间段
    view.manager.canSelectFewDays = true;
    // 设置当前日期
    view.date = [NSDate date];
    
    view.dayViewBlock = ^(NSDate *dayDate) {
        NSLog(@"%@", dayDate);
    };
    [self.view addSubview:view];
}


@end

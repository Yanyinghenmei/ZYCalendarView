# ZYCalendarView
![image](https://github.com/Yanyinghenmei/ZYCalendarView/raw/master/image.gif)

参考JTCalendar, 模仿Airbnb的日历

Reference JTCalendar, imitate Airbnb's calendar

```objc
    ZYCalendarView *view = [[ZYCalendarView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    // 不可以点击已经过去的日期
    view.manager.canSelectPastDays = false;
    // 可以选择时间段
    view.manager.selectionType = ZYCalendarSelectionTypeMultiple;
    // 设置当前日期
    view.date = [NSDate date];
    
    view.dayViewBlock = ^(NSDate *dayDate) {
        NSLog(@"%@", dayDate);
    };
```

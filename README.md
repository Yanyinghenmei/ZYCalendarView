# ZYCalendarView
![image](https://github.com/Yanyinghenmei/ZYCalendarView/raw/master/image.gif)

参考JTCalendar, 模仿Airbnb的日历

Reference JTCalendar, imitate Airbnb's calendar

## How to use
Download ZYCalendarView and try out the included you iPhone project or use [CocoaPods](http://cocoapods.org).

#### Podfile

To integrate ZYCalendarView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'ZYCalendarView', '~> 0.0.1'
end
```

Then, run the following command:

```bash
$ pod install
```

## Simple code

```objc
    ZYCalendarView *view = [[ZYCalendarView alloc] initWithFrame:
                           CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    // 不可以点击已经过去的日期
    view.manager.canSelectPastDays = false;
    // 可以选择时间段
    view.manager.selectionType = ZYCalendarSelectionTypeRange;
    // 设置当前日期
    view.date = [NSDate date];
    
    view.dayViewBlock = ^(ZYCalendarManager *manager, NSDate *dayDate) {
        // NSLog(@"%@", dayDate);
        for (NSDate *date in manager.selectedDateArray) {
            NSLog(@"%@", [manager.dateFormatter stringFromDate:date]);
        }
        printf("\n");
    };
```

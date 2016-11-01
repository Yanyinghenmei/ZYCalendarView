//
//  ZYCalendarManager.h
//  Example
//
//  Created by Daniel on 2016/10/30.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTDateHelper.h"

#define ZYHEXCOLOR(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define SelectedBgColor ZYHEXCOLOR(0x128963)
#define SelectedTextColor [UIColor whiteColor]

//#define defaultBgColor [UIColor whiteColor]
#define defaultTextColor [UIColor blackColor]

@class ZYDayView;

@interface ZYCalendarManager : NSObject
@property (nonatomic, strong)JTDateHelper *helper;
@property (nonatomic, strong)NSDateFormatter *titleDateFormatter;
@property (nonatomic, strong)NSDateFormatter *dayDateFormatter;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;

// 选中的按钮(开始和结束)
@property (nonatomic, strong)ZYDayView *selectedStartDay;
@property (nonatomic, strong)ZYDayView *selectedEndDay;

// 是否可以选择时间段
@property (nonatomic, assign)BOOL canSelectFewDays;

// 之前的时间是否可以被点击选择
@property (nonatomic, assign)BOOL canSelectPastDays;

// dayView点击回调
@property (nonatomic, copy)void(^dayViewBlock)(id);

@end

//
//  ZYCalendarManager.h
//  Example
//
//  Created by Daniel on 2016/10/30.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTDateHelper.h"

typedef NS_ENUM(NSInteger, ZYCalendarSelectionType) {
    ZYCalendarSelectionTypeSingle = 0,          // 单选
    ZYCalendarSelectionTypeMultiple = 1,        // 多选
    ZYCalendarSelectionTypeRange = 2            // 范围选择
};
static NSString *Identifier = @"WeekView";
@class ZYWeekView;

@interface ZYCalendarManager : NSObject
// 计算日期
@property (nonatomic, strong)JTDateHelper *helper;

@property (nonatomic, strong)NSDateFormatter *titleDateFormatter;
@property (nonatomic, strong)NSDateFormatter *dayDateFormatter;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@property (nonatomic, assign)CGFloat dayViewGap;
@property (nonatomic, assign)CGFloat dayViewWidth;
@property (nonatomic, assign)CGFloat dayViewHeight;

// 图片渲染
@property (nonatomic, assign)UIImageRenderingMode imageRenderingMode;

// 选中状态颜色 默认 0x128963
@property (nonatomic, strong)UIColor *selectedBackgroundColor;
// 选中状态的文字颜色
@property (nonatomic, strong)UIColor *selectedTextColor;
// 未选中状态的文字颜色
@property (nonatomic, strong)UIColor *defaultTextColor;
// 不可用状态的文字颜色
@property (nonatomic, strong)UIColor *disableTextColor;

// 保存创建日历时的时间
@property (nonatomic, strong)NSDate *date;

// 保存选中的时间
@property (nonatomic, strong)NSMutableArray <NSDate *>*selectedDateArray;

// 选择模式 默认单选
@property (nonatomic, assign)ZYCalendarSelectionType selectionType;

// 已过去的时间是否可以被点击选择
@property (nonatomic, assign)BOOL canSelectPastDays;

// dayView点击回调
@property (nonatomic, copy)void(^dayViewBlock)(ZYCalendarManager *manager,id);


- (void)registerWeekViewWithReuseIdentifier:(NSString *)identifier;
- (void)addToReusePoolWithView:(UIView *)view identifier:(NSString *)identifier;
- (ZYWeekView *)dequeueReusableWeekViewWithIdentifier:(NSString *)identifier;

@end

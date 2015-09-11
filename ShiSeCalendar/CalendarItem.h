//
//  CalendarItem.h
//  HYCalendar
//
//  Created by coder on 15/9/1.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarItem : UIView

@property (strong, nonatomic) NSDate  *date;

@property (strong, nonatomic) UIImage *placeholderImage;

@property (nonatomic, copy) void(^calendarBlock)(NSDate *);

- (void)createCalendarViewWith:(NSDate *)date;

- (NSDate *)nextMonth:(NSDate *)date;

- (NSDate *)lastMonth:(NSDate *)date;

- (void)loadData:(NSDictionary *)data;

@end


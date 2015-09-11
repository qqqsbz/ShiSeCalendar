//
//  CalendarView.h
//  HYCalendar
//
//  Created by coder on 15/9/1.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarItem.h"
@protocol CalendarViewDelegate <NSObject>

- (void)calendarViewCurrentDate:(NSDate *)date;

- (void)calendarViewDidSelectWithDate:(NSDate *)date;

- (void)calendarViewImageUrls:(CalendarItem *)calendarItem;

@end

@interface CalendarView : UIScrollView<UIScrollViewDelegate>

@property (weak,   nonatomic) id<CalendarViewDelegate> calendarDelegate;

@property (strong, nonatomic) UIImage *placeholderImage;

- (void)lastMonth;

- (void)nextMonth;

- (void)today;

- (void)clearMemory;

- (void)clearImageFromMenoryWithKey:(NSString *)key;

@end




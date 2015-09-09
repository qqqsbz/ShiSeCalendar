//
//  CalendarView.m
//  HYCalendar
//
//  Created by coder on 15/9/1.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

#import "CalendarView.h"
@interface CalendarView()

@property (assign, nonatomic) NSInteger         lastIndex;

@end

@implementation CalendarView

- (void)awakeFromNib
{
    [self initialization];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    self.delegate = self;
    
    CGFloat width  = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    NSDate *date   = [NSDate date];
    for (NSInteger i = 0; i < 3; i ++) {
        
        CalendarItem *calendarItem = [[CalendarItem alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        calendarItem.date  =  i == 0 ? [calendarItem lastMonth:date] :
                              i == 1 ? date : [calendarItem nextMonth:date];
        
        calendarItem.calendarBlock =  ^(NSDate *date){
            if ([self.calendarDelegate respondsToSelector:@selector(calendarViewDidSelectWithDate:)]) {
                [self.calendarDelegate calendarViewDidSelectWithDate:date];
            }
           
        };
        [self addSubview:calendarItem];
    }
    
    self.contentSize        = CGSizeMake(width * 3, height);
    self.contentOffset      = CGPointMake(width, 0);
    self.lastIndex          = self.contentOffset.x / width;
    
}

- (void)setCalendarDelegate:(id<CalendarViewDelegate>)calendarDelegate
{
    _calendarDelegate = calendarDelegate;
    
    if ([self.calendarDelegate respondsToSelector:@selector(calendarViewCurrentDate:)]) {
        [self.calendarDelegate calendarViewCurrentDate:[NSDate date]];
    }
    
    for (CalendarItem *item in self.subviews) {
        [self loadData:item];
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(self.bounds);
    
    if (index != self.lastIndex) {
        NSDate *currentDate;
        CalendarItem *firstItem  = [self.subviews objectAtIndex:0];
        CalendarItem *secondItem = [self.subviews objectAtIndex:1];
        CalendarItem *thirdItem  = [self.subviews objectAtIndex:2];
        
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        
        CGRect frame;
        if (index > self.lastIndex) {
            
            frame               = firstItem.frame;
            firstItem.frame     = thirdItem.frame;
            thirdItem.frame     = secondItem.frame;
            secondItem.frame    = frame;
            firstItem.date      = [firstItem nextMonth:thirdItem.date];
            currentDate         = thirdItem.date;
            
            [self loadData:firstItem];
            [self insertSubview:secondItem  atIndex:0];
            [self insertSubview:thirdItem   atIndex:1];
            [self insertSubview:firstItem   atIndex:2];
            
        } else if (index < self.lastIndex) {
            
            frame               = thirdItem.frame;
            thirdItem.frame     = firstItem.frame;
            firstItem.frame     = secondItem.frame;
            secondItem.frame    = frame;
            thirdItem.date      = [firstItem lastMonth:firstItem.date];
            currentDate         = firstItem.date;
            
            [self loadData:thirdItem];
            [self insertSubview:thirdItem   atIndex:0];
            [self insertSubview:firstItem   atIndex:1];
            [self insertSubview:secondItem  atIndex:2];
            
        }
        
        
        [scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(firstItem.frame), 0, CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame)) animated:NO];
        
        if ([self.calendarDelegate respondsToSelector:@selector(calendarViewCurrentDate:)]) {
            [self.calendarDelegate calendarViewCurrentDate:currentDate];
        }
    }
    
}

- (void)lastMonth
{
    CalendarItem *item = [self.subviews firstObject];
    self.contentOffset = CGPointMake(item.frame.origin.x, item.frame.origin.y);
    [self scrollViewDidEndDecelerating:self];
}

- (void)nextMonth
{
    CalendarItem *item = [self.subviews lastObject];
    self.contentOffset = CGPointMake(item.frame.origin.x, item.frame.origin.y);
    [self scrollViewDidEndDecelerating:self];
    
}

- (void)loadData:(CalendarItem *)item
{
    if ([self.calendarDelegate respondsToSelector:@selector(calendarViewImageUrls:)]) {
        [self.calendarDelegate calendarViewImageUrls:item];
    }
}

@end




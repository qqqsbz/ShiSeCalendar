//
//  CalendarItem.m
//  HYCalendar
//
//  Created by coder on 15/9/1.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

#import "CalendarItem.h"
#import <UIImageView+WebCache.h>
@implementation CalendarItem
{
    UIButton        *_selectButton;
    NSMutableArray  *_daysArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            [self addSubview:button];
            [_daysArray addObject:button];
        }
    }
    return self;
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    
    _date = date;
    
    [self createCalendarViewWith:date];
    
}

- (void)createCalendarViewWith:(NSDate *)date{
    
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = itemW;//self.frame.size.height / 7;
    
    NSArray *array = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
    UIView *weekBg = [[UIView alloc] init];
    weekBg.frame = CGRectMake(0, 0, self.frame.size.width, itemH);
    [self addSubview:weekBg];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = [UIColor grayColor];
        [weekBg addSubview:week];
    }
    
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame);
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, itemW, itemH);
        dayButton.tag = 0;
        dayButton.titleLabel.font           = [UIFont systemFontOfSize:14.0];
        dayButton.titleLabel.textAlignment  = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius        = 0;
        dayButton.layer.borderWidth         = 0.f;
        dayButton.layer.borderColor         = [UIColor clearColor].CGColor;
        [dayButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        [dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [dayButton setBackgroundColor:[UIColor clearColor]];
        [dayButton setImage:nil forState:UIControlStateNormal];
        
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%ld", (long)day] forState:UIControlStateNormal];
        
        // this month
        if ([self month:date] == [self month:[NSDate date]]) {
            
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;
            
            if (i < todayIndex && i >= firstWeekday) {
                [self setStyle_BeforeToday:dayButton];
                
            }else if(i ==  todayIndex){
                [self setStyle_Today:dayButton];
                
            }
        }
    }
}

#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    _selectButton.selected = NO;
    dayBtn.selected = YES;
    _selectButton = dayBtn;
    
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%d",(long)[comp year],(long)[comp month],day];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    [formater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate* date = [formater dateFromString:dateString];
    
    if (self.calendarBlock) {
        self.calendarBlock(date);
    }
}


#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.hidden = YES;
}

- (void)setStyle_BeforeToday:(UIButton *)btn
{
    btn.hidden  = NO;
    btn.tag     = 1;
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)setStyle_Today:(UIButton *)btn
{
    btn.enabled = YES;
    btn.hidden  = NO;
    btn.tag     = 1;
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor clearColor]];
    
    NSString *dateString = [self dateFormatter:self.date formatter:@"yyyy-MM-dd"];
    NSString *todayString = [self dateFormatter:[NSDate date] formatter:@"yyyy-MM-dd"];
    
    if ([dateString isEqualToString:todayString]) {
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor   = [UIColor orangeColor].CGColor;
        btn.layer.borderWidth   = 1.f;
        btn.layer.cornerRadius  = CGRectGetWidth(btn.bounds) / 2;
    }
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.enabled = YES;
    btn.hidden  = NO;
    btn.tag     = 1;
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)loadData:(NSDictionary *)data
{
    if (!data) return;
    for (UIButton *btn in _daysArray) {
        if (btn.tag == 1) {
            
            NSString *key   = [btn titleForState:UIControlStateNormal];
            NSString *value = [data valueForKey:key];
            
            if (value) {
                
                btn.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
                btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                NSURL *url = [NSURL URLWithString:value];
                
                if (url.scheme && url.host) {
                    
                    UIImageView *imageView = btn.imageView;
                    [imageView sd_setImageWithURL:[NSURL URLWithString:value] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (!error) {
                            [btn setImage:image forState:UIControlStateNormal];
                        }
                    }];
                    
                } else {
                    [btn setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
                }

            }
        }
    }
}

#pragma mark -- DateFormatter

- (NSString *)dateFormatter:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

@end

//
//  ViewController.m
//  ShiSeCalendar
//
//  Created by coder on 15/9/9.
//  Copyright (c) 2015年 coder. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"
@interface ViewController ()<CalendarViewDelegate>

@property (strong, nonatomic) IBOutlet CalendarView *calendarView;

@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.calendarView.calendarDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- CalendarViewDelegate
- (void)calendarViewCurrentDate:(NSDate *)date
{
    NSString *dateString    = [NSString stringWithFormat:@"%@",date];
    NSArray *strings        = [dateString componentsSeparatedByString:@"-"];
    self.yearLabel.text     = [NSString stringWithFormat:@"%@年",strings[0]];
    self.monthLabel.text    = [NSString stringWithFormat:@"%@月",strings[1]];
}

- (void)calendarViewDidSelectWithDate:(NSDate *)date
{
    NSLog(@"select date %@",date);
}

- (void)calendarViewImageUrls:(CalendarItem *)calendarItem
{
    
    //NSArray *array      = [[NSString stringWithFormat:@"%@",calendarItem.date] componentsSeparatedByString:@"-"];
    //NSString *month     = array[1];
    //NSString *imageName = @"info-cover.jpg";
    NSDictionary *dic;
    
    dic = @{
            [self key]:@"http://img4.duitang.com/uploads/item/201307/19/20130719142617_aVfTJ.jpeg",
            [self key]:@"http://img3.imgtn.bdimg.com/it/u=625926037,4267740504&fm=21&gp=0.jpg",
            [self key]:@"http://android-wallpapers.25pp.com/20140321/0905/532b9083025e512_900x675.jpg",
            [self key]:@"http://pic21.nipic.com/20120523/6135725_215324580118_2.jpg",
            [self key]:@"http://photos.tuchong.com/25331/f/1715842.jpg",
            [self key]:@"http://android-wallpapers.25pp.com/20131024/1646/5268de59020559_900x675.jpg",
            [self key]:@"http://pica.nipic.com/2007-11-20/2007112022528742_2.jpg",
            [self key]:@"http://img3.3lian.com/2013/c3/99/d/21.jpg",@"21":@"http://pic1a.nipic.com/2008-10-29/2008102985514980_2.jpg",
            [self key]:@"http://img1.imgtn.bdimg.com/it/u=2624036228,1691383713&fm=21&gp=0.jpg",
            [self key]:@"http://android-wallpapers.25pp.com/20140406/1517/5341002601bba5_900x675.jpg",
            [self key]:@"http://android-wallpapers.25pp.com/20140406/1517/5341002601bba5_900x675.jpg"
            };
    
    [calendarItem loadData:dic];
}

- (NSString *)key
{
    int key = arc4random() % 31;
    return [NSString stringWithFormat:@"%d",key];
}

- (IBAction)lastMonthAction:(UIButton *)sender {
    [self.calendarView lastMonth];
}
- (IBAction)nextMonthAction:(UIButton *)sender {
    [self.calendarView nextMonth];
}



@end

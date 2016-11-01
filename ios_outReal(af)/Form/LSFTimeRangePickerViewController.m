//
//  TimeRangePickerViewController.m
//  YinfengShop
//
//  Created by lessu on 13-12-22.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import "LSFTimeRangePickerViewController.h"



@interface LSFTimeRangePickerViewController()
{
    __weak IBOutlet UIDatePicker *_startDatePicker;
    __weak IBOutlet UIDatePicker *_endDatePicker;
}

@end
@implementation LSFTimeRangePickerViewController
@synthesize startTimeInterval   = _startTimeInterval;
@synthesize endTimeInterval     = _endTimeInterval;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    IOS7_LAYOUT_FIX;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavi];
    self.startTimeInterval = _startTimeInterval;
    self.endTimeInterval   = _endTimeInterval;
}
- (IBAction)closeButtonPressed:(id)sender {
    if (_onClose) {
        _onClose();
    }
}
- (IBAction)confirmButtonPressed:(id)sender {
    if (_onConfirm) {
        _onConfirm(self.startTimeInterval,self.endTimeInterval);
    }
}
- (void)setUpNavi{
    self.title = @"时间选择";
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonPressed:)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;

}
- (NSTimeInterval)startTimeInterval{
    return [_startDatePicker.date timeIntervalSince1970];
}

- (NSTimeInterval)endTimeInterval{
    return [_endDatePicker.date timeIntervalSince1970];
    
}

- (void)setStartTimeInterval:(NSTimeInterval)startTimeInterval{
    _startTimeInterval = startTimeInterval;
    _startDatePicker.date = [NSDate dateWithTimeIntervalSince1970:startTimeInterval];
}

- (void)setEndTimeInterval:(NSTimeInterval)endTimeInterval{
    _endTimeInterval = endTimeInterval;
    _endDatePicker.date = [NSDate dateWithTimeIntervalSince1970:endTimeInterval];
}
@end

//
//  LSFormTimeRangeCell.m
//  YinfengShop
//
//  Created by lessu on 13-12-24.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import "LSFormTimeRangeCell.h"
#import "LSFTimeRangePickerViewController.h"
#import "LSFormTableViewController.h"
@implementation LSFormTimeRangeCell

- (void)onInitWithLabel:(NSString *)label value:(id)value andRule:(NSDictionary *)rule{
    self.textLabel.text         = label;
    self.detailTextLabel.text   = @" ";
    self.detailTextLabel.text   = STRING_EMPTY_IF_NULL(value);
}

- (CGFloat)cellHeight{
    return 44;
}

- (void)setData:(NSArray *)data{
    NSAssert(IS_ARRAY(data), @"data must be an array");

    _data = data;
    self.detailTextLabel.text   = STRING_FORMAT(@"%@-%@",data[0],data[1]);
    
    static NSDateFormatter *formatter;
    if (formatter == NULL) {
        formatter= [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
    }
    _startDate = [formatter dateFromString:data[0]];
    _endDate   = [formatter dateFromString:data[1]];
}

- (void)onSelected:(LSFormTableViewController *)viewController complete:(void (^)())onComplete{
    LSFTimeRangePickerViewController *controller = [[LSFTimeRangePickerViewController alloc]init];
    [viewController presentModalViewController:wrapNavigationController(controller) animated:YES];
    
    controller.title = @"选择时间";
    [controller setOnClose:^{
        [viewController dismissViewControllerAnimated:YES completion:0];
    }];
    
    [controller setOnConfirm:^(NSTimeInterval start, NSTimeInterval end) {
        self.data = @[timeStringOfTimeIntervalWithFormat(start, @"HH:mm"),
                      timeStringOfTimeIntervalWithFormat(end  , @"HH:mm")
                      ];
        if ([self.delegate respondsToSelector:@selector(cell:valuedChanged:)]) {
            [self.delegate cell:self valuedChanged:self.data];
        }
        [viewController dismissViewControllerAnimated:YES completion:^{
            onComplete();
        }];

    }];
    UNUSED_VAR(controller.view);
    controller.startTimeInterval = [_startDate timeIntervalSince1970];
    controller.endTimeInterval   = [_endDate   timeIntervalSince1970];
}


+ (NSDictionary *)mapperWithCellName:(NSString *)cellName keyName:(NSString *)keyName label:(NSString *)label{
    return [LSFormCell mapperWithClassName:@"TimeRange" cellName:cellName keyName:keyName label:label value:nil andRule:@{LSFormCellRuleCellStyleKey:@(UITableViewCellStyleValue1)}];
}
@end

//
//  LSFormSelectCell.m
//  YinfengShop
//
//  Created by lessu on 13-12-25.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import "LSFormSelectCell.h"
#import "LSPickerActionSheet.h"
#import "LSFormTableViewController.h"
#import "LSForm.h"
@interface LSFormSelectCell()
@property(nonatomic,retain) NSDictionary *mapper;
@end
NSString *LSFormSelectCellRuleMapperKey = @"mapper";
@implementation LSFormSelectCell
- (void)onInitWithLabel:(NSString *)label value:(id)value andRule:(NSDictionary *)rule{
    self.textLabel.text = label;
    NSAssert(IS_DICTIONARY(rule[LSFormSelectCellRuleMapperKey]), @"mapper 必须是 dictionary");
    self.selectMapper = rule[LSFormSelectCellRuleMapperKey];
}
- (CGFloat)cellHeight{
    return 44;
}
- (void)setData:(NSString *)data{
    _data = data;
    self.detailTextLabel.text = self.selectMapper[data];
}
- (id)data{
    return _data;
}

- (void)onSelected:(LSFormTableViewController *)viewController complete:(void (^)())onComplete{
    LSPickerActionSheet *pickerActionSheet = [[LSPickerActionSheet alloc]initWithTitle:self.mapper[LSFormTableMapperCellLabelKey] andList:[self.selectMapper allValues]];
    [pickerActionSheet setOnSelected:^BOOL(int index) {
        self.data = [self.selectMapper allKeys][index];
        if ([self.delegate respondsToSelector:@selector(cell:valuedChanged:)]) {
            [self.delegate cell:self valuedChanged:self.data];
        }
        onComplete();
        return true;
    }];
    [pickerActionSheet setOnCancel:^BOOL{
        onComplete();
        return true;
    }];
    [pickerActionSheet showInView:viewController.view.window];
}

+ (NSDictionary *)mapperWithCellName:(NSString *)cellName keyName:(NSString *)keyName label:(NSString *)label andMapper:(NSDictionary *)mapper{
    return [LSFormCell mapperWithClassName:@"Select" 
                                  cellName:cellName 
                                   keyName:keyName   
                                     label:label 
                                     value:nil 
                                   andRule:@{
                                             LSFormCellRuleCellStyleKey     : @(UITableViewCellStyleValue1),
                                             LSFormCellRuleAccessoryTypeKey : @(UITableViewCellAccessoryDisclosureIndicator),
                                             LSFormSelectCellRuleMapperKey  : mapper
                                             }
            ];
}


@end

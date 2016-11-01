//
//  LSFormTextCell.h
//  YinfengShop
//
//  Created by lessu on 13-12-23.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//
// 最简单的FormCell，只显示Label内容

#import "LSFormCell.h"

@interface LSFormTextCell : LSFormCell

+ (NSDictionary *)mapperWithCellName:(NSString *)cellName andKeyName:(NSString *)keyName;
+ (NSDictionary *)mapperWithCellName:(NSString *)cellName andText:(NSString *)text;

+ (NSDictionary *)mapperWithCellName:(NSString *)cellName label:(NSString *)text andDetail:(NSString *)detail;
+ (NSDictionary *)mapperWithCellName:(NSString *)cellName label:(NSString *)text detail:(NSString *)detail andCellStyle:(UITableViewCellStyle)style;
+ (NSDictionary *)mapperWithCellName:(NSString *)cellName label:(NSString *)text detail:(NSString *)detail andCellStyle:(UITableViewCellStyle)style accessoryType:(UITableViewCellAccessoryType)accessoryType;

@end
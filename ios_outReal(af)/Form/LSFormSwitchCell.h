//
//  LSFormSwitchCell.h
//  YinfengShop
//
//  Created by lessu on 13-12-24.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import "LSFormCell.h"

@interface LSFormSwitchCell : LSFormCell
@property(nonatomic,readonly) UISwitch *switchView;
+ (NSDictionary *)mapperWithCellName:(NSString *)cellName keyName:(NSString *)keyName andLabel:(NSString *)label;
@end

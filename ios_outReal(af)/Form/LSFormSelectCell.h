//
//  LSFormSelectCell.h
//  YinfengShop
//
//  Created by lessu on 13-12-25.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import "LSFormCell.h"

@interface LSFormSelectCell : LSFormCell
@property(nonatomic,retain) NSDictionary* selectMapper;

+ (NSDictionary *)mapperWithCellName:(NSString *)cellName keyName:(NSString *)keyName label:(NSString *)label andMapper:(NSDictionary *)mapper;
@end

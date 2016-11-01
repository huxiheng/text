//
//  LSFormTextViewCell.h
//  YinfengShop
//
//  Created by lessu on 13-12-23.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import "LSFormCell.h"

@interface LSFormTextViewCell : LSFormCell<UITextViewDelegate>
@property(nonatomic,retain) UITextView* textView;

+ (NSDictionary *)mapperWithCellName:(NSString *)cellName keyName:(NSString *)keyName andCanEdit:(BOOL)canEdit andHeight:(CGFloat)height;
@end
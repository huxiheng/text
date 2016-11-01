//
//  XSCellModel.h
//  Xieshi
//
//  Created by Tesiro on 16/7/13.
//  Copyright © 2016年 Lessu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface XSCellModel : NSObject
@property (nonatomic, copy)NSString    *title;
@property (nonatomic, copy)NSString    *content;
@property (nonatomic, strong)UIImage   *imagehead;
@property (nonatomic, assign)BOOL      tagColor;
@property (nonatomic, assign)float     heightcontent;
@end

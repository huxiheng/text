//
//  XSViewController.h
//  Xieshi
//
//  Created by Tesiro on 16/7/12.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSViewController : UIViewController

@property (nonatomic, strong)UILabel  *labelNavTitle;
@property (nonatomic, copy)NSString   *titleForNav;

- (void)setData;
- (void)popNav:(UIButton *)btn;

@end

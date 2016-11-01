//
//  AppDelegate.h
//  LSTemplate
//
//  Created by Lessu on 13-7-15.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IS_ENTERPRISE true


#define APP_DELEGATE    ((AppDelegate *) [UIApplication sharedApplication].delegate)
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) XSNavigationViewController *rootNavigationController;
@property(nonatomic,retain) UITabBarController     *rootTabbarController;

@end

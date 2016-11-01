//
//  AppDelegate.m
//  LSTemplate
//
//  Created by Lessu on 13-7-15.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import "AppDelegate.h"
#import "LSTabBarViewController.h"
#import "LogInViewController.h"
//#import "ZBarReaderView.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "RegexKitLite.h"
@implementation AppDelegate
BOOL versionNameBiggerThan(NSString *versionName1,NSString *versionName2);
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.rootNavigationController = [[XSNavigationViewController alloc] initWithRootViewController:[[LogInViewController alloc] init]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithHexString:kcolorBJ_f0eff4];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = self.rootNavigationController;
    
//    _rootTabbarController = [[LSTabBarViewController alloc]init];
////    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:_rootTabbarController];
//    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//    self.window.rootViewController = _rootNavigationController;
//    
//    [self appearance];
//	[ZBarReaderView class];
//
    [self applicationWillEnterForeground:application];
    
    
    if (!IS_ENTERPRISE) {
        return YES;
    }
    
    NSDictionary *params = @{
                             @"PlatformType" : @"2",
                             @"SystemType"   : @"1"
                             };
    AFNetConnection *connection = [[AFNetConnection alloc]initWithConnectionUrlString:@"http://www.scetia.com/scetia.app.ws/ServiceUST.asmx/GetAppVersion"];
    connection.params = @{@"param":[params JSONFragment]};
    connection.requestMethod = kAFNetConnectionRequestTypeGet;
    [connection setResultType:kAFNetConnectionTypePlain];
    [connection setOnSuccess:^(id resultString) {
//      NSString *responseString = (NSString *)resultString;
//        NSLog(@"responseString = %@",responseString);
//        //得到目录
//        
//        
//        DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:responseString options:0 error:nil];
//        NSLog(@"doc = %@",doc);
//        DDXMLElement *root=[[doc rootElement] copy];
//        NSLog(@"root = %@",root);
//         NSArray *array = [root children];
//        for (int i = 0; i < [array count]; i++) {
//            DDXMLElement *ele = [array objectAtIndex:i];
//            NSLog(@"%@",[ele stringValue]);
//            NSData *jsonData = [[ele stringValue] dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                options:NSJSONReadingMutableContainers
//                                                                  error:&err];
//            NSLog(@"dic ======= %@",dic[@"Data"][0][@"Version"]);
//        }
        
        NSString *responseString = resultString;
        
        responseString = [responseString stringByMatching:@">\\{.+\\}</"];
        responseString = [responseString stringByReplacingOccurrencesOfString:@">{" withString:@"{" ];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"}</" withString:@"}" ];
        resultString = responseString;
        
        NSLog(@"resultString = %@",resultString);
        
        
        NSDictionary *result = [resultString JSONValue];
        [SVProgressHUD dismiss];
        result = result[@"Data"][0];
        if (versionNameBiggerThan(result[@"Version"],[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"])){
//            ![[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"] isEqualToString:result[@"Version"]]) {
            if ([result[@"Update_Flag"] integerValue] == 1){
                [LSDialog showDialogWithTitle:@"发现新版本" message:result[@"Description"]confirmText:@"升级" confirmCallback:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result[@"Update_Url"]]];
                } cancelText:@"取消" cancelCallback:^{
                    
                }];                    
            }else{
                [LSDialog showAlertWithTitle:@"发现新版本" message:result[@"Description"] callBack:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result[@"Update_Url"]]];
                }];
            }
            
            
        }
    }];
    [connection setOnFailed:^(NSError *error) {
        NSString *errorDescription = [error localizedDescription];
        [SVProgressHUD dismissWithError:STRING_FORMAT(@"%@",errorDescription) afterDelay:2.5f];
    }];
    [connection setOnFinal:^{
        
    }];
    [SVProgressHUD show];
    [connection startAsynchronous];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)appearance{
    //navigation
    UINavigationBar *navibarAppearance = [UINavigationBar appearance];
    if(IS_IOS7){
        
//        [navibarAppearance setBackgroundColor:[UIColor colorWithRed:41/255.0 green:124/255.0 blue:99/255.0 alpha:1.0]];
        [navibarAppearance setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]}];
        [navibarAppearance setTintColor:[UIColor whiteColor]];
        [navibarAppearance setBarTintColor:[UIColor colorWithRed:41/255.0 green:124/255.0 blue:199/255.0 alpha:1.0]];

    }else{
        [navibarAppearance setBackgroundImage:[UIImage imageNamed:@"bg_navigation_bar"] forBarMetrics:UIBarMetricsDefault];
        [navibarAppearance setBackgroundImage:[UIImage imageNamed:@"bg_navigation_bar"] forBarMetrics:UIBarMetricsLandscapePhone];
        UIImage *barButtonNormal    = [[UIImage imageNamed:@"btn_navigation_item_n"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,5,0,15)];
        UIImage *barButtonPressed   = [[UIImage imageNamed:@"btn_navigation_item_n"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,5,0,15)];
        
        UIImage *backButtonNormal    = [[UIImage imageNamed:@"btn_navigation_back_n"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,15,0,5)];
        UIImage *backButtonPressed   = [[UIImage imageNamed:@"btn_navigation_back_p"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,15,0,5)];
        
        UIBarButtonItem *barButtonAppearance = [UIBarButtonItem appearance];
        [barButtonAppearance setBackgroundImage:barButtonNormal              forState:UIControlStateNormal          barMetrics:UIBarMetricsDefault];
        [barButtonAppearance setBackgroundImage:barButtonPressed              forState:UIControlStateHighlighted    barMetrics:UIBarMetricsDefault];
        
        [barButtonAppearance setBackgroundImage:barButtonNormal              forState:UIControlStateNormal          barMetrics:UIBarMetricsLandscapePhone];
        [barButtonAppearance setBackgroundImage:barButtonPressed              forState:UIControlStateHighlighted    barMetrics:UIBarMetricsLandscapePhone];
        
        [barButtonAppearance setBackButtonBackgroundImage:backButtonNormal   forState:UIControlStateNormal          barMetrics:UIBarMetricsDefault];
        [barButtonAppearance setBackButtonBackgroundImage:backButtonPressed   forState:UIControlStateHighlighted    barMetrics:UIBarMetricsDefault];
        
        [barButtonAppearance setBackButtonBackgroundImage:backButtonNormal   forState:UIControlStateNormal          barMetrics:UIBarMetricsLandscapePhone];
        [barButtonAppearance setBackButtonBackgroundImage:backButtonPressed   forState:UIControlStateHighlighted    barMetrics:UIBarMetricsLandscapePhone];
    }
    
    //tabbar
    UITabBar *tabbarAppearance = [UITabBar appearance];
    [tabbarAppearance setBackgroundImage:[UIImage imageNamed:@"bg_tabbar"]];
    
}

@end

BOOL versionNameBiggerThan(NSString *versionName1,NSString *versionName2){
    NSArray *component1 = [versionName1 componentsSeparatedByString:@"."];   
    NSArray *component2 = [versionName2 componentsSeparatedByString:@"."];
    for (int i = 0 ; i < MIN(component1.count, component2.count); i++) {
        if ([component1[i] integerValue] == [component2[i] integerValue]) {
            continue ;
        }else{
            return [component1[i] integerValue] > [component2[i] integerValue];
        }
    }
    return component1.count>component2.count;
}

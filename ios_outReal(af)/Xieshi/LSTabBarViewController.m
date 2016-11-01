//
//  LSTabBarViewController.m
//  Aichi
//
//  Created by Lessu on 13-10-16.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import "LSTabBarViewController.h"

@interface LSTabBarViewController ()

@end

@implementation LSTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
    [self setUpTabs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpTabs{
//    UIViewController *homeVC = [[HomePageViewController alloc]init];
//	UINavigationController *homeNC = [[UINavigationController alloc]initWithRootViewController:homeVC];
//    //
//    
//	UIViewController *profileVC = [[ProfileViewController alloc]init];
//	UINavigationController *profileNC = [[UINavigationController alloc]initWithRootViewController:profileVC];
//    
//	UIViewController *areaVC = [[AreaCateViewController alloc]init];
//	UINavigationController *areaNC = [[UINavigationController alloc]initWithRootViewController:areaVC];
//    
//	UIViewController *deliverVC = [[OrderShipListViewController alloc]init];
//	UINavigationController *deliverNC = [[UINavigationController alloc]initWithRootViewController:deliverVC];
//    //
//	UIViewController *moreVC = [[MoreViewController alloc]init];
//	UINavigationController *moreNC = [[UINavigationController alloc]initWithRootViewController:moreVC];
//    //
//	self.viewControllers = @[homeNC,profileNC,areaNC,deliverNC,moreNC];
//    //
//	[homeVC release];
//	[homeNC release];
//	
//	[profileVC release];
//	[profileNC release];
//	
//	[areaVC release];
//	[areaNC release];
//	
//	[deliverVC release];
//	[deliverNC release];
//	
//	[moreVC release];
//	[moreNC release];
//	
	int count = 5;
    NSArray *titleOfTab = @[@"购物车",@"餐馆",@"热门",@"个人中心",@"更多"];
    for (int i = 0; i<count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        [item setFinishedSelectedImage:[UIImage imageNamed:STRING_FORMAT(@"icon_tabbar_item_%.2d_p",count)] withFinishedUnselectedImage:[UIImage imageNamed:STRING_FORMAT(@"icon_tabbar_item_%.2d_n",count)]];
        [item setTitle:titleOfTab[i]];
    }
}
- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    int index = [self.viewControllers indexOfObject:viewController];
    switch (index) {
        case 0:
        case 2:
        case 4:
            return true;
            break;
        case 1:
        case 3:
            //            [YFUtil presentLoginViewControllerIfNotLogin];
            //            //            return [YFUtil isLogin];
            //            if(isLogin) return true;
            //            [LSDialog showDialogWithTitle:@"你还没有登陆" message:@"现在就去登陆吗" confirmText:@"去登陆" confirmCallback:^{
            //                UserLoginViewController *controller = [[UserLoginViewController alloc]init];
            //                UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
            //                [self presentModalViewController:navigationController animated:YES];
            //                [controller release];
            //                [navigationController release];
            //                [controller setOnLoginSuccessfully:^{
            //                    [navigationController dismissModalViewControllerAnimated:YES];
            //                }];
            //            } cancelText:@"取消" cancelCallback:^{
            //            }];
            return false;
            break;
        default:
            return false;
            break;
    }
}
@end

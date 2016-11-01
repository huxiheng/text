//
//  XSViewController.m
//  Xieshi
//
//  Created by Tesiro on 16/7/12.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import "XSViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface XSViewController ()

@end

@implementation XSViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count==1) {
        self.navigationController.navigationBar.hidden = YES;
    }else{
        self.navigationController.navigationBar.hidden = NO;
    }
    
    if (self.navigationController&&[self.navigationController.viewControllers count]==1) {
//        self.navigationController.interactivePopGestureRecognizer.enabled =YES;
//        [self replaceSystemGesture];
    }
    else {
        self.navigationController.interactivePopGestureRecognizer.enabled =YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationController.fd_interactivePopDisabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id<UIGestureRecognizerDelegate>)self;
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [self setTitleforNavgationVicontroller];
    
    if (self.navigationController.viewControllers.count>1) {
      self.navigationItem.leftBarButtonItem =  [self setbackNavGationBarIterm];
    }else {
        
    }
    
}

- (void)setTitleforNavgationVicontroller {
    self.labelNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];
    self.labelNavTitle.text = self.titleForNav;
    self.labelNavTitle.textColor = [UIColor whiteColor];
    self.labelNavTitle.textAlignment = NSTextAlignmentCenter;
    self.labelNavTitle.font = [UIFont systemFontOfSize:15];
    self.navigationItem.titleView = self.labelNavTitle;
    
}

- (UIBarButtonItem *)setbackNavGationBarIterm{
    UIBarButtonItem *leftBarIterm = [[UIBarButtonItem alloc] init];
    UIButton * leftBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBarButton setImage:[UIImage imageNamed:@"houtui"] forState:UIControlStateNormal];
    [leftBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [leftBarButton addTarget:self action:@selector(popNav:) forControlEvents:UIControlEventTouchUpInside];
    [leftBarIterm setCustomView:leftBarButton];
    return leftBarIterm;
}

- (void)popNav:(UIButton *)btn{
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
    }
}

- (void)setData {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

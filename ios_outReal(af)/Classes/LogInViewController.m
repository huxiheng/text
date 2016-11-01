//
//  LogInViewController.m
//  Xieshi
//
//  Created by Tesiro on 16/7/12.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import "LogInViewController.h"
//#import "ReportDetailViewController.h"
#import "ReportCheckViewController.h"
#import "QRCodeViewController.h"
#import "NSObject+SBJSON.h"
#import "RegexKitLite.h"
#import "ProjectDetailViewController.h"

@interface LogInViewController (){
    
}

@property (nonatomic, strong)UILabel *labelVersion;

@end

@implementation LogInViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

- (void)initSubViews {
    self.viewBG = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.view addSubview:self.viewBG];
    
    UIScrollView *scrollviewBG = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollviewBG.contentSize = CGSizeMake(DeviceWidth, DeviceHeight);
    scrollviewBG.bounces = YES;
    scrollviewBG.scrollEnabled =YES;
//    scrollviewBG.delegate = self;
    scrollviewBG.showsVerticalScrollIndicator = NO;
    scrollviewBG.showsHorizontalScrollIndicator = NO;
    scrollviewBG.pagingEnabled =YES;
    scrollviewBG.scrollEnabled = YES;
//    [self.view addSubview:scrollviewBG];
    [scrollviewBG addSubview:self.viewBG];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tableHeaderView = scrollviewBG;
    [self.view addSubview:table];
    
    self.imageViewBG = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.imageViewBG.image = [UIImage imageNamed:@"logo"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickImag:)];
    tap.cancelsTouchesInView = NO;
    [self.imageViewBG addGestureRecognizer:tap];
    self.imageViewBG.userInteractionEnabled = YES;
    [self.viewBG addSubview:self.imageViewBG];
    
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,kscaleDeviceHeight(224) , DeviceWidth,kscaleDeviceLength(25))];
    self.labelTitle.backgroundColor = [UIColor clearColor];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    self.labelTitle.text=@"报告查询";
    self.labelTitle.font = themeFont20;
    self.labelTitle.textColor = [UIColor whiteColor];
    [self.imageViewBG addSubview:self.labelTitle];
    
    self.labelVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, kscaleDeviceHeight(252), DeviceWidth, 10)];
    self.labelVersion.text=[NSString stringWithFormat:@"V%@",kVersion];
    self.labelVersion.textColor = [UIColor whiteColor];
    self.labelVersion.font = themeFont10;
    self.labelVersion.textAlignment = NSTextAlignmentCenter;
    [self.imageViewBG addSubview:_labelVersion];
    
    self.viewLog = [[UIView alloc] initWithFrame:CGRectMake((DeviceWidth-245)/2, kscaleDeviceLength(314), 245, kscaleDeviceLength(100))];
    self.viewLog.backgroundColor = [UIColor whiteColor];
    self.viewLog.layer.cornerRadius = 5;
    self.viewLog.layer.masksToBounds = YES;
    [self.viewBG addSubview: self.viewLog];
    
    self.textFieldReportNum = [[UITextField alloc] initWithFrame:CGRectMake(10, kscaleDeviceLength(0), 225, kscaleDeviceLength(50))];
    self.textFieldReportNum.placeholder = @"   报告编号";
    self.textFieldReportNum.textColor = [UIColor colorWithHexString:kc00_8c8c8c];
    self.textFieldReportNum.font = themeFont12;
//    self.textFieldReportNum.clearsOnBeginEditing = YES;
    self.textFieldReportNum.clearButtonMode = UITextFieldViewModeAlways;
    UIImageView *imageReportNum = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 21, 21)];
    imageReportNum.image = [UIImage imageNamed:@"logHXHbaogaobianhao"];
    self.textFieldReportNum.leftView = imageReportNum;
    self.textFieldReportNum.leftViewMode= UITextFieldViewModeAlways;
    self.textFieldReportNum.delegate = self;
    [self.viewLog addSubview:self.textFieldReportNum];
    
    UIView *viewLine =[[UIView alloc] initWithFrame:CGRectMake(0, kscaleDeviceLength(50), 245, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:kcolorBJ_f0eff4];
    [self.viewLog addSubview:viewLine];
    
    self.textFieldCheckCode = [[UITextField alloc] initWithFrame:CGRectMake(10, kscaleDeviceLength(51), 225, kscaleDeviceLength(49))];
    self.textFieldCheckCode.placeholder = @"   防伪校验码";
    self.textFieldCheckCode.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldCheckCode.textColor = [UIColor colorWithHexString:kc00_8c8c8c];
    self.textFieldCheckCode.font = themeFont12;
    self.textFieldCheckCode.clearsOnBeginEditing = YES;
    self.textFieldCheckCode.clearButtonMode = UITextFieldViewModeAlways;
    UIImageView *imageCheckCode = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 21, 21)];
    imageCheckCode.image = [UIImage imageNamed:@"jiaoyanma"];
    self.textFieldCheckCode.leftView = imageCheckCode;
    self.textFieldCheckCode.leftViewMode = UITextFieldViewModeAlways;
    self.textFieldCheckCode.delegate = self;
    [self.viewLog addSubview:self.textFieldCheckCode];
    
    self.buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonSure.frame = CGRectMake((DeviceWidth-245)/2, kscaleDeviceLength(459), 245, kscaleDeviceLength(39));
    self.buttonSure.layer.cornerRadius = 5;
    self.buttonSure.layer.masksToBounds = YES;
    [self.buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    self.buttonSure.titleLabel.font = themeFont16;
    self.buttonSure.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.buttonSure setTitleColor:[UIColor colorWithHexString:kc00_717171] forState:UIControlStateNormal];
    [self.buttonSure setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:kc00_AAD5EE]] forState:UIControlStateNormal];
    [self.buttonSure setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:kc00_0062A3]] forState:UIControlStateHighlighted];
    [self.buttonSure setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.buttonSure addTarget:self action:@selector(clickBtnSure:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBG addSubview:self.buttonSure];
    
    
    self.buttonZBar = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonZBar.frame = CGRectMake((DeviceWidth-245)/2, kscaleDeviceLength(524), 245, kscaleDeviceLength(39));
    self.buttonZBar.layer.cornerRadius = 5;
    self.buttonZBar.layer.masksToBounds = YES;
    [self.buttonZBar setTitle:@"二维码" forState:UIControlStateNormal];
    self.buttonZBar.titleLabel.font = themeFont16;
    self.buttonZBar.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.buttonZBar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonZBar setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:kc00_7ED127]] forState:UIControlStateNormal];
    [self.buttonZBar setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:kc00_0062A3]] forState:UIControlStateHighlighted];
    [self.buttonZBar addTarget:self action:@selector(clickbtnZBar:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBG addSubview:self.buttonZBar];
    
    
    
    if ([UIDevice currentDevice].isIphone4||DeviceHeight<500) {
//        scrollviewBG.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        self.labelTitle.frame = CGRectMake(0,kscaleDeviceHeight(209) , DeviceWidth,kscaleDeviceLength(25));
        self.labelVersion.frame= CGRectMake(0, kscaleDeviceHeight(239), DeviceWidth, 10);
        self.viewLog.frame = CGRectMake((DeviceWidth-245)/2, kscaleDeviceLength(314-20-10-5), 245, kscaleDeviceLength(100));
        self.buttonSure.frame =CGRectMake((DeviceWidth-245)/2, kscaleDeviceLength(414-10-5), 245, kscaleDeviceLength(39));
//        self.buttonZBar.frame = CGRectMake((DeviceWidth-245)/2, DeviceHeight-10-20-kscaleDeviceLength(39), 245, kscaleDeviceLength(39));
        self.buttonZBar.frame = CGRectMake((DeviceWidth-245)/2, kscaleDeviceLength(414+39+20-10-5-4.5), 245, kscaleDeviceLength(39));
        
        
    }
}

#pragma mark ---UITEXTFieldDelegate-----
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textFieldCheckCode resignFirstResponder];
    [self.textFieldReportNum resignFirstResponder];
    
    return YES;
}

#pragma mark ----UISCROLLViewDelegate-----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.textFieldCheckCode resignFirstResponder];
    [self.textFieldReportNum resignFirstResponder];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)clickBtnSure:(UIButton *)btn{
    //    BOOL success;
    //    NSString *message;
    [self.textFieldCheckCode resignFirstResponder];
    [self.textFieldReportNum resignFirstResponder];
    
    NSString *checksum = self.textFieldCheckCode.text;
    NSString *keyId = self.textFieldReportNum.text;
    if (checksum.length   == 10){
        if(![keyId isMatchedByRegex:@"^\\D*\\d{8}$"]&&![keyId isMatchedByRegex:@"^\\D*\\d{12}$"]){
            [LSDialog showMessage:@"当前录入的报告编号错误"];
            return;
        }
    }else if(checksum.length == 12){
        if(![keyId isMatchedByRegex:@"^\\D*\\d{9}$"]){
            [LSDialog showMessage:@"当前录入的报告编号错误"];
            return;
        }
    }else{
        [LSDialog showAlertWithTitle:@"提示" message:@"您当前输入的验证码长度不正确" callBack:0];
        return;
        
    }
    NSDictionary *params = @{
                             @"Report_id":keyId,
                             @"Checksum":checksum
                             };
    apiConnectionAsyncWithIndicator(AFNETMETHOD_REPORT_DETAIL, JSON_PARAM(params), ^NSString *(NSDictionary* result){
        if (IS_DICTIONARY( result[kAFNETConnectionStandartDataKey]) ) {
            ReportCheckViewController *reportCheckVC = [[ReportCheckViewController alloc] init];
//            reportCheckVC.dataDic = [[NSDictionary alloc] init];
            reportCheckVC.dataDic = result[kAFNETConnectionStandartDataKey];
            reportCheckVC.keyId =keyId;
            reportCheckVC.checksum = checksum;
            [self.navigationController pushViewController:reportCheckVC animated:YES];
//            ReportDetailViewController *controller = [[ReportDetailViewController alloc]init];
//            controller.data = result[kAPIConnectionStandartDataKey];
//            controller.keyId = keyId;
//            controller.checksum = checksum;
//            [self.navigationController pushViewController:controller animated:YES];
            
        }else if(IS_ARRAY( result[kAFNETConnectionStandartDataKey]) && ARRAY_CAST(result[kAFNETConnectionStandartDataKey]).count>0){
            ProjectDetailViewController *controller = [[ProjectDetailViewController alloc]init];
            controller.keyId = keyId;
            controller.checksum = checksum;
            controller.data = result[kAFNETConnectionStandartDataKey][0];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            return @"没有数据";
        }
        
        return nil;
    });
}

- (void)clickbtnZBar:(UIButton *)btn{
    QRCodeViewController *controller = [[QRCodeViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller setOnRecognized:^(NSString *result) {
        NSArray *components =[result componentsSeparatedByString:@"|"];
        if (components.count == 2) {
            NSString *keyId = components[0];
            NSString *checksum = components[1];
            NSDictionary *params = @{
                                     @"Report_id":keyId,
                                     @"Checksum":checksum
                                     };
            apiConnectionAsyncWithIndicator(AFNETMETHOD_REPORT_DETAIL, JSON_PARAM(params), ^NSString *(NSDictionary* result){
                if (IS_DICTIONARY( result[kAFNETConnectionStandartDataKey]) ) {
                    ReportCheckViewController *reportCheckVC = [[ReportCheckViewController alloc] init];
                    reportCheckVC.dataDic = result[kAFNETConnectionStandartDataKey];
                    reportCheckVC.keyId =keyId;
                    reportCheckVC.checksum = checksum;
                    [self.navigationController pushViewController:reportCheckVC animated:YES];
//                    ReportDetailViewController *controller = [[ReportDetailViewController alloc]init];
//                    controller.data = result[kAPIConnectionStandartDataKey];
//                    controller.keyId = keyId;
//                    controller.checksum = checksum;
//                    [self.navigationController pushViewController:controller animated:YES];
                    
                }else if(IS_ARRAY( result[kAFNETConnectionStandartDataKey]) && ARRAY_CAST(result[kAFNETConnectionStandartDataKey]).count>0){
                    ProjectDetailViewController *controller = [[ProjectDetailViewController alloc]init];
                    controller.keyId = keyId;
                    controller.checksum = checksum;
                    controller.data = result[kAFNETConnectionStandartDataKey][0];
                    [self.navigationController pushViewController:controller animated:YES];
                }else{
                    return @"没有数据";
                }
                
                return nil;
            });
        }else{
            [LSDialog showMessage:@"二维码不正确"];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        return;
        
        /*
        NSURL *url = [NSURL URLWithString:result];
        if (!url) {
            [LSDialog showMessage:@"二维码不正确"];
            return ;
        }
        __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:url];
        __weak ASIHTTPRequest *wRequest = request;
        [request setCompletionBlock:^{
            [LSDialog showMessage:@"二维码不正确"];
        }];
        [request setFailedBlock:^{
            if (wRequest.responseStatusCode == 302) {
                NSString *location =  wRequest.responseHeaders[@"Location"];
                [location enumerateStringsMatchedByRegex:@"parwam=(.+?)\\|(.+?)$" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                    if (captureCount == 3) {
                        NSString *keyId = capturedStrings[1];
                        NSString *checksum = capturedStrings[2];
                        NSDictionary *params = @{
                                                 @"Report_id":keyId,
                                                 @"Checksum":checksum
                                                 };
                        apiConnectionAsyncWithIndicator(APIMETHOD_REPORT_DETAIL, JSON_PARAM(params), ^NSString *(NSDictionary* result){
                            if (IS_DICTIONARY( result[kAPIConnectionStandartDataKey]) ) {
                                ReportCheckViewController *reportCheckVC = [[ReportCheckViewController alloc] init];
                                reportCheckVC.dataDic = result[kAPIConnectionStandartDataKey];
                                reportCheckVC.keyId =keyId;
                                reportCheckVC.checksum = checksum;
                                [self.navigationController pushViewController:reportCheckVC animated:YES];
//                                ReportDetailViewController *controller = [[ReportDetailViewController alloc]init];
//                                controller.data = result[kAPIConnectionStandartDataKey];
//                                controller.keyId = keyId;
//                                controller.checksum = checksum;
//                                [self.navigationController pushViewController:controller animated:YES];
                                
                            }else if(IS_ARRAY( result[kAPIConnectionStandartDataKey]) && ARRAY_CAST(result[kAPIConnectionStandartDataKey]).count>0){
                                ProjectDetailViewController *controller = [[ProjectDetailViewController alloc]init];
                                controller.keyId = keyId;
                                controller.checksum = checksum;
                                controller.data = result[kAPIConnectionStandartDataKey][0];
                                [self.navigationController pushViewController:controller animated:YES];
                            }else{
                                return @"没有数据";
                            }
                            
                            return nil;
                        });
                        *stop = true;
                    }else{
                        [LSDialog showMessage:@"二维码不正确"];
                    }
                }];
                //
                //                NSLog(@"%@",location);
            }else{
                [LSDialog showMessage:@"二维码不正确"];
                
            }
        }];
        [request startAsynchronous];
        //        NSArray *components = [result componentsSeparatedByString:@"|"];
        //        if (components.count == 2) {
        //
        //        }else{
        //            [LSDialog showMessage:@"二维码不正确"];
        //        }
         */
        
    }];
        
         
}

- (void)tapClickImag:(UITapGestureRecognizer*)tap{
    [self.textFieldReportNum resignFirstResponder];
    [self.textFieldCheckCode resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification*)notification{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    CGFloat keyOriginY = keyboardFrame.origin.y;
    CGFloat space = keyOriginY-self.viewLog.frame.origin.y;
    if (space<100 && ![UIDevice currentDevice].isIphone4) {
        self.viewBG.frame = CGRectMake(0, -90, DeviceWidth, DeviceHeight-90);
    }else {
        self.viewBG.frame = CGRectMake(0, -height+100   , DeviceWidth, DeviceHeight-height+100);
    }
    
    if (DeviceHeight<500) {
        self.viewBG.frame = CGRectMake(0, -height+100   , DeviceWidth, DeviceHeight);
    }else if(DeviceHeight<600&&DeviceHeight>500){
        self.viewBG.frame = CGRectMake(0, -height+160   , DeviceWidth, DeviceHeight);
        
    }
    NSLog(@"%F",DeviceHeight);
    
    
}

- (void)keyBoardWillHiden:(NSNotification *)notification{
    self.viewBG.frame =[UIScreen mainScreen].bounds;
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

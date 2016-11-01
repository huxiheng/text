//
//  LSFast.m
//  Aichi
//
//  Created by Lessu on 13-10-21.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import "LSFast.h"


UINavigationController * wrapNavigationController(UIViewController *controller){
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
    return navigationController;
}

NSString *fullTimeStringOfTimeInterval(NSTimeInterval timeInterval){
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *string = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    
	return string;
}

NSString *timeStringOfTimeIntervalWithFormat(NSTimeInterval timeInterval,NSString *format){
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
	NSString *string = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
	return string;
}
#pragma mark connection functions
void apiConnectionAsyncWithIndicator(NSString *apiName,NSDictionary *params,NSString* (^onSuccess)(id result)){
    AFNetConnection *connection= [[AFNet sharedInstance]connectionWithApiName:apiName params:params];
    [connection setOnSuccess:^(id result) {
        NSString *message = @"成功";
        if (onSuccess) {
            message = onSuccess(result);
        }
        if (message == NULL) {
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD dismissWithSuccess:message];
        }
    }];
    [connection setOnFailed:^(NSError *error) {
        NSString *errorDescription = [error localizedDescription];
        [SVProgressHUD dismissWithError:STRING_FORMAT(@"%@",errorDescription) afterDelay:2.0f];
    }];
    [connection setOnFinal:^{
        
    }];
    [SVProgressHUD show];
    [connection startAsynchronous];
}

void apiConnectionAsyncNoIndicator(NSString *apiName,NSDictionary *params,void (^onSuccess) (id result)){
    AFNetConnection *connection= [[AFNet sharedInstance]connectionWithApiName:apiName params:params];
    if (onSuccess) {
        [connection setOnSuccess:^(id result) {
            onSuccess(result);
        }];
    }
    [connection setOnFailed:^(NSError *error) {
        NSString *errorDescription = [error localizedDescription];
        [SVProgressHUD showErrorWithStatus:STRING_FORMAT(@"%@",errorDescription) duration:2.0f];
    }];
    [connection startAsynchronous];
}

#pragma mark with cache enabled
void apiConnectionAsyncWithIndicatorAndCache(NSString *apiName,NSDictionary *params,NSString* (^onSuccess)(id result)){
    AFNetConnection *connection= [[AFNet sharedInstance]connectionWithApiName:apiName params:params];
    connection.addCache = true;
    [connection setOnSuccess:^(id result) {
        NSString *message = @"成功";
        if (onSuccess) {
            message = onSuccess(result);
        }
        if (message == NULL) {
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD dismissWithSuccess:message];
        }
    }];
    [connection setOnFailed:^(NSError *error) {
        NSString *errorDescription = [error localizedDescription];
        [SVProgressHUD dismissWithError:STRING_FORMAT(@"%@",errorDescription) afterDelay:2.0f];
    }];
    [connection setOnFinal:^{
        
    }];
    [SVProgressHUD show];
    [connection loadFromCache];
    [connection startAsynchronous];
}


void apiConnectionAsyncNoIndicatorWithCache(NSString *apiName,NSDictionary *params,void (^onSuccess) (id result)){
    AFNetConnection *connection= [[AFNet sharedInstance]connectionWithApiName:apiName params:params];
    connection.addCache = true;
    [connection setOnSuccess:^(id result) {
        onSuccess(result);
    }];
    [connection setOnFailed:^(NSError *error) {
        NSString *errorDescription = [error localizedDescription];
        [SVProgressHUD showErrorWithStatus:STRING_FORMAT(@"%@",errorDescription) duration:2.0f];
    }];
    [connection setOnFinal:^{
        
    }];
    [connection loadFromCache];
    [connection startAsynchronous];
}

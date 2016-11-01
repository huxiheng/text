//
//  QRCodeViewController.h
//  XieshiPrivate
//
//  Created by Tesiro on 16/10/25.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import "XSViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController : XSViewController<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>{
    void (^_onRecognized)(NSString *data);
}
@property (nonatomic, strong)AVCaptureDevice * device;
@property (nonatomic, strong)AVCaptureDeviceInput * input;
@property (nonatomic, strong)AVCaptureMetadataOutput * output;
@property (nonatomic, strong)AVCaptureSession * session;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, copy)NSString *titleBackBtn;

@property(nonatomic,copy) void (^onRecognized)(NSString *data);

@end

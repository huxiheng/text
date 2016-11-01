//
//  QRCodeViewController.m
//  XieshiPrivate
//
//  Created by Tesiro on 16/10/25.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import "QRCodeViewController.h"
#import "LoadCapturePreView.h"
#import "ScanningView.h"

@interface QRCodeViewController ()
@property (nonatomic, strong)LoadCapturePreView *loadCapturePreview;  //预加载
@property (nonatomic, strong)ScanningView *scanningView;   //扫描view
@property (nonatomic, strong)NSTimer     *timer;         //定时器用来改变图片
@property    int num;
@property    BOOL upOrdown;

@end

@implementation QRCodeViewController

-(void)setData{
    self.titleForNav = @"扫描条码";
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cameraIsReady:)
                                                 name:AVCaptureSessionDidStartRunningNotification object:nil];
    
}
//绿线上下移动
-(void)animation1
{
    if (self.upOrdown == NO) {
        self.num ++;
        self.scanningView.lineImage.frame = CGRectMake(kscaleIphone5DeviceLength(50), kscaleIphone5DeviceLength(90) +2*self.num, DeviceWidth- kscaleIphone5DeviceLength(100), 2);
        if (DeviceHeight<500) {
            if (2*self.num >=198 ) {
                self.upOrdown = YES;
            }
        }else{
            if (2*self.num >=(DeviceWidth- kscaleIphone5DeviceLength(100)) ) {
                self.upOrdown = YES;
            }
        }
    }
    else {
        self.num --;
        self.scanningView.lineImage.frame = CGRectMake(kscaleIphone5DeviceLength(50), kscaleIphone5DeviceLength(90) +2*self.num, DeviceWidth- kscaleIphone5DeviceLength(100), 2);
        if (self.num <= 0) {
            self.upOrdown = NO;
        }
    }
}

- (void)setSubviews{
    self.loadCapturePreview =[[LoadCapturePreView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self.loadCapturePreview startLoading];
    [self.view addSubview:self.loadCapturePreview];
    
    self.scanningView =[[ScanningView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self.view addSubview:self.scanningView];
    [self.view bringSubviewToFront:self.scanningView];
    [self.scanningView hiddenSubviews:YES];
    
    self.navigationItem.leftBarButtonItem = [self returnBackBotton];
    
}

- (UIBarButtonItem *)returnBackBotton{
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc] init];
    UIButton *btnleftView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 44)];
    UIImageView *imageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
    imageLeft.image = [UIImage imageNamed:@"btn_detail_back"];
    [btnleftView addSubview:imageLeft];
    UILabel *lableLeft = [[UILabel alloc] initWithFrame:CGRectMake(20 , 0, 70, 44)];
    //    lableLeft.text = self.titleBackBtn;
    lableLeft.font = themeFont15;
    [btnleftView addSubview:lableLeft];
    
    [leftItem  setCustomView:btnleftView];
    [btnleftView addTarget:self action:@selector(popNav:) forControlEvents:UIControlEventTouchUpInside];
    
    return leftItem;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self setupCamera];
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [_session stopRunning];
    [self.timer invalidate];
}
- (void)setupCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的\"设置－隐私－相机\"中允许健一健康访问您的相机。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
#if !(TARGET_IPHONE_SIMULATOR)
        if (_session ==nil &&_device ==nil) {
            // Device
            _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
            // Input
            _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
            
            // Output
            _output = [[AVCaptureMetadataOutput alloc]init];
            [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            // Session
            _session = [[AVCaptureSession alloc]init];
            [_session setSessionPreset:AVCaptureSessionPresetHigh];
            if ([_session canAddInput:self.input])
            {
                [_session addInput:self.input];
            }
            
            if ([_session canAddOutput:self.output])
            {
                [_session addOutput:self.output];
            }
            
            // 条码类型 AVMetadataObjectTypeQRCode
            //    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
            [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code, nil]];
           
            
            // Preview
            _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _preview.frame =CGRectMake(0, 0, DeviceWidth, DeviceHeight);
            [self.scanningView.layer insertSublayer:self.preview atIndex:0];
            
            
        }
        // Start
        [_session startRunning];
#endif
        
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"----%@",stringValue);
        if(_onRecognized) _onRecognized(stringValue);
        [self.timer invalidate];
        
    }
    [_session stopRunning];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}

- (void)cameraIsReady:(id)noyi {
    [self.loadCapturePreview stopLoading];
    [self.loadCapturePreview removeFromSuperview];
    self.loadCapturePreview =nil;
    [self.scanningView hiddenSubviews:NO];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.onRecognized = nil;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [_session startRunning];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

@end

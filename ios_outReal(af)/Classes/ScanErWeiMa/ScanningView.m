//
//  ScanningView.m
//  J1health
//
//  Created by zhizi on 16/3/15.
//  Copyright © 2016年 J1. All rights reserved.
//

#import "ScanningView.h"
@interface ScanningView()
@property (nonatomic, strong)UIImageView *imageSaoBJ;

@end

@implementation ScanningView

- (id)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        [self setsubviews];
    }
    return self;
}
- (void)setsubviews {
    self.backgroundColor =[UIColor clearColor];
    
    self.imageSaoBJ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    self.imageSaoBJ.image = [UIImage imageNamed:@"bg_qrcode_scan.png"];
    [self addSubview:self.imageSaoBJ];
    
    self.lineImage =[[UIImageView alloc] initWithFrame:CGRectMake(kscaleIphone5DeviceLength(50), kscaleIphone5DeviceLength(90), DeviceWidth-kscaleIphone5DeviceLength(100), 2)];
    self.lineImage.image =[UIImage imageNamed:@"smline"];
    self.lineImage.backgroundColor = [UIColor orangeColor];
    [self addSubview:self.lineImage];
    

}
- (void)hiddenSubviews:(BOOL)hidden {
    self.imageSaoBJ.hidden =hidden;
    self.lineImage.hidden =hidden;
}
- (void)bottonMyErWeiMaClicked:(UIButton *)btn{
//    if(self.blockMyErWeiMa){
//        self.blockMyErWeiMa();
//    }
}
@end

//
//  ProjectDetailVCCell.m
//  Xieshi
//
//  Created by Tesiro on 16/8/8.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import "ProjectDetailVCCell.h"

@implementation ProjectDetailVCCell
- (void)initSubviews{
    self.viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self addSubview:self.viewBG];
    
    self.imageviewHead = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 17, 17)];
    [self.viewBG addSubview:self.imageviewHead];
    
    
    self.labelShow = [[UILabel alloc] initWithFrame:CGRectMake(45, 14, DeviceWidth-60, 17)];
    self.labelShow.font = themeFont17;
    self.labelShow.textColor = [UIColor colorWithHexString:kc00_999999];
    self.labelShow.numberOfLines = 0;
    [self.viewBG addSubview:self.labelShow];
    
    self.viewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, DeviceWidth, 0.5)];
    self.viewBottomLine.backgroundColor = kcolorLine;
    [self.viewBG addSubview:self.viewBottomLine];
    
}

- (void)reloadDataForCell:(id)model{
    self.model = model;
    self.imageviewHead.image =((XSCellModel *)self.model).imagehead;
    NSString *strContent = [NSString stringWithFormat:@"%@：%@",((XSCellModel *)self.model).title,((XSCellModel *)self.model).content];
    NSRange   range = [strContent rangeOfString:((XSCellModel *)self.model).content];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:strContent];
    [attributeString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:kc00_333333]} range:NSMakeRange(range.location, range.length)];
    [self.labelShow setAttributedText:attributeString];
    CGFloat heightContent = [NSString calculateTextHeight:kscaleIphone5DeviceLength(DeviceWidth-60) Content:strContent font:themeFont17];
    heightContent = heightContent+5>26?heightContent:17;
    
    self.labelShow.frame = CGRectMake(45, 14, DeviceWidth-60, heightContent);
    self.viewBG.frame = CGRectMake(0, 0, DeviceWidth, 28+heightContent);
    self.viewBottomLine.frame = CGRectMake(0, 28+heightContent-0.5, DeviceWidth, 0.5);
    if (heightContent == 17) {
        self.imageviewHead.frame = CGRectMake(15, 14, 17, 17);
    }else {
        self.imageviewHead.frame = CGRectMake(15, 17, 17, 17);
    }
    
    if (((XSCellModel *)self.model).tagColor == YES) {
        self.viewBG.backgroundColor = [UIColor colorWithHexString:kcolorBJ_f0eff4];
    }else{
        self.viewBG.backgroundColor = [UIColor whiteColor];
    }

    
}

@end

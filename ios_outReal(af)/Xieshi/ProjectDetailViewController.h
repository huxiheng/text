//
//  ProjectDetailViewController.h
//  Xieshi
//
//  Created by Tesiro on 16/8/8.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import "XSViewController.h"

@interface ProjectDetailViewController : XSViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain) NSString *keyId;
@property(nonatomic,retain) NSString *checksum;
@property(nonatomic,retain) NSDictionary *data;

@property (nonatomic, strong)NSMutableArray  *dataArray;

@property (nonatomic, strong)UITableView    *table;

@end

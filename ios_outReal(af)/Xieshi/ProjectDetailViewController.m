//
//  ProjectDetailViewController.m
//  Xieshi
//
//  Created by Tesiro on 16/8/8.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "ProjectDetailVCCell.h"

@interface ProjectDetailViewController ()

@end

@implementation ProjectDetailViewController

- (void)setData{
    self.titleForNav = @"检测报告";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDataForVC];
    [self setSubviews];
}

- (void)setSubviews{
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64) style:UITableViewStylePlain];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    [self.table registerClass:[ProjectDetailVCCell class] forCellReuseIdentifier:[ProjectDetailVCCell cellIdentifier]];
}

- (void)setDataForVC{
    NSArray *arrayTitle = @[@"报告编号",@"报告日期",@"工程名称",@"工程地址",@"委托单位",@"建设单位",@"施工单位",@"监理单位",@"检测单位"];
    NSMutableArray  *arrayContent = [[NSMutableArray alloc] initWithObjects:self.data[@"报告编号"],self.data[@"报告日期"],self.data[@"工程名称"],self.data[@"工程地址"],self.data[@"委托单位"],self.data[@"建设单位"],self.data[@"施工单位"],self.data[@"监理单位"],self.data[@"检测单位"], nil];
    NSArray *arrayImages = @[[UIImage imageNamed:@"bianhao"],[UIImage imageNamed:@"riqi"],[UIImage imageNamed:@"mingcheng"],[UIImage imageNamed:@"dizhi"],[UIImage imageNamed:@"weituo"],[UIImage imageNamed:@"jianshe"],[UIImage imageNamed:@"shigong"],[UIImage imageNamed:@"jianli"],[UIImage imageNamed:@"jiance"]];
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<arrayTitle.count; i++) {
        XSCellModel *cellModel = [[XSCellModel alloc] init];
        cellModel.title = arrayTitle[i];
        cellModel.content = arrayContent[i];
        cellModel.imagehead = arrayImages[i];
        if (i%2==0) {
            cellModel.tagColor =YES;
        }else{
            cellModel.tagColor = NO;
        }
        [self.dataArray addObject:cellModel];
    }
    
}

#pragma mark ----UITableViewDelegate----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectDetailVCCell *cell = [tableView dequeueReusableCellWithIdentifier:[ProjectDetailVCCell cellIdentifier]];
    id model = [self.dataArray objectAtIndex:indexPath.row];
    [cell reloadDataForCell:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *strContent = [NSString stringWithFormat:@"%@：%@",((XSCellModel *)model).title,((XSCellModel *)model).content];
    CGFloat heightContent = [NSString calculateTextHeight:kscaleIphone5DeviceLength(DeviceWidth-60) Content:strContent font:themeFont17];
    heightContent = heightContent+5>26?heightContent:17;
    
    return 28+heightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

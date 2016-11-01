//
//  ReportCheckViewController.m
//  Xieshi
//
//  Created by Tesiro on 16/7/13.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import "ReportCheckViewController.h"
#import "ReportCheckTabelCell.h"
#import "ReportCheckHeaderView.h"
#import "SampleListViewController.h"
#import "SampleInfoViewController.h"
#import "NSObject+SBJSON.h"


@interface ReportCheckViewController ()
@property (nonatomic, strong)UITableView     *table;
@property (nonatomic, strong)ReportCheckHeaderView  *reportCheckHeadView;
@property(nonatomic,retain) NSArray *list;


@end

@implementation ReportCheckViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self.view viewWithTag:1001] removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, DeviceWidth, DeviceHeight)];
    imageView.image = [UIImage imageWithScreenContents:self.navigationController.view];
    imageView.tag = 1001;
    imageView.userInteractionEnabled =YES;
    [self.view addSubview:imageView];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[self.view viewWithTag:1001] removeFromSuperview];
}

- (void)setData {
    self.titleForNav = @"检测报告";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nextpagevc];
    
    [self setSubViews];
    
    NSArray *arrayTitle = @[@"报告编号",@"委托编号",@"检测类别",@"委托单位",@"检测工程名称",@"工程地址",@"施工单位",@"见证单位",@"委托日期",@"报告日期",@"检测机构名称"];
    NSMutableArray *arrayContent = [NSMutableArray arrayWithObjects:_dataDic[@"Report_ID"],_dataDic[@"ConSign_ID"],_dataDic[@"Exam_Kind"],_dataDic[@"EntrustUnitName"],_dataDic[@"ProJectName"],_dataDic[@"ProjectAddress"],_dataDic[@"BuildUnitName"],_dataDic[@"SuperviseUnitName"],[NSString  returnDateStr:_dataDic[@"DetectonDate"]],[NSString returnDateStr:_dataDic[@"Report_CreateTime"]],_dataDic[@"MemberName"], nil];
//    NSArray *arrayContent =@[_dataDic[@"Report_ID"],_dataDic[@"ConSign_ID"],_dataDic[@"Exam_Kind"],_dataDic[@"Project_SSN"],_dataDic[@"EntrustUnitName"],_dataDic[@"ProJectName"],_dataDic[@"IdentifyingCode"],_dataDic[@"ProjectAddress"],_dataDic[@"BuildUnitName"],_dataDic[@"SuperviseUnitName"],_dataDic[@"Sampling"],_dataDic[@"Witness"],_dataDic[@"DetectonDate"],_dataDic[@"Report_CreateTime"],_dataDic[@"MemberName"],_dataDic[@"CotactAddress"]];
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<arrayTitle.count; i++) {
        XSCellModel *cellModel = [[XSCellModel alloc] init];
        cellModel.title = arrayTitle[i];
        cellModel.content = arrayContent[i];
//         CGFloat contentWidth = DeviceWidth-kscaleDeviceLength(36);
//        CGSize constraint = CGSizeMake(contentWidth, 20000.0f);
//        CGSize size1 = [arrayContent[i] sizeWithFont:themeFont16 constrainedToSize:constraint];
//        CGFloat heightContent = ceil(size1.height);
        cellModel.heightcontent=[NSString calculateTextHeight:DeviceWidth-kscaleDeviceLength(36) Content:arrayContent[i] font:themeFont16];
        if (i%2==0) {
            cellModel.tagColor = YES;
        }else {
            cellModel.tagColor = NO;
        }
        [self.dataArray addObject:cellModel];
    }
    
    ///根据内容适应行高
    self.heightArray = [NSMutableArray array];
    for (NSString *string in arrayContent) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [self returndicWithHeight:string];
        [self.heightArray addObject:dic];
    }
}

- (NSMutableDictionary *)returndicWithHeight:(NSString *)str{
    CGFloat cellHeight =0;
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    CGFloat contentWidth = DeviceWidth-kscaleDeviceLength(36);
    CGSize constraint = CGSizeMake(contentWidth, 20000.0f);
    CGSize size1 = [str sizeWithFont:themeFont16 constrainedToSize:constraint];
    CGFloat heightContent = ceil(size1.height);
    if (heightContent>25) {
        dic2[@"height"]=@"74";
    }else{
        dic2[@"height"]=@"50";
    }
    return dic2;
}

- (void)setSubViews{
    self.view.backgroundColor = [UIColor colorWithHexString:kcolorBJ_f0eff4];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64) style:UITableViewStylePlain];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.backgroundColor = [UIColor colorWithHexString:kcolorBJ_f0eff4];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    self.reportCheckHeadView = [[ReportCheckHeaderView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 65)];
    self.table.tableHeaderView = self.reportCheckHeadView;
   
   
    
    [self.table registerClass:[ReportCheckTabelCell class] forCellReuseIdentifier:[ReportCheckTabelCell cellIdentifier]];
}

#pragma  mark 下一级页面为1个样品，直接跳转到2级样品详情页
- (void)nextpagevc{
    NSDictionary *params = @{
                             @"Report_id":_keyId,
                             @"Checksum":_checksum
                             };
    apiConnectionAsyncWithIndicator(AFNETMETHOD_SAMPLE_LIST, JSON_PARAM( params ), ^NSString *(NSDictionary* result){
        _list = result[kAFNETConnectionStandartDataKey];
        
        
            
            self.reportCheckHeadView.blockClickBG = ^(){
                if (_list.count==1) {
                    NSDictionary *datadic = _list[0];
                    
                    SampleInfoViewController *controller = [[SampleInfoViewController alloc]init];
                    controller.reportId = _keyId;
                    controller.checksum = _checksum;
                    controller.countsample = _list.count;
                    controller.sampleId = datadic[@"Sample_Id"];
                    [self.navigationController pushViewController:controller animated:YES];
                }else{
                    SampleListViewController *controller = [[SampleListViewController alloc]init];
                    controller.keyId = _keyId;
                    controller.checksum = _checksum;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            };
        

        return nil;
    });
  
}

#pragma mark ----UITableViewDelegate-----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportCheckTabelCell *cell = [tableView dequeueReusableCellWithIdentifier:[ReportCheckTabelCell cellIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XSCellModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell reloadDataForCell:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [((NSDictionary *)[self.heightArray objectAtIndex:indexPath.row])[@"height"] intValue];
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

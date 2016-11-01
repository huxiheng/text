//
//  LSVerySimpleGrideViewController.m
//  Yingcheng
//
//  Created by lessu on 14-1-3.
//  Copyright (c) 2014年 Lessu. All rights reserved.
//

#import "LSPagedGrideViewController.h"

@interface LSPagedGrideViewController ()

@end

@implementation LSPagedGrideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpPageController];
    _gridView.delegate   = self;
    _gridView.dataSource = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_pageController refresh];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];

    _listView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    _listView.contentOffset = CGPointMake(0, -60);
    
    [UIView commitAnimations];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_pageController cancelLoading];
    [_pageController cancelRefreashing];
}
- (void)setUpPageController{
    NSDictionary * params = nil;
    NSString     * apiName= nil;
    [self toInitPageControllerWith:&apiName params:&params];
    _pageController = [[LSPageController alloc]initWithApiName:apiName andParams:params];
    __block LSPageController *bPageController = _pageController;
    __block typeof(self) bSelf = self;
    [_pageController setOnRefreashSuccessBlock:^(NSArray *mergedList,NSDictionary *result) {
        [bSelf.gridView reloadData];
        [bSelf setHasMore:bPageController.hasMore];
        [bSelf finishRefreash];
    }];
    [_pageController setOnRefreashFailedBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        [bSelf finishRefreash];
    }];
    [_pageController setOnNextSuccessBlock:^(NSArray *mergedList,NSDictionary *result) {
        [bSelf.gridView reloadData];
        [bSelf setHasMore:bPageController.hasMore];
        [bSelf finishLoading];
    }];
    [_pageController setOnNextFailedBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        [bSelf finishLoading];
    }];
    [self afterInitPageController:_pageController];
}
#pragma mark -
#pragma mark LSRefreashAndLoadMoreViewController
- (void)lsViewControllerShouldRefreash:(LSRefreashAndLoadMoreGrideViewController *)viewController{
    [_pageController refreshNoMerge];
}
- (void)lsViewControllerShouldLoadMore:(LSRefreashAndLoadMoreGrideViewController *)viewController{
    [_pageController nextPage];
}

#pragma mark grid view delegate
- (NSInteger)numberOfSectionsInGridView:(NRGridView *)gridView{
    _cellNibName = [self simpleGridViewViewCellNibName:gridView];
    return 1;
}

- (NSInteger)gridView:(NRGridView *)gridView numberOfItemsInSection:(NSInteger)section{
    return _pageController.list.count;
}
- (NRGridViewCell *)gridView:(NRGridView *)gridView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    NRGridViewCell *cell = [gridView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == NULL) {
        cell = [[NSBundle mainBundle] loadNibNamed:_cellNibName owner:self options:nil][0];
    }
    NSDictionary *item = _pageController.list[indexPath.row];
    [self simpleGridView:gridView fillCell:cell withData:item andIndexPath:indexPath];
    return cell;
}
- (void)gridView:(NRGridView *)gridView didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = _pageController.list[indexPath.row];
    [self simpleGridView:gridView didSelectedWithData:item andIndexPath:indexPath];
}

#pragma mark to Implement
- (void)toInitPageControllerWith:(NSString **) apiName params:(NSDictionary **)params{
    *apiName = nil;
    *params  = nil;
    NSAssert(false, @"please override it");
}
- (void)afterInitPageController:(LSPageController *)pageController{
    
}
- (void)simpleGridView:(NRGridView *)tableView fillCell:(id)cell withData:(NSDictionary *)item{
    //    NSAssert(false, @"please override it");
}

@end

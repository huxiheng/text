//
//  LSFormTableViewController.h
//  YinfengShop
//
//  Created by lessu on 13-12-23.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSFormCell.h"
@class LSFormCell;
@protocol LSFormTableViewControllerDelegate;

@interface LSFormTableViewController : UITableViewController<LSFormCellDelegate>
{
    NSDictionary* _formData;
    NSArray*      _formMapper;
}
@property(nonatomic,strong) NSDictionary* formData;

@property(nonatomic,strong) NSArray*      formMapper;

@property(nonatomic,assign) id<LSFormTableViewControllerDelegate> delegate;

@property(nonatomic,readonly) NSMutableDictionary *cellsDict;

- (instancetype)initWithMapper:(NSArray *)mapper;

@end


NSDictionary* formTableViewFormMapper(NSArray *mapper);
NSDictionary* formTableViewFormMapperWithHead(NSString *header,NSArray *mapper);
NSDictionary* formTableViewFormMapperWithHeadAndFoot(NSString *header,NSString *footer,NSArray *mapper);

@protocol LSFormTableViewControllerDelegate <NSObject>
@optional
- (BOOL)formTableView:(LSFormTableViewController*)viewController shouldCallCellMethodWithCell:(LSFormCell *)cell;
- (void)formTableView:(LSFormTableViewController*)viewController didSelectedWithCell:(LSFormCell *)cell;

//and will call
//- [CellName]DidSelected:(LSFormCell *)cell;
//cellName is in CamelCase which first letter is lowercased;

- (void)formTableView:(LSFormTableViewController *)viewController cellValueChanged:(LSFormCell *)cell;
//and will call
//- [CellName]ValueChanged:(LSFormCell *)cell;
//cellName is in CamelCase which first letter is lowercased;

@end
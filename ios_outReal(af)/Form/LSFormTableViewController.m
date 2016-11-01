//
//  LSFormTableViewController.m
//  YinfengShop
//
//  Created by lessu on 13-12-23.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import "LSFormTableViewController.h"
#import "LSFormCell.h"
#import <objc/message.h>
NSString* LSFormTableMapperFormHeaderKey    = @"LSFormTableMapperFormHeaderKey";
NSString* LSFormTableMapperFormCellKey      = @"LSFormTableMapperFormCellKey";
NSString* LSFormTableMapperFormFooterKey    = @"LSFormTableMapperFormFooterKey";

NSString* LSFormTableMapperCellClassKey     = @"LSFormTableMapperCellClassKey";
NSString* LSFormTableMapperCellNameKey      = @"LSFormTableMapperCellNameKey";
NSString* LSFormTableMapperCellKeyNameKey   = @"LSFormTableMapperCellKeyNameKey";
NSString* LSFormTableMapperCellLabelKey     = @"LSFormTableMapperCellLabelKey";
NSString* LSFormTableMapperCellValueKey     = @"LSFormTableMapperCellValueKey";
NSString* LSFormTableMapperCellRuleKey      = @"LSFormTableMapperCellRuleKey";

NSDictionary* formTableViewFormMapper(NSArray *mapper){
    return formTableViewFormMapperWithHeadAndFoot(nil,nil,mapper);

}

NSDictionary* formTableViewFormMapperWithHead(NSString *header,NSArray *mapper){
    return formTableViewFormMapperWithHeadAndFoot(header,nil,mapper);
}

NSDictionary* formTableViewFormMapperWithHeadAndFoot(NSString *header,NSString *footer,NSArray *mapper){
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    if (header) {
        ret[LSFormTableMapperFormHeaderKey] = header;
    }
    if (footer) {
        ret[LSFormTableMapperFormFooterKey] = footer;
    }
    if (mapper) {
        ret[LSFormTableMapperFormCellKey] = mapper;
    }
    return ret;
}

@interface NSString (CamelCase)

- (NSString *)camelCaseString;

@end



@interface LSFormTableViewController ()
@property(nonatomic,readonly) NSMutableArray *cells;
@end

@implementation LSFormTableViewController

- (instancetype)initWithMapper:(NSArray *)mapper{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.formMapper = mapper;
        _formData = @{};
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFormMapper:(NSArray *)formMapper{
    if(![NSThread isMainThread]){
        [self performSelectorOnMainThread:@selector(setFormMapper) withObject:formMapper waitUntilDone:YES];
        return;
    }
    _formMapper = formMapper;
    _cells = [NSMutableArray array];
    _cellsDict=[NSMutableDictionary dictionary];
    [formMapper enumerateObjectsUsingBlock:^(NSDictionary* formSection, NSUInteger idx, BOOL *stop) {
        if (IS_ARRAY(formSection[LSFormTableMapperFormCellKey])) {
            NSArray *formSectionCells = formSection[LSFormTableMapperFormCellKey];
            [formSectionCells enumerateObjectsUsingBlock:^(NSDictionary* cellMapper, NSUInteger idx, BOOL *stop) {
                NSString *className = STRING_FORMAT(@"LSForm%@Cell",cellMapper[LSFormTableMapperCellClassKey]);
                NSString *cellName  = STRING_EMPTY_IF_NOT(cellMapper[LSFormTableMapperCellNameKey]);
                LSFormCell *cell = [(LSFormCell *)[NSClassFromString(className) alloc]initWithMapper:cellMapper];
                NSAssert(cell, @"cell 初始化失败 %@",className);
                cell.delegate = self;

                [_cells addObject:cell];
                NSAssert(_cellsDict[cellName] == NULL, @"cell name 重名了");
                _cellsDict[cellName] = cell;

            }];
        }
    }];
}
- (void)setFormData:(NSDictionary *)formData{
    _formData = formData;
    [_formMapper enumerateObjectsUsingBlock:^(NSDictionary* formSection, NSUInteger idx, BOOL *stop) {
        if (IS_ARRAY(formSection[LSFormTableMapperFormCellKey])) {
            NSArray *formSectionCells = formSection[LSFormTableMapperFormCellKey];
            [formSectionCells enumerateObjectsUsingBlock:^(NSDictionary* cellMapper, NSUInteger idx, BOOL *stop) {
                NSString *cellName  = STRING_EMPTY_IF_NOT(cellMapper[LSFormTableMapperCellNameKey]);
                NSString *cellKey   = cellMapper[LSFormTableMapperCellKeyNameKey];
                if(cellKey){
                    LSFormCell *cell = _cellsDict[cellName];
                    cell.data = formData[cellKey];
                }
            }];
        }
    }];
    [self.tableView reloadData];
}
#pragma -mark UITableViewDelegate / UITableViewDataSource
//Section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return _formMapper.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return ARRAY_CAST(_formMapper[section][LSFormTableMapperFormCellKey]) .count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return _formMapper[section][LSFormTableMapperFormHeaderKey];
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	return _formMapper[section][LSFormTableMapperFormFooterKey];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *sectionMapper = _formMapper[indexPath.section];
    NSDictionary *item  = sectionMapper[LSFormTableMapperFormCellKey][indexPath.row];
    
    LSFormCell *cell = _cellsDict[ item[LSFormTableMapperCellNameKey] ];
    
//    id data = _formData[item[LSFormTableMapperCellKeyNameKey]];
    
    CGFloat height = [cell cellHeight];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *sectionMapper = _formMapper[indexPath.section];
    NSDictionary *item  = sectionMapper[LSFormTableMapperFormCellKey][indexPath.row];
    LSFormCell *cell = _cellsDict[item[LSFormTableMapperCellNameKey]];
	return cell;
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *sectionMapper = _formMapper[indexPath.section];
    NSDictionary *item  = sectionMapper[LSFormTableMapperFormCellKey][indexPath.row];
    
    LSFormCell *cell = _cellsDict[item[LSFormTableMapperCellNameKey]];
    
    [self.cellsDict enumerateKeysAndObjectsUsingBlock:^(id key, LSFormCell* enumCell, BOOL *stop) {
        if (cell != enumCell ) {
            [enumCell resignFirstResponder];
        }
    }];
    
    BOOL shouldCall = true;

    if ([_delegate respondsToSelector:@selector(formTableView:shouldCallCellMethodWithCell:)]) {
        shouldCall = [_delegate formTableView:self shouldCallCellMethodWithCell:cell];
    }
    
    if (shouldCall) {
        [cell onSelected:self complete:^{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    }
    
    if ([_delegate respondsToSelector:@selector(formTableView:didSelectedWithCell:)]) {
        [_delegate formTableView:self didSelectedWithCell:cell];
    }
    SEL selector = NSSelectorFromString(STRING_FORMAT(@"%@DidSelected:",[cell.cellName camelCaseString]));
    if ([_delegate respondsToSelector:selector]) {
        id (*response)(id, SEL, id) = (id (*)(id, SEL, id)) objc_msgSend;
        response(self, selector, cell);
    }


}






- (NSDictionary *)formData{
    NSMutableDictionary *retData = [_formData mutableCopy];
    if (retData == nil) {
        retData = [NSMutableDictionary dictionary];
    }
    [_formMapper enumerateObjectsUsingBlock:^(NSDictionary* formSection, NSUInteger idx, BOOL *stop) {
        if (IS_ARRAY(formSection[LSFormTableMapperFormCellKey])) {
            NSArray *formSectionCells = formSection[LSFormTableMapperFormCellKey];
            [formSectionCells enumerateObjectsUsingBlock:^(NSDictionary* cellMapper, NSUInteger idx, BOOL *stop) {
                NSString *cellName  = STRING_EMPTY_IF_NOT(cellMapper[LSFormTableMapperCellNameKey]);
                LSFormCell *cell = _cellsDict[cellName];
                [cell resignFirstResponder];
                NSString *cellKey   = cellMapper[LSFormTableMapperCellKeyNameKey];

                id data = cell.data;
                if (data) {
                    retData[cellKey]    = cell.data;
                }
            }];
        }
    }];
    return retData;
}


#pragma mark LSFormCellDelegate
- (void)cell:(LSFormCell *)cell valuedChanged:(id)value{
    if ([_delegate respondsToSelector:@selector(formTableView:cellValueChanged:)]) {
        [_delegate formTableView:self cellValueChanged:cell];
    }
    SEL selector = NSSelectorFromString(STRING_FORMAT(@"%@ValueChanged:",[cell.cellName camelCaseString]));
    if ([_delegate respondsToSelector:selector]) {
//        objc_msgSend(_delegate, selector,cell);
        id (*response)(id, SEL, id) = (id (*)(id, SEL, id)) objc_msgSend;
        response(self, selector, cell);
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)cell:(LSFormCell *)cell heightChanged:(CGFloat)height{
    [self.tableView reloadData];
}
@end






@implementation NSString (CamelCase)

- (NSString *)camelCaseString{
    NSArray *stringArray = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableString *retString = [NSMutableString string];
    [stringArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [retString appendString:[NSString stringWithFormat:@"%@%@",[[obj substringWithRange:NSMakeRange(0, 1)] lowercaseString],[obj substringFromIndex:1]]];
        }else{
            [retString appendString:[obj capitalizedString]];
        }
    }];
    return retString;
}
@end



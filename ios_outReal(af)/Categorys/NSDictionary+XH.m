//
//  NSDictionary+XH.m
//  Xieshi
//
//  Created by Tesiro on 16/10/31.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import "NSDictionary+XH.h"

@implementation NSDictionary (XH)
+(NSDictionary*)returnDictoryParams:(NSDictionary *)params{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"param":jsonString};
    return dic;
}
@end

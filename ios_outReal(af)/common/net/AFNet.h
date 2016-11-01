//
//  AFNet.h
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetConnection.h"
#import "AFMethod.h"
#import "NSString+SBJSON.h"
#import "AFNetConnection+Cache.h"
#import "SOAPConnection.h"

#define AFNETSiteUrlKey  @"siteUrl"
#define AFNETHTTPMethodKey @"http"
#define AFNETResultFormatKey @"responseFormat"

@interface AFNet : NSObject{
//    NSDictionary *_afnetConfig;
//    NSDictionary *_afnetMethod;
}
- (id)init;
+ (AFNet *)sharedInstance;
- (AFNetConnection *)connectionWithApiName:(NSString *) apiName params:(NSDictionary *)params;

@end

#define AFNET_DEF_GET(url) @{AFNET_URL: url}
#define AFNET_DEF_POST(url) @{AFNET_URL: url,AFNET_CONNECT_METHOD : AFNET_CONNECT_METHOD_POST}
#define AFNET_DEF_SOAP(action)          @{AFNET_SOAP_ACTION:action , AFNET_CONNECT_METHOD : @"SOAP"}

#define AFNETMETHOD_REPORT_DETAIL            @"AFNETMETHOD_REPORT_DETAIL"
#define AFNETMETHOD_SAMPLE_LIST              @"AFNETMETHOD_SAMPLE_LIST"
#define AFNETMETHOD_SAMPLE_DETAIL            @"AFNETMETHOD_SAMPLE_DETAIL"

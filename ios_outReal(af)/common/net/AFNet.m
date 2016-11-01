//
//  AFNet.m
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFNet.h"

static NSDictionary *afnetConfig;
static NSDictionary *afnetMethod;

NSString const * AFNETPreprocessKey    = @"preprocess";

NSString const * AFNETSoapUrlKey       = @"soapUrl";

static NSString * serverUrl = @"www.scetia.com/";
@implementation AFNet
static AFNet *shareObject;
+ (AFNet *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[AFNet alloc] init];
    });
    return shareObject;
}

+(NSDictionary *)afnetConfig{
    return afnetConfig;
}

- (id)init{
    self = [super init];
    if (self) {
        afnetConfig = @{
                      AFNETSiteUrlKey           : @"www.scetia.com/scetia.app.ws/ServiceSRQ.asmx",
                      AFNETHTTPMethodKey        : @"http",
                      AFNETSoapUrlKey           : @"http://www.scetia.com/scetia.app.ws"
                      
                      };
        
        afnetMethod = @{
                      
                      AFNETMETHOD_REPORT_DETAIL   : AFNET_DEF_SOAP(@"ProjectConsign"),
                      AFNETMETHOD_SAMPLE_LIST     : AFNET_DEF_SOAP (@"SampleList"),
                      AFNETMETHOD_SAMPLE_DETAIL   : AFNET_DEF_SOAP (@"SampleDetail")
                      };
//        [afnetConfig retain];
//        [afnetMethod retain];
    }
    return self;
}

- (void)setServerUrl:(NSString *)serverUrl{
    afnetConfig = [afnetConfig mutableCopy];
    ((NSMutableDictionary *)afnetConfig)[AFNETSiteUrlKey] = [NSString stringWithFormat:@"%@/scetia.app.ws/ServiceUST.asmx",serverUrl];
}

- (AFNetConnection *)connectionWithApiName:(NSString *) apiName params:(NSDictionary *)params{
    //@{AFNET_SOAP_ACTION:action , AFNET_CONNECT_METHOD : @"SOAP"}
    
    NSDictionary *apiOptions = afnetMethod[apiName];//获取方法名的字典
    NSAssert(DICTIONARY_NOT_EMPTY(apiOptions), @"can't find method");
    AFNetConnection *connection;
    if ([apiOptions[AFNET_CONNECT_METHOD] isEqualToString:AFNET_CONNECT_METHOD_SOAP]) {
        NSString *requestUrl= [NSString stringWithFormat:@"%@://%@" ,afnetConfig[AFNETHTTPMethodKey], afnetConfig[AFNETSiteUrlKey]];
        requestUrl= [NSString stringWithFormat:@"%@/%@",requestUrl,apiOptions[AFNET_SOAP_ACTION]];
        SOAPConnection *sconnection = [[SOAPConnection alloc]initWithConnectionUrlString:requestUrl];
        sconnection.soapActionUrl = afnetConfig[AFNETSoapUrlKey];
        sconnection.soapAction    = apiOptions[AFNET_SOAP_ACTION];
        connection = sconnection;
    }else{
        NSString *requestUrl = [self getUrlStringByApiName:apiName];
        connection = [[AFNetConnection alloc] initWithConnectionUrlString:requestUrl ];
    }
    [connection setResultType:kAFNetConnectionTypeJSON];
    if (STRING_NOT_EMPTY(apiOptions[AFNET_CACHE_ENABLE])&&[apiOptions[AFNET_CACHE_ENABLE] boolValue]) {
        [connection enableCache];
//        [connection setCachePolicy:[apiOptions[AFNET_CACHE] integerValue]];
//        [connection setSecondsToCache:15*60];
    }else{
        [connection disableCache];
    }
    
    if (afnetConfig[AFNETResultFormatKey]) {
        [connection setResponseFormat:afnetConfig[AFNETResultFormatKey]];
    }
    if (STRING_NOT_EMPTY(apiOptions[AFNET_CONNECT_METHOD])) {
        connection.requestMethod = kAFNetConnectionRequestTypePost;
    }else{
        connection.requestMethod = kAFNetConnectionRequestTypeGet;
    }
    if (apiOptions[AFNET_RESULT_TYPE]) {
        [connection setResultType:[apiOptions[AFNET_RESULT_TYPE] intValue]];
    }else{
       [connection setResultType:kAFNetConnectionTypeStandart];
    }
    connection.params = params;
    
    return connection;
}

///根据方法名获取请求网络的url
-(NSString*)getUrlStringByApiName:(NSString *)apiname{
    NSDictionary *apiOptions = afnetMethod[apiname];
    NSString *requestUrl = apiOptions[AFNET_URL];
    return [NSString stringWithFormat:@"%@://%@%@",afnetConfig[AFNETHTTPMethodKey],afnetConfig[AFNETSiteUrlKey],requestUrl];
}
@end

//
//  TemplatedWebViewController.m
//  Xieshi
//
//  Created by 明溢 李 on 14-11-18.
//  Copyright (c) 2014年 Lessu. All rights reserved.
//

#import "TemplatedWebViewController.h"
#import "RegexKitLite.h"
@interface TemplatedWebViewController ()

@end

@implementation TemplatedWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _eventPrefix = @"app://";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setWebView:(UIWebView *)webView{
    _webView = webView;
    _webView.delegate = self;
    _webView.opaque=false;
    webView.detectsPhoneNumbers=NO;
}
- (void)loadHTMLString:(NSString *)string baseURL:(NSString *)baseURLString data:(id)data{
    baseURLString = [baseURLString stringByAppendingString:@"/"];
    string = [string stringByReplacingOccurrencesOfRegex:@"\\$\\{([^}]*)\\}" usingBlock:^NSString *(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        @try {
            return [self templatedWebViewController:self replaceTemplateText:capturedStrings[1] withData:data];
        }
        @catch (NSException *exception) {
            return nil;            
        }
        
    }];
    [_webView loadHTMLString:string baseURL:[NSURL URLWithString:baseURLString]];
}

- (NSString *)templatedWebViewController:(TemplatedWebViewController*) viewController replaceTemplateText:(NSString *) text withData:(id)data{
    return text;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = [request.URL absoluteString];

    if ([url hasPrefix:_eventPrefix]) {
        url = [url stringByReplacingOccurrencesOfString:_eventPrefix withString:@""];
        NSArray *stringComponents = [url componentsSeparatedByString:@"?"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (stringComponents.count == 2) {
            NSArray *keyValues = [stringComponents[1] componentsSeparatedByString:@"&"];
            [keyValues enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
                NSArray *item = [obj componentsSeparatedByString:@"="];
                params[item[0]]=item[1];
            }];
        }

        return [self templatedWebViewController:self sendEvent:stringComponents[0] withParams:params];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];  
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];  
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
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

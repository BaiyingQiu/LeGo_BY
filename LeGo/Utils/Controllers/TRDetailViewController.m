//
//  TRDetailViewController.m
//  LeGo
//
//  Created by Tarena on 16/6/1.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRDetailViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"

@interface TRDetailViewController () <WKNavigationDelegate>

@property (nonatomic, copy)NSString *dealUrl;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation TRDetailViewController
- (instancetype)initWithDealUrl:(NSString *)dealUrl {
    if (self = [super init]) {
        self.dealUrl = dealUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.navigationItem.title = @"订单详情";
//    UIBarButtonItem *backItem = []
    
    //创建 web 页面
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.dealUrl]];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height + 50)];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    [webView loadRequest:request];
}
//开始加载
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
//加载成功
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"加载失败%@",error.userInfo);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

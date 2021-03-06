//
//  JCWebViewController.m
//  JCWebViewController
//
//  Created by mzy on 16/10/19.
//  Copyright © 2016年 jcdroid. All rights reserved.
//

#import "JCWebViewController.h"
#import "JCNavigationControllerShouldPopProtocol.h"

@interface JCWebViewController () <UIWebViewDelegate, JCNavigationControllerShouldPopProtocol>

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) NSURLRequest *request;

@property (strong, nonatomic) UIBarButtonItem *closeItem;

@end

@implementation JCWebViewController

#pragma mark - Initialization

- (void)dealloc {
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.webView.delegate = nil;
    self.delegate = nil;
}

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)loadRequest:(NSURLRequest*)request {
    [self.webView loadRequest:request];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view  = self.webView;
    [self loadRequest:self.request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

#pragma mark - JCNavigationControllerShouldPopProtocol

- (BOOL)navigationControllerShouldPopWhenBackBtnSelected:(UINavigationController *)navigationController {
    if (self.webView.canGoBack) {
        [self.webView goBack];
        [self.navigationItem setHidesBackButton:YES];
        [self.navigationItem setHidesBackButton:NO];
        
        if (self.webView.canGoBack) {
            self.navigationItem.leftItemsSupplementBackButton = YES;
            self.navigationItem.leftBarButtonItem = self.closeItem;
        } else {
            self.navigationItem.leftBarButtonItem = nil;
        }
        
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Target actions

- (void)goBackTapped:(UIBarButtonItem *)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeWebVC:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters && setters

- (UIWebView *)webView {
    if(!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (UIBarButtonItem *)closeItem {
    if(!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeWebVC:)];
    }
    return _closeItem;
}

@end

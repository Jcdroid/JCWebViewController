//
//  JCWebViewController.m
//  JCWebViewController
//
//  Created by mzy on 16/10/19.
//  Copyright © 2016年 jcdroid. All rights reserved.
//

#import "JCWebViewController.h"
#import "JCNavigationControllerShouldPopProtocol.h"
#import "UIView+JCAdd.m"

@interface JCWebViewController () <UIWebViewDelegate, JCNavigationControllerShouldPopProtocol>

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) NSURLRequest *request;

@property (strong, nonatomic) UIBarButtonItem *closeItem;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

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

- (instancetype)initWithURL:(NSURL *)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)loadRequest:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = self.contentView;
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.webView];
    [self loadRequest:self.request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView addGestureRecognizer:self.panGesture];
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

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = !self.webView.canGoBack;
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [panGesture locationInView:self.view];
        CGPoint translation = [panGesture translationInView:self.view];
        NSLog(@"location = %@\ntranslation = %@", NSStringFromCGPoint(location), NSStringFromCGPoint(translation));
        
        if (translation.x > 0) {
            CGPoint currentCenter = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
            currentCenter.x += translation.x;
            self.webView.center = currentCenter;
        }
    }
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

- (UIView *)contentView {
    if(!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}

- (UIPanGestureRecognizer *)panGesture {
    if(!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return _panGesture;
}

@end

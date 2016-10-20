//
//  JCWebViewController.h
//  JCWebViewController
//
//  Created by mzy on 16/10/19.
//  Copyright © 2016年 jcdroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCWebViewController : UIViewController

@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, strong, readonly) NSURLRequest *request;

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

@property (nonatomic, weak) id<UIWebViewDelegate> delegate;

@end

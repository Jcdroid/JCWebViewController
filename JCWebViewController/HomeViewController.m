//
//  HomeViewController.m
//  JCWebViewController
//
//  Created by mzy on 16/10/19.
//  Copyright © 2016年 jcdroid. All rights reserved.
//

#import "HomeViewController.h"
#import "JCWebViewController.h"

@interface ContainerViewController : UIViewController

@end

@implementation ContainerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"标题";
    }
    return self;
}

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(goToWeb:)];
}

- (void)goToWeb:(UIBarButtonItem *)item {
    JCWebViewController *vc = [[JCWebViewController alloc] initWithAddress:@"https://www.baidu.com"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end


@interface HomeViewController ()

@end

@implementation HomeViewController

- (instancetype)init {
    ContainerViewController *vc = [ContainerViewController new];
    self = [super initWithRootViewController:vc];
    if (self) {
        self.title = @"主页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end

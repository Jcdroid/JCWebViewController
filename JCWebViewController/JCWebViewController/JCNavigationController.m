//
//  JCNavigationController.m
//  JCWebViewController
//
//  Created by mzy on 16/10/20.
//  Copyright © 2016年 jcdroid. All rights reserved.
//

#import "JCNavigationController.h"
#import "JCNavigationControllerShouldPopProtocol.h"


@interface UINavigationController (UINavigationControllerNeedshouldPopItem)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wincomplete-implementation"
@implementation UINavigationController (UINavigationControllerNeedshouldPopItem)
@end
#pragma clang diagnostic pop


@interface JCNavigationController () <UINavigationBarDelegate>

@end

@implementation JCNavigationController

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    UIViewController *vc = self.topViewController;
    
    if (item != vc.navigationItem) {
        return [super navigationBar:navigationBar shouldPopItem:item];
    }
    
    if ([vc conformsToProtocol:@protocol(JCNavigationControllerShouldPopProtocol)]) {
        if ([(id<JCNavigationControllerShouldPopProtocol>)vc navigationControllerShouldPopWhenBackBtnSelected:self]) {
            return [super navigationBar:navigationBar shouldPopItem:item];
        } else {
            return NO;
        }
    }
    
    return [super navigationBar:navigationBar shouldPopItem:item];
}

@end

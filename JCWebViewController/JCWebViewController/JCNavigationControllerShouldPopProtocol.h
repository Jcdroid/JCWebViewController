//
//  JCNavigationControllerShouldPopProtocol.h
//  JCWebViewController
//
//  Created by mzy on 16/10/19.
//  Copyright © 2016年 jcdroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JCNavigationControllerShouldPopProtocol <NSObject>

- (BOOL)navigationControllerShouldPopWhenBackBtnSelected:(UINavigationController *)navigationController;

@end

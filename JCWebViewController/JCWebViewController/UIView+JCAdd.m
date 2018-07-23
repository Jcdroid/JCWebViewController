//
//  UIView+JCAdd.m
//  JCWebViewController
//
//  Created by mzy on 16/11/18.
//  Copyright © 2016年 jcdroid. All rights reserved.
//

#import "UIView+JCAdd.h"

@implementation UIView (JCAdd)

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

@end

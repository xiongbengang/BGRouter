//
//  UIViewController+ABKTopMost.m
//  BGRouter
//
//  Created by Bengang on 2018/4/12.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "UIViewController+ABKTopMost.h"

@implementation UIViewController (ABKTopMost)

+ (UIViewController *)abk_topMostViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            topViewController = [(UITabBarController *)topViewController selectedViewController];
        } else {
            break;
        }
    }
    return topViewController;
}

@end

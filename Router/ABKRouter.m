//
//  ABKRouter.m
//  BGRouter
//
//  Created by Bengang on 2018/4/12.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "ABKRouter.h"
#import "NSDictionary+ABKRouter.h"
#import "UIViewController+ABKTopMost.h"

@interface ABKRouter ()

@property (nonatomic, strong) NSSet<NSString *> *availableSchemes;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *viewControllersMapper;

@end

@implementation ABKRouter

+ (instancetype)router
{
    static ABKRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[ABKRouter alloc] init];
    });
    return router;
}

- (void)configWithSchemes:(NSArray<NSString *> *)schemes
{
    self.availableSchemes = [NSSet setWithArray:schemes];
}

- (NSString *)moduleNameForURLString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *moduleName = url.relativePath;
    if ([moduleName hasPrefix:@"/"]) {
        moduleName = [moduleName substringFromIndex:1];
    }
    return moduleName;
}

- (void)registViewController:(Class)viewControllerClass forURLString:(NSString *)urlString
{
    NSString *moduleName = [self moduleNameForURLString:urlString];
    [self registViewController:viewControllerClass forPath:moduleName];
}

- (void)registViewController:(Class)viewControllerClass forPath:(NSString *)path
{
    NSParameterAssert(path);
    NSParameterAssert(viewControllerClass);
    if (!self.viewControllersMapper) {
        self.viewControllersMapper = [NSMutableDictionary dictionary];
    }
    [self.viewControllersMapper setObject:viewControllerClass forKey:path];
}

- (void)openURLString:(NSString *)urlString
{
    [self openURLString:urlString baseViewController:nil];
}

- (void)openURLString:(NSString *)urlString baseViewController:(UIViewController *)baseViewController
{
    [self openURLString:urlString baseViewController:baseViewController parameters:nil invokeType:ABKRouterInvokeTypeAuto];
}

- (void)openURLString:(NSString *)urlString baseViewController:(UIViewController *)baseViewController parameters:(NSDictionary *)parameters invokeType:(ABKRouterInvokeType)invokeType
{
    [self openURLString:urlString baseViewController:baseViewController parameters:parameters invokeType:invokeType animated:YES complete:nil];
}

- (void)openURLString:(NSString *)urlString baseViewController:(UIViewController *)baseViewController parameters:(NSDictionary *)parameters invokeType:(ABKRouterInvokeType)invokeType animated:(BOOL)animated complete:(void (^)(void))complete
{
    if ([self canHandleURLString:urlString]) {
        if (!baseViewController) {
            baseViewController = [UIViewController abk_topMostViewController];
        }
        if (invokeType == ABKRouterInvokeTypeAuto) {
            invokeType = baseViewController.navigationController ? ABKRouterInvokeTypePush : ABKRouterInvokeTypePresent;
        }
        if (invokeType == ABKRouterInvokeTypePresent) {
            [self presentWithURLString:urlString baseViewController:baseViewController appParameters:parameters animated:animated complete:complete];
        } else {
            [self pushWithURLString:urlString baseViewController:baseViewController appParameters:parameters animated:animated];
        }
    } else {
        NSURL *url = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @NO};
                [[UIApplication sharedApplication] openURL:url options:options completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

- (BOOL)canHandleURLString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    if (url.scheme.length) {
        return [self.availableSchemes containsObject:url.scheme];
    }
    return YES;
}

- (Class)viewControllerClassForURLString:(NSString *)urlString
{
    NSString *moduleName = [self moduleNameForURLString:urlString];
    return self.viewControllersMapper[moduleName];
}

- (void)presentWithURLString:(NSString *)urlString baseViewController:(UIViewController *)baseViewController appParameters:(NSDictionary *)appParameters animated:(BOOL)animated complete:(void (^)(void))complete
{
    UIViewController *viewController = [self responseViewControllerForURLString:urlString appParameters:appParameters];
    [baseViewController presentViewController:viewController animated:animated completion:complete];
}

- (void)pushWithURLString:(NSString *)urlString baseViewController:(UIViewController *)baseViewController appParameters:(NSDictionary *)appParameters animated:(BOOL)animated
{
    UIViewController *viewController = [self responseViewControllerForURLString:urlString appParameters:appParameters];
    [baseViewController.navigationController pushViewController:viewController animated:animated];
}

- (UIViewController *)responseViewControllerForURLString:(NSString *)urlString appParameters:(NSDictionary *)appParameters
{
    Class viewControllerClass = [self viewControllerClassForURLString:urlString];
    NSDictionary *parameters = [NSDictionary abk_dictionaryWithURLString:urlString];
    if (appParameters.count) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [dic addEntriesFromDictionary:appParameters];
        parameters = [dic copy];
    }
    UIViewController<ABKRouterResponse> *viewController = nil;
    if ([viewControllerClass instancesRespondToSelector:@selector(initWithParameters:)]) {
        viewController = [[viewControllerClass alloc] initWithParameters:parameters];
    } else {
        NSString *viewControllerName = NSStringFromClass(viewControllerClass);
        if ([[NSBundle mainBundle] pathForResource:viewControllerName ofType:@"nib"]) {
            viewController = [[viewControllerClass alloc] initWithNibName:viewControllerName bundle:nil];
        } else {
            viewController = [[viewControllerClass alloc] init];
        }
    }
    if ([viewControllerClass instancesRespondToSelector:@selector(configWithParameters:)]) {
        [viewController configWithParameters:parameters];
    }
    return viewController;
}

@end

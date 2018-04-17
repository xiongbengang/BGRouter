//
//  ABKRouter.h
//  BGRouter
//
//  Created by Bengang on 2018/4/12.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ABKRouterInvokeType) {
    ABKRouterInvokeTypeAuto = 0,
    ABKRouterInvokeTypePush = 1,
    ABKRouterInvokeTypePresent = 2,
};

@protocol ABKRouterResponse <NSObject>

@optional
- (instancetype)initWithParameters:(NSDictionary *)parameters;

- (void)configWithParameters:(NSDictionary *)parameters;

@end

@interface ABKRouter : NSObject

+ (instancetype)router;

- (void)configWithSchemes:(NSArray<NSString *> *)schemes;

- (void)registViewController:(Class)viewControllerClass forURLString:(NSString *)urlString;

- (void)registViewController:(Class)viewControllerClass forPath:(NSString *)path;

- (void)openURLString:(NSString *)urlString;

- (void)openURLString:(NSString *)urlString baseViewController:(UIViewController *)baseViewController;

- (void)openURLString:(NSString *)urlString baseViewController:(UIViewController *)baseViewController parameters:(NSDictionary *)parameters invokeType:(ABKRouterInvokeType)openType;

- (void)openURLString:(NSString *)urlString baseViewController:(UIViewController *)baseViewController parameters:(NSDictionary *)parameters invokeType:(ABKRouterInvokeType)openType animated:(BOOL)animated complete:(void (^)(void))complete;

@end

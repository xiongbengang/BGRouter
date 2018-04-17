//
//  NSDictionary+ABKRouter.m
//  BGRouter
//
//  Created by Bengang on 2018/4/12.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "NSDictionary+ABKRouter.h"

@implementation NSDictionary (ABKRouter)

+ (instancetype)abk_dictionaryWithURLString:(NSString *)urlString
{
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:components.queryItems.count];
    for (NSURLQueryItem *queryItem in components.queryItems) {
        [dictionary setObject:queryItem.value forKey:queryItem.name];
    }
    return dictionary;
}

@end

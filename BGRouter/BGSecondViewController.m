//
//  BGSecondViewController.m
//  BGRouter
//
//  Created by Bengang on 2018/4/16.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "BGSecondViewController.h"
#import "ABKRouter.h"

@interface BGSecondViewController () <ABKRouterResponse>

@end

@implementation BGSecondViewController

- (instancetype)initWithParameters:(NSDictionary *)parameters
{
    self = [super init];
    if (self) {
        self.title = parameters[@"title"];
    }
    return self;
}

+ (void)load
{
    [[ABKRouter router] registViewController:[self class] forPath:@"Second"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

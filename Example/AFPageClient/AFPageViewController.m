//
//  AFPageViewController.m
//  AFPageClient_Example
//
//  Created by alfie on 2020/8/31.
//  Copyright © 2020 yxh418983798. All rights reserved.
//

#import "AFPageViewController.h"

@interface AFPageViewController ()

@end

@implementation AFPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor =  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
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

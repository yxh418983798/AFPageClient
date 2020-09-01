//
//  AFHAHAViewController.m
//  AFPageClient_Example
//
//  Created by alfie on 2020/9/1.
//  Copyright © 2020 yxh418983798. All rights reserved.
//

#import "AFHAHAViewController.h"
#import "AFViewController.h"

@interface AFHAHAViewController ()



@end

@implementation AFHAHAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"asd" style:(UIBarButtonItemStylePlain) target:self action:@selector(asd)];

}


- (void)asd {
    [self.navigationController pushViewController:AFViewController.new animated:YES];
}



@end

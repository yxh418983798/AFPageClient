//
//  AFPageViewController.m
//  AFPageClient_Example
//
//  Created by alfie on 2020/8/31.
//  Copyright © 2020 yxh418983798. All rights reserved.
//

#import "AFPageViewController.h"
#import <AFPageClient/AFPageClient.h>

@interface AFPageViewController () <UITableViewDelegate, UITableViewDataSource>

/** ta */
@property (nonatomic, strong) UITableView            *tableView;

@end

@implementation AFPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor =  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70.f;
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.tableView];
}

- (__kindof UIScrollView *)childScrollViewForPageClient:(AFPageClient *)pageClient {
    return self.tableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
        cell.contentView.backgroundColor = UIColor.grayColor;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%lu个Cell", indexPath.row];
    return cell;
}


@end

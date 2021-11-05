//
//  AFPageViewController.m
//  AFPageClient_Example
//
//  Created by alfie on 2020/8/31.
//  Copyright © 2020 yxh418983798. All rights reserved.
//

#import "AFPageViewController.h"
#import <AFPageClient/AFPageClient.h>
#import <MJRefresh/MJRefresh.h>
#import "AFPageTableView.h"
#import <Masonry/Masonry.h>

@interface AFTableView : UITableView
@end
@implementation AFTableView
//- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)pan {
////    NSLog(@"-------------------------- 来了111：%@ --------------------------", pan);
//    if (![pan isKindOfClass:UIPanGestureRecognizer.class] || pan.view != self) return [super gestureRecognizerShouldBegin:pan];
//    CGPoint velocity = [pan velocityInView:pan.view];
//    if (velocity.y == 0) {
////        NSLog(@"-------------------------- 2222 --------------------------");
//        return pan.delaysTouchesBegan;
//    }
//    if (velocity.y != 0 && fabs(velocity.x / velocity.y) < 1.4) {
//        return [super gestureRecognizerShouldBegin:pan];
//    }
//    return NO;
//}
//- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIPanGestureRecognizer *)otherGestureRecognizer {
//    if (otherGestureRecognizer.view == self) return NO;
//    if ([otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class] && [otherGestureRecognizer.view isKindOfClass:UIScrollView.class]) {
//        return YES;
//    }
//    return NO;
//}

@end


@interface AFPageViewController () <UITableViewDelegate, UITableViewDataSource>

/** ta */
@property (nonatomic, strong) UITableView            *tableView;

/** cou */
@property (nonatomic, assign) int            count;
@end

@implementation AFPageViewController

- (void)refreshAction {
    NSLog(@"-------------------------- 下拉刷新 --------------------------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView.mj_header endRefreshing];
    });
}

- (void)footerAction {
    NSLog(@"-------------------------- 下拉加载 --------------------------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.count += 10;
        [_tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 20;
    self.view.backgroundColor =  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    NSLog(@"-------------------------- viewDidLoad:Self%@ --------------------------", self);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerAction)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.offset(0);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[AFTableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70.f;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
    }
    return _tableView;
}

//- (__kindof UIScrollView *)childScrollViewForPageClient:(AFPageClient *)pageClient {
////    NSLog(@"-------------------------- childScrollViewForPageClient:%@ --------------------------", self);
//    return self.tableView;
//}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
        cell.contentView.backgroundColor = UIColor.grayColor;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"super:%ld  self:%ld",(long) (long)self.superIndex,(long) (long)self.index];
    return cell;
}




@end

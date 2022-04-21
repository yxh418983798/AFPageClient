//
//  AFViewController.m
//  AFPageClient
//
//  Created by yxh418983798 on 08/30/2020.
//  Copyright (c) 2020 yxh418983798. All rights reserved.
//

#import "AFViewController.h"
#import "AFChildPageViewController.h"
#import "AFSegmentView.h"
#import "AFPageItem.h"
#import "AFSegmentConfiguration.h"
#import "AFPageClient.h"
#import "AFPageViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <objc/runtime.h>

@interface AFViewController () <AFPageClientDelegate>

/** AFPageClient */
@property (nonatomic, strong) AFPageClient             *pageClient;

/** item */
@property (nonatomic, strong) AFPageItem               *item;

@end

@implementation AFViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    AFSegmentConfiguration *s = AFSegmentConfiguration.new;
    CGFloat inset = (self.view.frame.size.width - 300)/2;
    s.insets = UIEdgeInsetsMake(0, inset, 0, inset);
//    s.backgroundColor = UIColor.lightGrayColor;
    s.scrollBar_minW = 20;
    s.scrollBar_maxW = 100;
    s.scrollBarColor = UIColor.redColor;
//    s.showScrollBar = NO;
    
    self.pageClient = [[AFPageClient alloc] initWithFrame:(CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height - 88)) parentController:self configuration:s];
    self.pageClient.delegate = self;
//    self.pageClient.selectedIndex =  0;
    [self.pageClient reloadPageClient:9];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

/// 返回item的数量
- (NSInteger)numberOfItemsInPageClient:(AFPageClient *)pageClient {
    return 10;
}

/// 构造item数据源，内部会自动缓存item，避免重复创建，如果需要更新数据源，需要调用reloadData
- (AFPageItem *)pageClient:(AFPageClient *)pageClient itemForPageAtIndex:(NSInteger)index {
    
    AFPageItem *item = AFPageItem.new;
    item.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    item.selectedFont = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    
    item.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
    item.selectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    item.textColor = UIColor.blackColor;
//    item.selectedTextColor = UIColor.redColor;
    
//    {
//        UILabel *lb = UILabel.new;
//        lb.frame = CGRectMake(0, 0, 70, 40);
//        lb.text = [NSString stringWithFormat:@"Item:%ld", (long)index];
//        lb.textColor = UIColor.blackColor;
//        lb.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
//        item.content = lb;
//    }
//    {
//        UILabel *lb = UILabel.new;
//        lb.frame = CGRectMake(0, 0, 70, 40);
//        lb.text = [NSString stringWithFormat:@"Item:%ld", (long)index];
//        lb.textColor = UIColor.redColor;
//        item.selectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
//        item.selectedContent = lb;
//    }
//    
    item.content = [NSString stringWithFormat:@"Item:%ld", (long)index];
//    AFChildPageViewController *vc = AFChildPageViewController.new;
    AFChildPageViewController *vc = AFPageViewController.new;
    vc.index = index;
    item.childViewController = vc;
    if (index == 0) {
        self.item = item;
    }
    return item;
}

/// 选中Item的回调
- (void)pageClient:(AFPageClient *)pageClient didSelectItemAtIndex:(NSInteger)index {
//    NSLog(@"-------------------------- 来了：%d --------------------------", index);
}

//static NSString *content = AFPageItemBadgeRedDot;
//- (AFPageItemBadge *)pageClient:(AFPageClient *)pageClient badgeForItemAtIndex:(NSInteger)index {
//    if (index == 0) {
//        return nil;
//    }
//    AFPageItemBadge *badge = AFPageItemBadge.new;
//    badge.offset = CGPointMake(0, 10);
//    content = content == AFPageItemBadgeRedDot ? @"12" : AFPageItemBadgeRedDot;
//    badge.content = content;
//    return badge;
//}


/// 自定义leftView
- (UIView *)leftViewForSegmentInPageClient:(AFPageClient *)pageClient {
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(0, 0, 50, 50);
    [btn setTitle:@"返回" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(popAction) forControlEvents:(UIControlEventTouchUpInside)];
    return btn;
}


/// 自定义rightView
//- (UIView *)rightViewForSegment:(AFSegmentView *)segmentView {
//    UIView *leftView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 50, 50))];
//    leftView.backgroundColor = UIColor.blackColor;
//    return leftView;
//}


- (void)popAction {
    [self.pageClient setSelectedIndex:1 animated:YES];
//    [self.pageClient reloadBadge];
//    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tapAction {
    
    UIView *obj = UIView.new;
    objc_setAssociatedObject(self, "afobj", obj, OBJC_ASSOCIATION_ASSIGN);
    NSLog(@"-------------------------- tapAction:%@ --------------------------", obj);
    obj = nil;
    objc_setAssociatedObject(self, "afobj", nil, OBJC_ASSOCIATION_ASSIGN);
    UIView *v = objc_getAssociatedObject(self, "afobj");
    NSLog(@"-------------------------- 哈哈：%@ --------------------------", v);
}


@end

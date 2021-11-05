//
//  AFChildPageViewController.m
//  AFPageClient_Example
//
//  Created by alfie on 2021/10/25.
//  Copyright © 2021 yxh418983798. All rights reserved.
//

#import "AFChildPageViewController.h"
#import "AFViewController.h"
#import "AFSegmentView.h"
#import "AFPageItem.h"
#import "AFSegmentConfiguration.h"
#import "AFPageClient.h"
#import "AFPageViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <objc/runtime.h>

@interface AFChildPageViewController () <AFPageClientDelegate>

/** AFPageClient */
@property (nonatomic, strong) AFPageClient             *pageClient;

/** item */
@property (nonatomic, strong) AFPageItem               *item;

@end

@implementation AFChildPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    AFSegmentConfiguration *s = AFSegmentConfiguration.new;
    CGFloat inset = (self.view.frame.size.width - 300)/2;
    s.insets = UIEdgeInsetsMake(0, inset, 0, inset);
//    s.backgroundColor = UIColor.lightGrayColor;
    s.scrollBar_minW = 20;
    s.scrollBar_maxW = 100;
    s.scrollBarColor = UIColor.redColor;
    
    self.pageClient = [[AFPageClient alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)) parentController:self configuration:s];
    self.pageClient.delegate = self;
//    self.pageClient.selectedIndex =  0;
    [self.pageClient reloadPageClient:1];
    
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
    return 2;
}

/// 构造item数据源，内部会自动缓存item，避免重复创建，如果需要更新数据源，需要调用reloadData
- (AFPageItem *)pageClient:(AFPageClient *)pageClient itemForPageAtIndex:(NSInteger)index {
    
    AFPageItem *item = AFPageItem.new;
    item.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
    item.selectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    item.font = [UIFont systemFontOfSize:10 weight:UIFontWeightThin];
    item.selectedFont = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
//    item.content = [NSString stringWithFormat:@"child %ldd", index];
    {
        UILabel *lb = UILabel.new;
        lb.frame = CGRectMake(0, 0, 70, 40);
        lb.text = [NSString stringWithFormat:@"Item:%ld", (long)index];
        lb.textColor = UIColor.blackColor;
        lb.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
        item.content = lb;
    }
    {
        UILabel *lb = UILabel.new;
        lb.frame = CGRectMake(0, 0, 70, 40);
        lb.text = [NSString stringWithFormat:@"Item:%ld", (long)index];
        lb.textColor = UIColor.redColor;
        item.selectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        item.selectedContent = lb;
    }
//    {
//        UILabel *lb = UILabel.new;
//        lb.frame = CGRectMake(0, 0, 50, 40);
//        lb.text = [NSString stringWithFormat:@"child %ldd", index];
//        lb.backgroundColor = UIColor.whiteColor;
//        lb.textColor = UIColor.blackColor;
//        item.content = lb;
//    }
//    {
//        UILabel *lb = UILabel.new;
//        lb.frame = CGRectMake(0, 0, 50, 40);
//        lb.text = [NSString stringWithFormat:@"child %ldd", index];
//        lb.backgroundColor = UIColor.redColor;
//        lb.textColor = UIColor.blackColor;
//        item.selectedContent = lb;
//    }
    AFPageViewController *vc = AFPageViewController.new;
    vc.index = index;
    vc.superIndex = self.index;
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

- (BOOL)pageClient:(AFPageClient *)pageClient horizontalScrollEnableWithGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint velocity = [pan velocityInView:pan.view];
    if (pageClient.selectedIndex == 0 && velocity.x > 0) {
        return NO;
    } else if (pageClient.selectedIndex == 9 && velocity.x < 0) {
        return NO;
    }
    return YES;
}


- (void)popAction {
//    self.pageClient.selectedIndex = 1;
    [self.navigationController pushViewController:AFChildPageViewController.new animated:YES];
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

///// 自定义leftView
- (UIView *)leftViewForSegmentInPageClient:(AFPageClient *)pageClient {
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(0, 0, 50, 50);
    [btn setTitle:@"返回" forState:(UIControlStateNormal)];
    [btn setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(popAction) forControlEvents:(UIControlEventTouchUpInside)];
    return btn;
}



@end

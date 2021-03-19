//
//  AFViewController.m
//  AFPageClient
//
//  Created by yxh418983798 on 08/30/2020.
//  Copyright (c) 2020 yxh418983798. All rights reserved.
//

#import "AFViewController.h"
#import "AFSegmentView.h"
#import "AFPageItem.h"
#import "AFSegmentConfiguration.h"
#import "EncryptionTools.h"
#import "RSACryptor.h"
#import "AFPageClient.h"
#import "AFPageViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <objc/runtime.h>
@interface AFViewController () <AFPageClientDelegate>

/** AFSegmentView */
@property (nonatomic, strong) AFSegmentView            *segmentView;

/** AFPageClient */
@property (nonatomic, strong) AFPageClient             *pageClient;

/** item */
@property (nonatomic, strong) AFPageItem               *item;

@end

@implementation AFViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)refreshAction {
    NSLog(@"-------------------------- 下拉刷新 --------------------------");
    UIScrollView *sv = [self.pageClient performSelector:@selector(scrollProxy)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sv.mj_header endRefreshing];
    });
}

- (void)footerAction {
    NSLog(@"-------------------------- 下拉加载 --------------------------");
    UIScrollView *sv = [self.pageClient performSelector:@selector(scrollProxy)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sv.mj_footer endRefreshing];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AFSegmentConfiguration *s = AFSegmentConfiguration.new;
    s.insets = UIEdgeInsetsMake(0, 100, 0, 100);
    s.backgroundColor = UIColor.lightGrayColor;
    s.scrollBar_minW = 20;
    s.scrollBar_maxW = 100;
    s.scrollBarColor = UIColor.redColor;
    s.style = AFPageClientStylePullItem;
    self.pageClient = [[AFPageClient alloc] initWithFrame:(CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)) parentController:self configuration:s];
    self.pageClient.delegate = self;
    self.pageClient.selectedIndex =  1;
    [self.pageClient reloadData];
    
    UIScrollView *sv = [self.pageClient performSelector:@selector(scrollProxy)];
    sv.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    sv.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerAction)];
    //
//    AFSegmentView *segmentView = AFSegmentView.new;
//    segmentView.configuration.backgroundColor = UIColor.grayColor;
//    segmentView.delegate = self;
//    segmentView.configuration.frame = CGRectMake(0, 100, self.view.frame.size.width, 50);
//    [self.view addSubview:segmentView];
//    [segmentView update];
    
    
//     AES CBC对称加密
    NSString *key = @"htfvjredhjhghpsy";
    NSData *data = [key dataUsingEncoding:(NSUTF8StringEncoding)];
    NSDictionary *aa = @{@"sdjfl": @(1231232), @"data":@"http://www.baidu.com"};
    NSString *rr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:aa options:0 error:NULL] encoding:NSUTF8StringEncoding];
    
    NSString *str = [EncryptionTools.sharedEncryptionTools encryptString:@"{\"sdjfl\": 1231232, \"data\":\"http://www.baidu.com\"}" keyString:key iv:data];
    NSLog(@"-------------------------- 加密后：%@--------------------------", str);
    str = [EncryptionTools.sharedEncryptionTools decryptString:@"FeYaUjUlqonYJf740RqInLvzhFuqdS9WM45L1yCIVbzRTjtgthOVCyGcBf2VJGW2" keyString:key iv:data];
    NSLog(@"-------------------------- 解密后：%@ --------------------------", str);

    
//    NSData *dd = [@"d/MgQA4W3jhoN/ApNto40zPMMIGPdTs0O9hpwy9+XIxSq/UG6FAhxQvNe7WVJjHDm/W8T/w/w8s6\nj40INJWsfcG1CDKWYsC/3uhv5l17xy8vhbQCFfurQqk0XaSb/Q6VdJX0ej4rrDXg/se/fh5I/BZV\nqcS65UA9NIDg/bAQVIxhfVkgkB6wmfugwBRferkw\n" dataUsingEncoding:4];

    
//    [RSACryptor.sharedRSACryptor generateKeyPair:1024];
//    [RSACryptor.sharedRSACryptor loadPublicKey:[NSBundle.mainBundle pathForResource:@"public_key.der" ofType:nil]];
//    [RSACryptor.sharedRSACryptor loadPrivateKey:[NSBundle.mainBundle pathForResource:@"private_key.p12" ofType:nil] password:@"mostone0717"];
//    NSData *eData = [RSACryptor.sharedRSACryptor encryptData:data];
//    NSData *dData = [RSACryptor.sharedRSACryptor decryptData:eData];
//    NSLog(@"-------------------------- dData:%@ --------------------------",  [[NSString alloc] initWithData:dData encoding:NSUTF8StringEncoding]);
}


///// 自定义leftView
//- (UIView *)leftViewForSegment:(AFSegmentView *)segmentView {
//
//}
//
///// 自定义rightView
//- (UIView *)rightViewForSegment:(AFSegmentView *)segmentView {
//
//}

/// 自定义pageClient的headerView
- (UIView *)headerViewForPageClient:(AFPageClient *)pageClient {
    UIView *headerView = UIView.new;
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    headerView.backgroundColor = UIColor.redColor;
    
    UIView *view = UIView.new;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    view.frame = CGRectMake(0, 50, self.view.frame.size.width, 100);
    view.backgroundColor = UIColor.blueColor;
    [headerView addSubview:view];
    return headerView;
}

/// 返回item的数量
- (NSInteger)numberOfItemsInPageClient:(AFPageClient *)pageClient {
    return 4;
}

/// 构造item数据源，内部会自动缓存item，避免重复创建，如果需要更新数据源，需要调用reloadData
- (AFPageItem *)pageClient:(AFPageClient *)pageClient itemForPageAtIndex:(NSInteger)index {
    AFPageItem *item = AFPageItem.new;
    item.textColor = UIColor.redColor;
    item.selectedTextColor = UIColor.blackColor;
    item.font = [UIFont systemFontOfSize:12];
    item.selectedFont = [UIFont systemFontOfSize:18];
    item.childViewController = AFPageViewController.new;
    item.content = [NSString stringWithFormat:@"第%d个item", index];
//    item.backgroundColor = UIColor.grayColor;
    if (index == 0) {
        self.item = item;
    }
//    NSLog(@"-------------------------- itemForSegmentAtIndex：%d --------------------------", index);
    return item;
}

static NSString *content = AFPageItemBadgeRedDot;
- (AFPageItemBadge *)pageClient:(AFPageClient *)pageClient badgeForItemAtIndex:(NSInteger)index {
    if (index == 0) {
        return nil;
    }
    AFPageItemBadge *badge = AFPageItemBadge.new;
    badge.offset = CGPointMake(0, 10);
    content = content == AFPageItemBadgeRedDot ? @"12" : AFPageItemBadgeRedDot;
    badge.content = content;
    return badge;
}

/// 选中Item的回调
- (void)pageClient:(AFPageClient *)pageClient didSelectItemAtIndex:(NSInteger)index {
//    NSLog(@"-------------------------- 来了：%d --------------------------", index);
}

/// 自定义leftView
- (UIView *)leftViewForSegmentInPageClient:(AFPageClient *)pageClient {
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(0, 0, 50, 50);
    [btn setTitle:@"返回" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(popAction) forControlEvents:(UIControlEventTouchUpInside)];
    return btn;
}

- (void)popAction {
    [self.pageClient reloadBadge];
    [self.navigationController popViewControllerAnimated:YES];
}

/// 自定义rightView
- (UIView *)rightViewForSegment:(AFSegmentView *)segmentView {
    UIView *leftView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 50, 50))];
    leftView.backgroundColor = UIColor.blackColor;
    return leftView;
}

- (void)dealloc {
    NSLog(@"-------------------------- 控制器释放 --------------------------");
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

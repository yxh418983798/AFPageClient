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

@interface AFViewController () <AFPageClientDelegate>

/** AFSegmentView */
@property (nonatomic, strong) AFSegmentView            *segmentView;

/** AFPageClient */
@property (nonatomic, strong) AFPageClient             *pageClient;

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    AFSegmentConfiguration *s = AFSegmentConfiguration.new;
    s.insets = UIEdgeInsetsMake(0, 100, 0, 100);
    s.scrollBarColor = UIColor.redColor;
    self.pageClient = [[AFPageClient alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)) parentController:self configuration:s];
    self.pageClient.delegate = self;
    [self.pageClient reloadData];
    
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



/// 返回item的数量
- (NSInteger)numberOfItemsInPageClient:(AFPageClient *)pageClient {
    return 2;
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
    item.displayBadge = @"";
    item.badgeOffset = CGPointMake(0, 10);
    NSLog(@"-------------------------- itemForSegmentAtIndex：%d --------------------------", index);
    return item;
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
@end

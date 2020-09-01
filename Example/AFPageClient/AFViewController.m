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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageClient = [[AFPageClient alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)) parentController:self configuration:AFSegmentConfiguration.new];
    self.pageClient.delegate = self;
    [self.pageClient reloadData];
//
//    AFSegmentView *segmentView = AFSegmentView.new;
//    segmentView.configuration.backgroundColor = UIColor.grayColor;
//    segmentView.delegate = self;
//    segmentView.configuration.frame = CGRectMake(0, 100, self.view.frame.size.width, 50);
//    [self.view addSubview:segmentView];
//    [segmentView update];
    
    
    // AES CBC对称加密
//    NSString *key = @"asdfasdfasdfasdf";
//    NSData *data = [key dataUsingEncoding:(NSUTF8StringEncoding)];
//    NSString *str = [EncryptionTools.sharedEncryptionTools encryptString:@"测试加密数据" keyString:key iv:data];
//    NSLog(@"-------------------------- 加密后：%@--------------------------", str);
//    str = [EncryptionTools.sharedEncryptionTools decryptString:str keyString:key iv:data];
//    NSLog(@"-------------------------- 解密后：%@ --------------------------", str);

    //
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
    return 5;
}

/// 构造item数据源，内部会自动缓存item，避免重复创建，如果需要更新数据源，需要调用reloadData
- (AFPageItem *)pageClient:(AFPageClient *)pageClient itemForPageAtIndex:(NSInteger)index {
    AFPageItem *item = AFPageItem.new;
    item.childViewController = AFPageViewController.new;
    item.content = [NSString stringWithFormat:@"第%d个item", index];
    NSLog(@"-------------------------- itemForSegmentAtIndex：%d --------------------------", index);
    return item;
}


/// 选中Item的回调
- (void)pageClient:(AFPageClient *)pageClient didSelectItemAtIndex:(NSInteger)index {
//    NSLog(@"-------------------------- 来了：%d --------------------------", index);
}

/// 自定义leftView
- (UIView *)leftViewForSegment:(AFSegmentView *)segmentView {
    UIView *leftView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 50, 50))];
    leftView.backgroundColor = UIColor.blackColor;
    return leftView;
}

/// 自定义rightView
- (UIView *)rightViewForSegment:(AFSegmentView *)segmentView {
    UIView *leftView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 50, 50))];
    leftView.backgroundColor = UIColor.blackColor;
    return leftView;
}

@end

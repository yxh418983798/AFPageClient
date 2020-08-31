//
//  AFViewController.m
//  AFPageClient
//
//  Created by yxh418983798 on 08/30/2020.
//  Copyright (c) 2020 yxh418983798. All rights reserved.
//

#import "AFViewController.h"
#import "AFSegmentView.h"
#import "AFSegmentItem.h"
#import "AFSegmentConfiguration.h"
#import "EncryptionTools.h"
#import "RSACryptor.h"

@interface AFViewController () <AFSegmentViewDelegate>

/** AFSegmentView */
@property (nonatomic, strong) AFSegmentView            *segmentView;

@end

@implementation AFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AFSegmentView *segmentView = AFSegmentView.new;
    segmentView.configuration.backgroundColor = UIColor.grayColor;
    segmentView.delegate = self;
    segmentView.configuration.frame = CGRectMake(0, 100, self.view.frame.size.width, 50);
    [self.view addSubview:segmentView];
    [segmentView update];
    
    
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

/// item的数量
- (NSInteger)numberOfItemsInSegmentView:(AFSegmentView *)segmentView {
    return 5;
}

/// 自定义每个item的数据源
- (AFSegmentItem *)segmentView:(AFSegmentView *)segmentView itemForSegmentAtIndex:(NSInteger)index {
    AFSegmentItem *item = AFSegmentItem.new;
    item.content = [NSString stringWithFormat:@"第%d个item", index];
    NSLog(@"-------------------------- itemForSegmentAtIndex：%d --------------------------", index);
    return item;
}

/// 选中Item的回调
- (void)segmentView:(AFSegmentView *)segmentView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"-------------------------- 来了：%d --------------------------", index);
}


@end

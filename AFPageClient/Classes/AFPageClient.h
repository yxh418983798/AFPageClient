//
//  AFPageClient.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <Foundation/Foundation.h>
#import "AFPageItem.h"
#import "AFSegmentConfiguration.h"

@class AFPageClient;

@protocol AFPageClientDelegate <NSObject>

/// 必须实现， 返回item的数量
- (NSInteger)numberOfItemsInPageClient:(AFPageClient *)pageClient;

/// 必须实现，构造item数据源，内部会自动缓存item以提升性能，如果需要更新数据源，需要调用reloadData
- (AFPageItem *)pageClient:(AFPageClient *)pageClient itemForPageAtIndex:(NSInteger)index;


@optional;

/// 选中Item的回调
- (void)pageClient:(AFPageClient *)pageClient didSelectItemAtIndex:(NSInteger)index;

/// 自定义Segment的leftView
- (UIView *)leftViewForSegmentInPageClient:(AFPageClient *)pageClient;

/// 自定义Segment的rightView
- (UIView *)rightViewForSegmentInPageClient:(AFPageClient *)pageClient;


@end



@interface AFPageClient : NSObject

/** 代理 */
@property (nonatomic, weak) id <AFPageClientDelegate>    delegate;

/** 获取当前index */
@property (assign, nonatomic) NSInteger                  selectedIndex;

/// 构造
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame parentController:(UIViewController *)viewController configuration:(AFSegmentConfiguration *)configuration;

/// 刷新
- (void)reloadData;

/// 获取当前Vc
- (UIViewController *)currentVc;


@end



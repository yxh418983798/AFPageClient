//
//  AFPageClient.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//
//  Version: 1.2.2

#import <Foundation/Foundation.h>
#import "AFPageItem.h"
#import "AFPageItemBadge.h"
#import "AFSegmentConfiguration.h"
#import "AFScrollViewProxy.h"

@class AFPageClient, AFSegmentView;

@protocol AFPageClientDelegate <NSObject>

/// 必须实现， 返回item的数量
- (NSInteger)numberOfItemsInPageClient:(AFPageClient *)pageClient;

/// 必须实现，构造item数据源，内部会自动缓存item以提升性能，如果需要更新数据源，需要调用reloadData
- (AFPageItem *)pageClient:(AFPageClient *)pageClient itemForPageAtIndex:(NSInteger)index;

@optional;

/// 返回item的角标
- (AFPageItemBadge *)pageClient:(AFPageClient *)pageClient badgeForItemAtIndex:(NSInteger)index;

/// 选中Item的回调
- (void)pageClient:(AFPageClient *)pageClient didSelectItemAtIndex:(NSInteger)index;

/// 自定义pageClient的headerView
- (UIView *)headerViewForPageClient:(AFPageClient *)pageClient;

/// 自定义头部菜单栏的leftView
- (UIView *)leftViewForSegmentInPageClient:(AFPageClient *)pageClient;

/// 自定义头部菜单栏的rightView
- (UIView *)rightViewForSegmentInPageClient:(AFPageClient *)pageClient;

/// 返回PageClient是否可以横向滚动，也可以通过设置pageItem的ScrollEnable控制
- (BOOL)pageClient:(AFPageClient *)pageClient horizontalScrollEnableWithGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

/// ScrollView纵向滚动监听
- (void)pageClient:(AFPageClient *)pageClient didScrollVertical:(UIScrollView *)scrollView;

/// ScrollView横向滚动监听
- (void)pageClient:(AFPageClient *)pageClient didScrollHorizontal:(UIScrollView *)scrollView;

@end


@protocol AFPageClientChildViewControllerDelegate <NSObject>

- (__kindof UIScrollView *)childScrollViewForPageClient:(AFPageClient *)pageClient;

@end


@interface AFPageClient : NSObject

/** 代理 */
@property (nonatomic, weak) id <AFPageClientDelegate>    delegate;

/** 当前index */
@property (assign, nonatomic) NSInteger                  selectedIndex;

/** 获取外层的TableView */
- (UITableView *)tableView;

/** 获取scrollProxy，如果有设置嵌套滚动，且需要下拉刷新，需要同步设置下scrollProxy的refresh控件 */
- (AFScrollViewProxy *)scrollProxy;


/// 构造
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame parentController:(UIViewController *)viewController configuration:(AFSegmentConfiguration *)configuration;

/// 获取item
- (AFPageItem *)itemAtIndex:(NSInteger)index;

/// 刷新整个PageClient
- (void)reloadData;

/// 刷新角标
- (void)reloadBadge;

/// 刷新某个index的角标
- (void)reloadBadgeAtIndex:(NSInteger)index;

/// 获取当前Vc
- (__kindof UIViewController *)currentVc;

/// 获取segmentView
- (AFSegmentView *)segmentView;


@end



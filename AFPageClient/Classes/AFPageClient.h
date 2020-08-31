//
//  AFPageClient.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <Foundation/Foundation.h>
#import "AFSegmentView.h"
#import "AFSegmentItem.h"

@class AFPageClient;

@protocol AFPageClientDelegate <NSObject>


- (UIScrollView *)scrollViewForChildViewController;

//请注意：该回调需要 子控制器先注册监听 才会调用
- (void)pageTableViewDidScroll:(UITableView *)tableView;


@optional;

/// 自定义leftView
- (UIView *)leftViewForSegment:(AFSegmentView *)segmentView;

/// 自定义rightView
- (UIView *)rightViewForSegment:(AFSegmentView *)segmentView;

/// item的数量
- (NSInteger)numberOfItemsInSegmentView:(AFSegmentView *)segmentView;

/// 自定义每个item的数据源
- (AFSegmentItem *)segmentView:(AFSegmentView *)segmentView itemForSegmentAtIndex:(NSInteger)index;

/// 自定义itemSize，如果不实现 && 没设置configuration的itemSize，默认自适应
- (CGSize)segmentView:(AFSegmentView *)segmentView sizeForItemAtIndex:(NSInteger)index;

/// 选中Item的回调
- (void)segmentView:(AFSegmentView *)segmentView didSelectItemAtIndex:(NSInteger)index;



- (__kindof UIViewController <AFPageClientDelegate> *)pageClient:(AFPageClient *)pageClient childViewControllerForItemAtIndex:(NSInteger)index;




//- (__kindof UIScrollView *)refreshScrollViewForConfiguration:(XHPageConfiguration *)configuration;

//- (void)pageTableViewDidScroll:(UITableView *)tableView;

//- (void)pageCollectionViewDidScroll:(XHBaseCollectionView *)collectionView;

//- (void)pageConfigurationDidScroll:(UIScrollView *)scrollView;

//- (void)pageConfigurationWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

//- (void)pageConfigurationDidEndDecelerating:(UIScrollView *)scrollView;

//- (NSInteger)numberOfChildViewControllersForParentViewController:(UIViewController *)parentViewController;


//自定义segment
- (XHSegmentView *)segmentViewForPageController;




/**
 *  头部视图
 *  segment固定状态时：传nil   --  子控制器为自定义控制器
 *  segment跟随滑动：不可为空 -- 注意此时的子控制器如果要滚动 必须遵循 XHPageChildViewControllerDelegate返回对应的ScrollView  否则无法进行联动滚动
 */
- (UIView *)headerViewForContainer;

@end



@interface AFPageClient : NSObject

/** 代理 */
@property (nonatomic, weak) id <AFPageClientDelegate>            delegate;


@end



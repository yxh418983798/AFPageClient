//
//  AFSegmentView.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <UIKit/UIKit.h>
#import "AFPageScrollBar.h"

@class AFSegmentView;
@class AFPageItem;
@class AFSegmentConfiguration;

@protocol AFSegmentViewDelegate <NSObject>

/// item的数量
- (NSInteger)numberOfItemsInSegmentView:(AFSegmentView *)segmentView;
 
/// 自定义每个item的数据源
- (AFPageItem *)segmentView:(AFSegmentView *)segmentView itemForSegmentAtIndex:(NSInteger)index;

/// 选中Item的回调
- (void)segmentView:(AFSegmentView *)segmentView didSelectItemAtIndex:(NSInteger)index;

@end


@interface AFSegmentView : UIView

/** scrollBar */
@property (nonatomic, strong) AFPageScrollBar          *scrollBar;

/** 配置 */
@property (strong, nonatomic) AFSegmentConfiguration   *configuration;

/** 控制器 */
@property (weak, nonatomic) UIViewController           *pageController;

/** 代理 */
@property (weak, nonatomic) id <AFSegmentViewDelegate> delegate;

/** leftView */
@property (strong, nonatomic) UIView                   *leftView;

/** rightView */
@property (strong, nonatomic) UIView                   *rightView;

/** 记录index */
@property (assign, nonatomic) NSInteger            last_index;
@property (assign, nonatomic) NSInteger            current_index;
@property (assign, nonatomic) NSInteger            default_index;

/// 更新
- (void)update;

/// 更新
- (void)reloadData;

/// 手动选中
- (void)selectedAtIndex:(NSInteger)index;

/// 监听滑动，实时更新UI
- (void)didScrollHorizontal:(UIScrollView *)scrollView;

@end



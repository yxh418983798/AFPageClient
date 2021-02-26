//
//  AFSegmentConfiguration.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, AFPageClientStyle) {
    AFPageClientStyleDefault,
    AFPageClientStylePullParent,
    AFPageClientStylePullItem,
};


@interface AFSegmentConfiguration : NSObject

/** AFPageClientStyle */
@property (nonatomic, assign) AFPageClientStyle  style;

/** headerView是否跟随滚动，默认NO */
@property (assign, nonatomic) BOOL headerViewScrollEnable;

/** 切换Item时，字体是否动画变化，默认YES */
@property (assign, nonatomic) BOOL animatedEnable;

/** 是否显示底部分割线 默认NO */
@property (assign, nonatomic) BOOL showBottomLine;

/** 手动设置是否允许滚动，默认NO -- 前提必须先关闭adjustEnable，否则无效 */
@property (assign, nonatomic) BOOL scrollEnable;

/** segmentView Frame */
@property (assign, nonatomic) CGRect   frame;

/** 缩进 */
@property (assign, nonatomic) UIEdgeInsets  insets;

/** 当itemSize为自适应时，可以设置item之间的间隔，默认25 */
@property (assign, nonatomic) CGFloat  itemSpace;

/** 底部分割线的颜色 */
@property (strong, nonatomic) UIColor  *lineColor;

/** 背景颜色 */
@property (nonatomic, strong) UIColor  *backgroundColor;


#pragma mark - 滚动条的配置
/** 是否显示滚动条 默认YES */
@property (nonatomic, assign) BOOL     showScrollBar;

/** 滚动条 最小宽度，默认6 */
@property (nonatomic, assign) CGFloat  scrollBar_minW;

/** 滚动条 最大宽度，默认60 */
@property (nonatomic, assign) CGFloat  scrollBar_maxW;

/** 滚动条 高度，默认6 */
@property (nonatomic, assign) CGFloat  scrollBar_H;

/** 滚动条的颜色 */
@property (nonatomic, strong) UIColor  *scrollBarColor;


@end



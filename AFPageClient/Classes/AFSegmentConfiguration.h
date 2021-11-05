//
//  AFSegmentConfiguration.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, AFPageClientStyle) {
    AFPageClientStyleDefault,    // 默认，顶部是固定的，没有嵌套滚动
    AFPageClientStylePullParent, // 嵌套滚动，下拉时，外层TableView下拉
    AFPageClientStylePullItem,   // 嵌套滚动，下拉时，内层的ScrollView下拉
};


@interface AFSegmentConfiguration : NSObject

/** 设置嵌套滚动的方式，默认没有嵌套滚动 */
@property (nonatomic, assign) AFPageClientStyle  style;

/** headerView是否跟随滚动，默认NO */
@property (assign, nonatomic) BOOL               headerViewScrollEnable;

/** 切换Item时，字体是否动画变化，默认YES */
@property (assign, nonatomic) BOOL               animatedEnable;

/** 是否显示底部分割线 默认NO */
@property (assign, nonatomic) BOOL               showBottomLine;

/** 底部分割线的颜色 */
@property (strong, nonatomic) UIColor            *lineColor;

/** 背景颜色 */
@property (nonatomic, strong) UIColor            *backgroundColor;

/** segmentView Frame */
@property (assign, nonatomic) CGRect        frame;

/** 缩进 */
@property (assign, nonatomic) UIEdgeInsets  insets;

/** 当itemSize为自适应时，可以设置item之间的间隔，默认25 */
@property (assign, nonatomic) CGFloat       itemSpace;


#pragma mark - 滚动条的配置
/** 是否显示滚动条 默认YES */
@property (nonatomic, assign) BOOL     showScrollBar;

/** 切换Item时，ScrollBar是否动画滚动，默认YES */
@property (assign, nonatomic) BOOL     scrollBarAnimated;

/** 滚动条 最小宽度，默认6 */
@property (nonatomic, assign) CGFloat  scrollBar_minW;

/** 滚动条 最大宽度，默认60 */
@property (nonatomic, assign) CGFloat  scrollBar_maxW;

/** 滚动条 高度，默认6 */
@property (nonatomic, assign) CGFloat  scrollBar_H;

/** 滚动条和Segment底部的间距，默认0 */
@property (nonatomic, assign) CGFloat  scrollBar_bottomInset;

/** 滚动条的颜色 */
@property (nonatomic, strong) UIColor  *scrollBarColor;


@end



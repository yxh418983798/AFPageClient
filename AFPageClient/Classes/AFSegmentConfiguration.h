//
//  AFSegmentConfiguration.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <Foundation/Foundation.h>


@interface AFSegmentConfiguration : NSObject


/** 切换Item时，字体是否动画变化，默认YES */
@property (assign, nonatomic) BOOL animatedEnable;

/** 是否显示底部分割线 默认NO */
@property (assign, nonatomic) BOOL showBottomLine;

/** 手动设置是否允许滚动，默认NO -- 前提必须先关闭adjustEnable，否则无效 */
@property (assign, nonatomic) BOOL scrollEnable;

/** 默认YES  YES：如果标题大于adjustMaxCount，会滚动并根据标题自适应宽度  --  NO：平分宽度且不滚动 */
@property (assign, nonatomic) BOOL adjustEnable;

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
@property (assign, nonatomic) BOOL showScrollBar;

/** 滚动条的颜色 */
@property (nonatomic, strong) UIColor  *scrollBarColor;


@end



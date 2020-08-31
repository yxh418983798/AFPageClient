//
//  AFSegmentConfiguration.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <Foundation/Foundation.h>

@interface AFSegmentConfiguration : NSObject


/** 是否显示滚动条 默认YES */
@property (assign, nonatomic) BOOL showScrollBar;

/** 是否显示底部分割线 默认YES */
@property (assign, nonatomic) BOOL showBottomLine;

/** 手动设置是否允许滚动，默认NO -- 前提必须先关闭adjustEnable，否则无效 */
@property (assign, nonatomic) BOOL scrollEnable;

/** 默认YES  YES：如果标题大于adjustMaxCount，会滚动并根据标题自适应宽度  --  NO：平分宽度且不滚动 */
@property (assign, nonatomic) BOOL adjustEnable;

/** 标题自适应临界值，默认5 */
@property (assign, nonatomic) BOOL shouldFill;

/** segmentView Frame */
@property (assign, nonatomic) CGRect   frame;

/** 指定itemSize，如果不设置 && 没有实现代理方法，默认自适应 */
@property (assign, nonatomic) CGSize   itemSize;

/** 缩进 */
@property (assign, nonatomic) UIEdgeInsets  insets;

/** collection溢出rightView宽度 */
@property (assign, nonatomic) CGFloat  rightOverSpace;

/** 标题之间的间隔，默认25，自适应时才有效 */
@property (assign, nonatomic) CGFloat  itemSpace;

/** 滚动条的高度 默认为2 */
@property (assign, nonatomic) CGFloat  lineHeight;

/** 滚动条间隔 */
@property (nonatomic, assign) CGFloat  lineSpace;

/** 滚动条的颜色 */
@property (nonatomic, strong) UIColor  *scrollBarColor;

/** 底部分割线的颜色 */
@property (strong, nonatomic) UIColor  *lineColor;

/** 背景颜色 */
@property (nonatomic, strong) UIColor  *backgroundColor;


@end



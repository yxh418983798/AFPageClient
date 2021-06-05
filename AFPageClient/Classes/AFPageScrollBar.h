//
//  AFPageScrollBar.h
//  AFPageClient
//
//  Created by alfie on 2020/8/31.
//
//  滚动条，整个动画移动过程：拉伸 - > 移动 -> 缩短

#import <UIKit/UIKit.h>

@class AFSegmentConfiguration;

@interface AFPageScrollBar : UIView

#pragma mark - 构造
- (instancetype)initWithConfiguration:(AFSegmentConfiguration *)configuration;

/// 滑动ScrollBar，动画更新
- (void)scrollFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue;

/// 滑动ScrollBar，实时更新
- (void)updatePrevious:(CGFloat)previous next:(CGFloat)next offsetPercent:(CGFloat)percent;

/// 停止动画（用户开始触摸的时候，停止ScrollBar的动画）
- (void)stop;

@end




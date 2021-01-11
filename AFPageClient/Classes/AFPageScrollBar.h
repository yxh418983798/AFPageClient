//
//  AFPageScrollBar.h
//  AFPageClient
//
//  Created by alfie on 2020/8/31.
//

#import <UIKit/UIKit.h>

@class AFSegmentConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface AFPageScrollBar : UIView

#pragma mark - 构造
- (instancetype)initWithConfiguration:(AFSegmentConfiguration *)configuration;


/// 滑动
- (void)scrollFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue;


/// 手势交互滑动，实时更新
- (void)interactionScrollFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue percent:(CGFloat)percent;


/// 停止
- (void)stop;


@end

NS_ASSUME_NONNULL_END

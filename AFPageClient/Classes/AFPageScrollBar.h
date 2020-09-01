//
//  AFPageScrollBar.h
//  AFPageClient
//
//  Created by alfie on 2020/8/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFPageScrollBar : UIView

/// 滑动
- (void)scrollFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue;


/// 手势交互滑动，实时更新
- (void)interactionScrollFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue percent:(CGFloat)percent;


@end

NS_ASSUME_NONNULL_END

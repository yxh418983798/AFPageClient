//
//  AFPageItemBadge.h
//  AFPageClient
//
//  Created by alfie on 2020/12/20.
//
//  item的角标显示

#import <Foundation/Foundation.h>

/// 小红点
static NSString * const AFPageItemBadgeRedDot = @"";

@interface AFPageItemBadge : NSObject

/**
 * @brief 角标的显示文本
 *
 * @note  默认nil：不显示角标
 * @note  设置为空字符串@""时，显示一个小红点
 * @note  设置为其他字符串时，显示对应的文本
 */
@property (nonatomic, copy) NSString            *content;

/** 角标的文字字体，默认10 */
@property (nonatomic, strong) UIFont            *font;

/** 角标的文字颜色，默认白色 */
@property (nonatomic, strong) UIColor           *textColor;

/** 角标的背景颜色，默认红色 */
@property (nonatomic, strong) UIColor           *backgroundColor;

/** 角标的外边框颜色 */
@property (nonatomic, strong) UIColor           *borderColor;

/** 角标的外边框大小，默认0 */
@property (nonatomic, assign) CGFloat           borderWidth;

/** 角标的圆角大小，默认3，展示小红点时，小红点的大小自适应为圆角的两倍大小 */
@property (nonatomic, assign) CGFloat           cornerRadius;

/** 角标文本的缩进默认，0，2，0，2 */
@property (nonatomic, assign) UIEdgeInsets      contentInsets;

/** 角标的偏移，默认（0, 0） */
@property (nonatomic, assign) CGPoint           offset;

@end



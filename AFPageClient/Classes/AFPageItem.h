//
//  AFPageItem.h
//  AFPageClient
//
//  Created by alfie on 2020/8/31.
//

#import <Foundation/Foundation.h>



@interface AFPageItem : NSObject

/** 控制器 */
@property (nonatomic, strong) UIViewController  *childViewController;

/** 指定itemSize，如果不设置，默认自适应 */
@property (assign, nonatomic) CGSize            itemSize;

/** 普通字体 */
@property (nonatomic, strong) UIFont            *font;

/** 选中字体 */
@property (nonatomic, strong) UIFont            *selectedFont;

/** 选中字体的颜色 */
@property (nonatomic, strong) UIColor           *textColor;

/** 选中字体的颜色 */
@property (nonatomic, strong) UIColor           *selectedTextColor;

/** 背景颜色 */
@property (nonatomic, strong) UIColor           *backgroundColor;

/** content */
@property (nonatomic, strong) id                content;

/** content */
@property (nonatomic, strong) id                selectedContent;

/** NSLineBreakMode */
@property (nonatomic, assign) NSLineBreakMode   lineBreakMode;


#pragma mark - 角标配置
/**
 * @brief 角标的显示文本
 *
 * @note  默认nil：不显示角标
 * @note  设置为空字符串@""时，显示一个小红点
 * @note  设置为其他字符串时，显示对应的文本
 */
@property (nonatomic, copy) NSString            *displayBadge;

/** 角标的背景颜色，默认红色 */
@property (nonatomic, strong) UIColor           *badgeBackgroundColor;

/** 角标的文字颜色，默认白色 */
@property (nonatomic, strong) UIColor           *badgeTitleColor;

/** 角标的文字字体，默认12 */
@property (nonatomic, strong) UIFont            *badgeTitleFont;

/** 角标的圆角大小，默认3 */
@property (nonatomic, assign) CGFloat           badgeCornerRadius;

/** 角标文本的缩进默认，5，5，5，5 */
@property (nonatomic, assign) UIEdgeInsets      badgeTitleInsets;

/** 角标的偏移，默认（0, 0） */
@property (nonatomic, assign) CGPoint           badgeOffset;

/// 获取展示的size
- (CGFloat)widthWithItemSpace:(CGFloat)space;



@end



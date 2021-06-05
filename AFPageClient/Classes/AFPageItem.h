//
//  AFPageItem.h
//  AFPageClient
//
//  Created by alfie on 2020/8/31.
//

#import <Foundation/Foundation.h>
#import "AFPageItemBadge.h"

@interface AFPageItem : NSObject

/** 控制器 */
@property (nonatomic, strong) UIViewController  *childViewController;

/** 是否可以横向滚动，默认true */
@property (assign, nonatomic) BOOL              scrollEnable;

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

/** 角标 */
@property (nonatomic, strong) AFPageItemBadge   *badge;

/// 获取展示的size
- (CGFloat)widthWithItemSpace:(CGFloat)space;

@end



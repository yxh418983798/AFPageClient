//
//  AFSegmentItem.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <Foundation/Foundation.h>


@interface AFSegmentItem : NSObject

/** 指定itemSize，如果不设置 && 没有实现代理方法，默认自适应 */
@property (assign, nonatomic) CGSize   itemSize;

/** 文字行数 */
@property (assign, nonatomic) NSInteger numberOfLines;

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

/// 获取展示的size
- (CGFloat)widthWithItemSpace:(CGFloat)space;


/// 快捷构造数据源
+ (NSMutableArray <AFSegmentItem *> *)itemsWithTitles:(NSArray *)titles
                                       selectedTitles:(NSArray *)selectedTitles
                                            textColor:(UIColor *)textColor
                                    selectedTextColor:(UIColor *)selectedTextColor
                                                 font:(UIFont *)font
                                         selectedFont:(UIFont *)selectedFont;


/// 快捷构造数据源
//+ (NSMutableArray <AFSegmentItem *> *)itemsWithAttributedString:(NSAttributedString *)attributedString
//                                       selectedAttributedString:(NSAttributedString *)selectedAttributedString;



@end



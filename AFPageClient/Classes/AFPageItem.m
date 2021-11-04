//
//  AFPageItem.m
//  AFPageClient
//
//  Created by alfie on 2020/8/31.
//

#import "AFPageItem.h"

@interface AFPageItem () {
    UIFont *_font;
    UIFont *_selectedFont;
}

/** 是否第一次设置 */
@property (nonatomic, assign) BOOL              isInitial;

@end


@implementation AFPageItem

- (instancetype)init {
    if(self = [super init]) {
        
        self.font = [UIFont systemFontOfSize:14];
        self.selectedFont = [UIFont systemFontOfSize:15];
        self.textColor = UIColor.blackColor;
        self.selectedTextColor = UIColor.blackColor;
        self.backgroundColor = UIColor.whiteColor;
        self.isInitial = YES;
        self.scrollEnable = YES;
    }
    return self;
}


- (void)setSelectedFont:(UIFont *)selectedFont {
    _selectedFont = selectedFont;
    if (@available(iOS 8.2, *)) {
        NSArray *fontNames = [selectedFont.fontName componentsSeparatedByString:@"-"];
        if (fontNames.count == 2) {
            NSString *weight = fontNames.lastObject;
            if ([weight isEqualToString:@"Regular"]) {
                _selectedFontWeight = UIFontWeightRegular;
            } else if ([weight isEqualToString:@"Medium"]) {
                _selectedFontWeight = UIFontWeightMedium;
            } else if ([weight isEqualToString:@"Semibold"]) {
                _selectedFontWeight = UIFontWeightSemibold;
            } else if ([weight isEqualToString:@"Bold"]) {
                _selectedFontWeight = UIFontWeightBold;
            } else if ([weight isEqualToString:@"Heavy"]) {
                _selectedFontWeight = UIFontWeightHeavy;
            } else if ([weight isEqualToString:@"Black"]) {
                _selectedFontWeight = UIFontWeightBlack;
            } else if ([weight isEqualToString:@"Light"]) {
                _selectedFontWeight = UIFontWeightLight;
            } else if ([weight isEqualToString:@"Thin"]) {
                _selectedFontWeight = UIFontWeightThin;
            } else if ([weight isEqualToString:@"UltraLight"]) {
                _selectedFontWeight = UIFontWeightUltraLight;
            } else {
                _selectedFontWeight = UIFontWeightRegular;
            }
        }
    }
}


- (void)setFont:(UIFont *)font {
    _font = font;
    if (@available(iOS 8.2, *)) {
        NSArray *fontNames = [font.fontName componentsSeparatedByString:@"-"];
        if (fontNames.count == 2) {
            NSString *weight = fontNames.lastObject;
            if ([weight isEqualToString:@"Regular"]) {
                _fontWeight = UIFontWeightRegular;
            } else if ([weight isEqualToString:@"Medium"]) {
                _fontWeight = UIFontWeightMedium;
            } else if ([weight isEqualToString:@"Semibold"]) {
                _fontWeight = UIFontWeightSemibold;
            } else if ([weight isEqualToString:@"Bold"]) {
                _fontWeight = UIFontWeightBold;
            } else if ([weight isEqualToString:@"Heavy"]) {
                _fontWeight = UIFontWeightHeavy;
            } else if ([weight isEqualToString:@"Black"]) {
                _fontWeight = UIFontWeightBlack;
            } else if ([weight isEqualToString:@"Light"]) {
                _fontWeight = UIFontWeightLight;
            } else if ([weight isEqualToString:@"Thin"]) {
                _fontWeight = UIFontWeightThin;
            } else if ([weight isEqualToString:@"UltraLight"]) {
                _fontWeight = UIFontWeightUltraLight;
            } else {
                _fontWeight = UIFontWeightRegular;
            }
        }
    }
}

#pragma mark - Getter
- (UIFont *)selectedFont {
    if (!_selectedFont) return _font;
    return _selectedFont;
}

- (UIFont *)font {
    if (!_font) _font =[UIFont systemFontOfSize:14];
    return _font;
}


+ (NSMutableArray <AFPageItem *> *)itemsWithTitles:(NSArray *)titles
                                       selectedTitles:(NSArray *)selectedTitles
                                            textColor:(UIColor *)textColor
                                    selectedTextColor:(UIColor *)selectedTextColor
                                                 font:(UIFont *)font
                                         selectedFont:(UIFont *)selectedFont {
    NSMutableArray <AFPageItem *> *array = NSMutableArray.array;
    for (NSString *title in titles) {
        AFPageItem *item = AFPageItem.new;
        item.content = title;
        item.selectedContent = selectedTitles;
        item.textColor = textColor;
        item.selectedTextColor = selectedTextColor;
        item.font = font;
        item.selectedFont = selectedFont;
        [array addObject:item];
    }
    return array;
}


#pragma mark - 获取展示的size
- (CGFloat)widthWithItemSpace:(CGFloat)space {
    if (!CGSizeEqualToSize(self.itemSize, CGSizeZero)) return self.itemSize.width;
    
    if ([self.content isKindOfClass:NSString.class]) {
        // 字符串自适应
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = self.selectedFont;
        if (_lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = _lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        return [(NSString *)self.content boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:attr context:nil].size.width + space;
        
    } else if ([self.content isKindOfClass:NSAttributedString.class]) {
        
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = self.selectedFont;
        if (_lineBreakMode != NSLineBreakByWordWrapping) {
           NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
           paragraphStyle.lineBreakMode = _lineBreakMode;
           attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        return [[(NSAttributedString *)self.content string] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                      attributes:attr context:nil].size.width + space;
        
    } else if ([self.content isKindOfClass:UIView.class]) {
        return [(UIView *)self.content frame].size.width + space;
    } else if ([self.content isKindOfClass:UIImage.class]) {
        CGSize size = [(UIImage *)self.content size];
        return size.width + space;
    }
    return 0;
}



@end

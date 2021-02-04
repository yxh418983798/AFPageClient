//
//  AFPageItem.m
//  AFPageClient
//
//  Created by alfie on 2020/8/31.
//

#import "AFPageItem.h"

@implementation AFPageItem

- (instancetype)init {
    if(self = [super init]) {
        
        self.font = [UIFont systemFontOfSize:14];
        self.selectedFont = [UIFont systemFontOfSize:15];
        self.textColor = UIColor.blackColor;
        self.selectedTextColor = UIColor.blackColor;
        self.backgroundColor = UIColor.whiteColor;
        self.isInitial = YES;
    }
    return self;
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

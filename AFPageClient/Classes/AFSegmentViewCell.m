//
//  AFSegmentViewCell.m
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import "AFSegmentViewCell.h"
#import <Masonry/Masonry.h>
#import "AFPageItem.h"
#import <objc/runtime.h>

@interface UIFont (AFPageClient)

@end
@implementation UIFont (AFPageClient)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getClassMethod(UIFont.class, @selector(systemFontOfSize:weight:));
        Method swizzleMethod = class_getClassMethod(UIFont.class, @selector(af_systemFontOfSize:weight:));
        method_exchangeImplementations(originMethod, swizzleMethod);
    });
}

+ (UIFont *)af_systemFontOfSize:(CGFloat)fontSize weight:(UIFontWeight)weight {
    NSLog(@"-------------------------- 1111111 --------------------------");
    return [self af_systemFontOfSize:fontSize weight:weight];
}

@end


@interface AFPageItem ()
/** 是否第一次设置 */
@property (nonatomic, assign) BOOL              isInitial;
@end


@interface AFSegmentViewCell ()

/** itemView */
@property (nonatomic, strong) UIView          *itemView;

/** 文本 */
@property (nonatomic, weak) UILabel           *titleLb;

/** imageView */
@property (nonatomic, weak) UIImageView       *imageView;

/** 角标 */
@property (nonatomic, strong) UIView          *badgeView;

/** 角标文本 */
@property (nonatomic, strong) UILabel         *badgeLb;

/** 记录是否在动画 */
@property (nonatomic, assign) BOOL            isAnimating;

@end


@implementation AFSegmentViewCell

#pragma mark - UI
- (UILabel *)titleLb {
    if (!_titleLb) {
        UILabel *label = UILabel.new;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _titleLb = label;
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return _titleLb;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = UIImageView.new;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        _imageView = imageView;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
        }];
    }
    return _imageView;
}

- (UIView *)badgeView {
    if (!_badgeView) {
        _badgeView = UIView.new;
        [self.contentView addSubview:_badgeView];
    }
    return _badgeView;
}

- (UILabel *)badgeLb {
    if (!_badgeLb) {
        _badgeLb = UILabel.new;
        [self.badgeView addSubview:_badgeLb];
    }
    return _badgeLb;
}


#pragma mark - 选中状态
//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    if (self.item.isInitial) {
//        [self setContentSelected:selected];
//        self.item.isInitial = NO;
//    }
//}
- (void)setContentSelected:(BOOL)selected {
    if (!_item) return;
    
    id content;
    if (selected) {
        content = _item.selectedContent ?: _item.content;
    } else {
        content = _item.content;
    }

    if ([content isKindOfClass:NSString.class]) {
        self.titleLb.text = content;
        if (selected) {
            self.titleLb.font =  _item.selectedFont;
            self.titleLb.textColor = _item.selectedTextColor;
        } else {
            self.titleLb.font =  _item.font;
            self.titleLb.textColor = _item.textColor;
        }
    } else if ([content isKindOfClass:NSAttributedString.class]) {
        self.titleLb.attributedText = content;
    } else if ([content isKindOfClass:UIView.class]) {
        UIView *itemView = (UIView *)content;
        if (self.itemView != itemView) {
            [self.itemView removeFromSuperview];
            self.itemView = itemView;
            [self.contentView addSubview:self.itemView];
            [self.itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.offset(0);
                make.width.offset(self.itemView.frame.size.width);
                make.height.offset(self.itemView.frame.size.height);
            }];
        }
    } else if ([content isKindOfClass:UIImage.class]) {
        if (self.itemView != self.imageView) {
            [self.itemView removeFromSuperview];
            self.itemView = self.imageView;
        }
        self.imageView.image = content;
    }
}


#pragma mark - 绑定item
- (void)setItem:(AFPageItem *)item {
    _item = item;
    self.contentView.backgroundColor = item.backgroundColor;
    if ([item.content isKindOfClass:NSString.class]) {
        if (self.itemView != self.titleLb) {
            [self.itemView removeFromSuperview];
            self.itemView = self.titleLb;
            self.titleLb.lineBreakMode = item.lineBreakMode;
        }
        self.titleLb.text = item.content;
    } else if ([item.content isKindOfClass:NSAttributedString.class]) {
        if (self.itemView != self.titleLb) {
            [self.itemView removeFromSuperview];
            self.itemView = self.titleLb;
        }
        self.titleLb.lineBreakMode = item.lineBreakMode;
        self.titleLb.attributedText = item.content;
    } else if ([item.content isKindOfClass:UIView.class]) {
        UIView *itemView = (UIView *)item.content;
        if (self.itemView != itemView) {
            [self.itemView removeFromSuperview];
            self.itemView = (UIView *)item.content;
            [self.contentView addSubview:self.itemView];
            [self.itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.offset(0);
                make.width.offset(self.itemView.frame.size.width);
                make.height.offset(self.itemView.frame.size.height);
            }];
        }
    } else if ([item.content isKindOfClass:UIImage.class]) {
        if (self.itemView != self.imageView) {
            [self.itemView removeFromSuperview];
            self.itemView = self.imageView;
        }
        self.imageView.image = item.content;
    }
}

// 显示角标
- (void)displayBadge:(AFPageItemBadge *)badge {
    
    if (!badge.content) {
        // 隐藏角标
        if (_badgeView.superview) {
            [_badgeView removeFromSuperview];
            _badgeView = nil;
        }
    } else {
        // 显示小红点
        self.badgeView.layer.backgroundColor = badge.backgroundColor.CGColor;
        self.badgeView.layer.cornerRadius = badge.cornerRadius;
        self.badgeView.layer.masksToBounds = YES;
        self.badgeLb.text = badge.content;
        self.badgeLb.font = badge.font;
        self.badgeLb.textColor = badge.textColor;

        if (badge.content.length) {
            CGSize size = [badge.content boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName : badge.font}
                                                      context:nil].size;
            [self.badgeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.offset(badge.offset.x);
                make.top.offset(badge.offset.y);
                make.width.offset(size.width + badge.contentInsets.left + badge.contentInsets.right);
                make.height.offset(size.height + badge.contentInsets.top + badge.contentInsets.bottom);
            }];
            [self.badgeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.offset(-badge.contentInsets.right);
                make.left.offset(badge.contentInsets.left);
                make.centerY.offset(0);
            }];
        } else {
            [self.badgeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.offset(badge.offset.x);
                make.top.offset(badge.offset.y);
                make.width.height.offset(badge.cornerRadius * 2);
            }];
        }
    }
}


#pragma mark - 根据手势交互，更新字体大小和颜色
- (void)updateScrollPercent:(CGFloat)percent animated:(BOOL)animated {
    
    if (!self.titleLb.text.length) return;
    
    if (animated) {

        [UIView animateWithDuration:0.25 animations:^{
            self.titleLb.font = percent == 1 ? self.item.selectedFont : self.item.font;
            self.titleLb.textColor  = percent == 1 ? self.item.selectedTextColor : self.item.textColor;
        }];
        
    } else {
        if (self.item.selectedFont) {
            if (percent >= 1) {
                self.titleLb.font = self.item.selectedFont;
            } else if (percent <= 0) {
                self.titleLb.font = self.item.font;
            } else {
                CGFloat selectedPointSize = self.item.selectedFont.pointSize;
                CGFloat normalPointSize = self.item.font.pointSize;
                
                if (self.item.fontWeight == self.item.selectedFontWeight) {
                    self.titleLb.font = [self.titleLb.font fontWithSize:normalPointSize + (selectedPointSize - normalPointSize) * percent];
                } else {
                    if ([self.item.selectedFont.familyName isEqualToString:@".AppleSystemUIFont"]) {
                        if (@available(iOS 8.2, *)) {
                            self.titleLb.font = [UIFont systemFontOfSize:normalPointSize + (selectedPointSize - normalPointSize) *  percent weight:self.item.fontWeight + (self.item.selectedFontWeight - self.item.fontWeight) * percent];
                        }
                    } else {
                        if (percent > 0.5) {
                            self.titleLb.font = [self.item.selectedFont fontWithSize:normalPointSize + (selectedPointSize - normalPointSize) * percent];
                        } else {
                            self.titleLb.font = [self.item.font fontWithSize:normalPointSize + (selectedPointSize - normalPointSize) * percent];
                        }
                    }
                }
            }
        }
        if (self.item.selectedTextColor) {
            CGFloat startR,startG,startB,startA,endR,endG,endB,endA;
            [self.item.textColor getRed:&startR green:&startG blue:&startB alpha:&startA];
            [self.item.selectedTextColor getRed:&endR green:&endG blue:&endB alpha:&endA];
            self.titleLb.textColor = [UIColor colorWithRed:startR + (endR - startR) * percent green:startG + (endG - startG) * percent blue:startB + (endB - startB) * percent alpha:startA + (endA - startA) * percent];
        }
    }
}

/// 兼容暗黑模式
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    self.titleLb.textColor = self.selected ? self.item.selectedTextColor : self.item.textColor;
}

@end

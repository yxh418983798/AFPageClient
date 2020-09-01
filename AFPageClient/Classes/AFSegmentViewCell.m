//
//  AFSegmentViewCell.m
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import "AFSegmentViewCell.h"
#import <Masonry/Masonry.h>
#import "AFPageItem.h"

@interface AFSegmentViewCell ()

/** itemView */
@property (nonatomic, strong) UIView          *itemView;

/** 文本 */
@property (nonatomic, weak) UILabel           *titleLb;

/** imageView */
@property (nonatomic, weak) UIImageView       *imageView;

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


#pragma mark - 是否选中状态
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (!_item) return;
    
    id content;
    if (selected) {
        content = _item.selectedContent ?: _item.content;
    } else {
        content = _item.content;
    }

    if ([content isKindOfClass:NSString.class]) {
        self.titleLb.text = content;
        [self setTitleSelected:selected];
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

- (void)setTitleSelected:(BOOL)selected {
    if (selected) {
        self.titleLb.font =  _item.selectedFont;
        self.titleLb.textColor = _item.selectedTextColor;
    } else {
        self.titleLb.font =  _item.font;
        self.titleLb.textColor = _item.textColor;
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

@end

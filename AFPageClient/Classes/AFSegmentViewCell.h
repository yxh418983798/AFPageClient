//
//  AFSegmentViewCell.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <UIKit/UIKit.h>
@class AFPageItem;
@class AFPageItemBadge;

@interface AFSegmentViewCell : UICollectionViewCell

/** 布局样式 */
@property (strong, nonatomic) AFPageItem        *item;

@property (copy, nonatomic) id                  title;

@property (copy, nonatomic) id                  selectTitle;

/** indexPath */
@property (nonatomic, strong) NSIndexPath       *indexPath;

/// 根据手势交互，更新字体大小和颜色
- (void)updateScrollPercent:(CGFloat)percent animated:(BOOL)animated;

// 显示角标
- (void)displayBadge:(AFPageItemBadge *)badge;

- (void)setContentSelected:(BOOL)selected;

@end



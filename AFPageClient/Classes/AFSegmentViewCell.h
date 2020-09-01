//
//  AFSegmentViewCell.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <UIKit/UIKit.h>
@class AFPageItem;

@interface AFSegmentViewCell : UICollectionViewCell

/** 布局样式 */
@property (strong, nonatomic) AFPageItem        *item;

@property (copy, nonatomic) id                  title;

@property (copy, nonatomic) id                  selectTitle;

@end



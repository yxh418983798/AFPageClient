//
//  AFSegmentViewCell.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <UIKit/UIKit.h>
@class AFSegmentItem;

@interface AFSegmentViewCell : UICollectionViewCell

/** 布局样式 */
@property (strong, nonatomic) AFSegmentItem      *item;

@property (copy, nonatomic) id                  title;

@property (copy, nonatomic) id                  selectTitle;

@end



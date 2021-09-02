//
//  AFPageCollectionView.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <UIKit/UIKit.h>
#import "AFPageItem.h"

@interface AFPageCollectionView : UICollectionView 

@end


@interface AFPageCollectionViewCell : UICollectionViewCell

/** AFPageItem */
@property (nonatomic, weak) AFPageItem            *item;

@end


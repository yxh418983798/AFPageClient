#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AFCollectionViewFlowLayout.h"
#import "AFPageClient.h"
#import "AFPageCollectionView.h"
#import "AFPageItem.h"
#import "AFPageItemBadge.h"
#import "AFPageScrollBar.h"
#import "AFPageTableView.h"
#import "AFScrollViewProxy.h"
#import "AFSegmentConfiguration.h"
#import "AFSegmentView.h"
#import "AFSegmentViewCell.h"

FOUNDATION_EXPORT double AFPageClientVersionNumber;
FOUNDATION_EXPORT const unsigned char AFPageClientVersionString[];


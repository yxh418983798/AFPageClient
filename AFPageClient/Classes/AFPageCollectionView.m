//
//  AFPageCollectionView.m
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import "AFPageCollectionView.h"

@implementation AFPageCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self.delegate performSelector:@selector(gestureRecognizerShouldBegin:) withObject:gestureRecognizer];
}

@end

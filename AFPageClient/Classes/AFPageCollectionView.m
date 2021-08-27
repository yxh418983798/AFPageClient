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

//- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIPanGestureRecognizer *)otherGestureRecognizer {
//    if (otherGestureRecognizer.view != self && [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class] && [otherGestureRecognizer.view isKindOfClass:UIScrollView.class]) {
//        return YES;
//    }
//    return NO;
//}



@end

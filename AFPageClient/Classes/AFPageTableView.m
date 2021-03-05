//
//  AFPageTableView.m
//  AFPageClient
//
//  Created by alfie on 2021/3/5.
//

#import "AFPageTableView.h"

@implementation AFPageTableView


- (void)handlePan:(UIPanGestureRecognizer *)pan {

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"-------------------------- 11 --------------------------");
    return YES;
}

@end

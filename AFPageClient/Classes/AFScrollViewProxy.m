//
//  AFScrollViewProxy.m
//  AFPageClient
//
//  Created by alfie on 2021/2/25.
//

#import "AFScrollViewProxy.h"

@interface AFScrollViewProxy () <UIScrollViewDelegate>

/** UIScrollView */
@property (nonatomic, weak) UIScrollView      *scrollView;

/** 手势是否触发在content上 */
@property (nonatomic, assign) BOOL            isTouchContent;

/** 代理 */
@property (nonatomic, weak) id <AFScrollViewProxyDelegate>  proxyDelegate;

@end


@implementation AFScrollViewProxy

#pragma mark - 构造
+ (instancetype)proxyWithScrollView:(UIScrollView *)scrollView delegate:(id<AFScrollViewProxyDelegate>)delegate {
    
    AFScrollViewProxy *proxy = AFScrollViewProxy.new;
    proxy.contentSize = CGSizeMake(1, 10000);
    proxy.alwaysBounceHorizontal = NO;
    proxy.delegate = proxy;
    proxy.proxyDelegate = delegate;
    proxy.scrollView = scrollView;
    for (UIGestureRecognizer *pan in scrollView.gestureRecognizers) {
        if ([pan isKindOfClass:[UIPanGestureRecognizer class]]) {
            pan.enabled = NO;
        }
    }
    // 手势转移
    UIPanGestureRecognizer *pan = proxy.panGestureRecognizer;
    if (pan && [proxy.gestureRecognizers containsObject:pan]) {
        [proxy removeGestureRecognizer:pan];
        [scrollView addGestureRecognizer:pan];
    }
    if (@available(iOS 11.0, *)) {
        proxy.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return proxy;
}


#pragma mark - 获取header_H
- (CGFloat)header_H {
    if ([self.scrollView isKindOfClass:UITableView.class]) {
        return [(UITableView *)self.scrollView tableHeaderView].frame.size.height;
    }
    return 0.f;
}


#pragma mark - 手势拦截，保持与当前的子ScrollView数据同步
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    self.isTouchContent = [self.proxyDelegate isTouchContentInLocation:[gestureRecognizer locationInView:gestureRecognizer.view]];
    UIScrollView *currentScrollView = self.proxyDelegate.childScrollViewForCurrentIndex;
    CGFloat content_H = self.scrollView.contentSize.height; //contentSize的最小值
    content_H = fmax(content_H, self.header_H + currentScrollView.contentSize.height);
    self.contentSize = CGSizeMake(self.contentSize.width, content_H);
    NSLog(@"手势拦截 --%@, proxy:%@ \n scrollView:%@ \n currentScrollView:%@", NSStringFromCGPoint([gestureRecognizer velocityInView:gestureRecognizer.view]), self, self.scrollView, currentScrollView);
    self.contentOffset = CGPointMake(self.contentOffset.x, self.scrollView.contentOffset.y + currentScrollView.contentOffset.y);

    return YES; 
}


#pragma mark - 监听滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIScrollView *currentScrollView = self.proxyDelegate.childScrollViewForCurrentIndex;
    UIScrollView *pullScrollView = self.proxyDelegate.scrollViewForPull;
    CGFloat offY = self.contentOffset.y;
    CGFloat distance = offY - self.scrollView.contentOffset.y - currentScrollView.contentOffset.y; // 滑动距离，距离 == 0，不需要处理
    /// 距离 > 0，代表上滑
    if (distance > 0) {
        // 1、如果currentScrollView 处于负值，则滚动currentScrollView
        if (currentScrollView.contentOffset.y < 0) {
            CGFloat result = offY - self.scrollView.contentOffset.y;
            if (pullScrollView == self.scrollView) {
                currentScrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, fmax(0.f, result)); // 这里的滚动不能让结果 > 0
                if (result > 0) {
                    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, offY);
                }
            } else {
                // 弹性反弹
                currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, result);
            }
        }
        // 2、判断外层的偏移量有没有超出头部高度
        else {
            if (self.scrollView.contentOffset.y < self.header_H) {
                // 如果外层没有超出头部，直接滚动最外层的tableView
//                NSLog(@"上滑滚动外层 -- offY:%f \n proxy:%@ \n scrollView:%@ \n ", offY, self, self.scrollView);
                CGFloat result = offY - currentScrollView.contentOffset.y; // 这里的滚动不能让结果超出头部
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, fmin(result, self.header_H));
                if (result > self.header_H) {
                    currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, offY - self.header_H);
                }
            } else {
                // 超出头部，滚动当前index的子scrollView
//                NSLog(@"上滑滚动子Scroll -- offY:%f \n proxy:%@ \n scrollView:%@ \n currentScrollView:%@", offY, self, self.scrollView, currentScrollView);
                if (self.scrollView.contentOffset.y > self.header_H) {
                    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.header_H);
                }
                currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, offY - self.header_H);
            }
        }
    }
        
    /// 距离 < 0，代表下拉
    else if (distance < 0) {
        // 优先滚动内层
        if (self.isTouchContent) {
            if (currentScrollView.contentOffset.y > 0) {
                // 内层偏移量 > 0
                CGFloat result = offY - self.scrollView.contentOffset.y;
                if (result < 0) {
                    // 得出的内层结果 < 0
                    if (offY < 0) {
                        // 下拉刷新的情况
                        if (pullScrollView == self.scrollView) {
                            currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, 0);
                            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, offY);
                        } else {
                            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
                            currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, offY);
                        }
                    } else {
                        // 没到下拉刷新，则设置内层为0，继续滚动外层
                        currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, 0);
                        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, offY);
                    }
                } else {
                    // 得出的内层结果 >= 0，直接滚动内层
                    currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, result);
                }

            } else {
                // 内层偏移量 <= 0，判断外层的偏移量
                if (self.scrollView.contentOffset.y > 0) {
                    // 如果外层偏移量 > 0，直接滚动最外层的tableView
//                    NSLog(@"下拉滚动外层 -- offY:%f \n proxy:%@ \n scrollView:%@ \n ", offY, self, self.scrollView);
                    CGFloat result = offY - currentScrollView.contentOffset.y;
                    if (result < 0 && pullScrollView != self.scrollView) {
                        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
                        currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, offY);
                    } else {
                        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, result);
                    }
                } else {
                    // 如果外层偏移量 <= 0，滚动pullScrollView
                    if (pullScrollView == self.scrollView) {
                        currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, 0);
                        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, offY);
                    } else {
                        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
//                        NSLog(@"下拉滚动子Scroll -- offY:%f \n proxy:%@ \n scrollView:%@ \n currentScrollView:%@", offY, self, self.scrollView, currentScrollView);
                        currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, offY);
                    }
                }
            }
        }
        
        /// 优先滚动外层
        else {
            // 判断外层的偏移量
            if (self.scrollView.contentOffset.y > 0) {
                // 如果外层偏移量 > 0，直接滚动最外层的tableView
//                NSLog(@"下拉滚动外层 -- offY:%f \n proxy:%@ \n scrollView:%@ \n ", offY, self, self.scrollView);
                CGFloat result = offY - currentScrollView.contentOffset.y;
                if (result < 0 && pullScrollView != self.scrollView) {
                    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
                    currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, offY);
                } else {
                    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, result);
                }
            } else {
                // 如果外层偏移量 <= 0，继续判断内层的偏移量
                if (currentScrollView.contentOffset.y > 0) {
                    // 内层偏移量 > 0
                    CGFloat result = offY - self.scrollView.contentOffset.y;
                    if (result < 0) {
                        // 得出的内层结果 < 0，继续判断下拉刷新的情况
                        if (pullScrollView == self.scrollView) {
                            currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, 0);
                            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, offY);
                        } else {
                            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
                            currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, offY);
                        }
                    } else {
                        // 得出的内层结果 >= 0，直接滚动内层
                        currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, result);
                    }
                } else {
                    // 内层偏移量 <= 0，滚动pullScrollView
                    if (pullScrollView == self.scrollView) {
                        currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, 0);
                        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, offY);
                    } else {
                        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
//                        NSLog(@"下拉滚动子Scroll -- offY:%f \n proxy:%@ \n scrollView:%@ \n currentScrollView:%@", offY, self, self.scrollView, currentScrollView);
                        currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, offY);
                    }
                }
            }
        }
    }
}


@end

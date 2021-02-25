//
//  AFScrollViewProxy.m
//  AFPageClient
//
//  Created by alfie on 2021/2/25.
//

#import "AFScrollViewProxy.h"

@interface AFChildScrollViewModel : NSObject
@property (nonatomic, strong) UIScrollView         *scrollView;
@property (nonatomic, assign) NSInteger            index;
@end

@implementation AFChildScrollViewModel

+ (instancetype)modelWithScrollView:(UIScrollView *)scrollView index:(NSInteger)index {
    AFChildScrollViewModel *model = AFChildScrollViewModel.new;
    model.scrollView = scrollView;
    model.index = index;
    return model;
}

@end



@interface AFPageScrollView : UIScrollView

@end

@implementation AFPageScrollView

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if ([self.responseDelegate respondsToSelector:@selector(view:gestureRecognizerShouldBegin:)]) {
//        return [self.responseDelegate view:self gestureRecognizerShouldBegin:gestureRecognizer];
//    }
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return self.gestureShouldRecognizer;
//}
@end


@interface AFScrollViewProxy () <UIScrollViewDelegate>

/** 子数据源 */
@property (nonatomic, strong) NSMutableDictionary  *data;

/** UIScrollView */
@property (nonatomic, weak) UIScrollView           *scrollView;

@end

@implementation AFScrollViewProxy

#pragma mark - 构造
+ (instancetype)proxyWithScrollView:(UIScrollView *)scrollView {
    
    AFScrollViewProxy *proxy = AFScrollViewProxy.new;
    proxy.delegate = proxy;
    proxy.scrollView = scrollView;
    proxy.data = NSMutableDictionary.dictionary;
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
    return proxy;
}


#pragma mark - 添加子ScrollView
- (void)addChildScrollView:(UIScrollView *)childScrollView atIndex:(NSInteger)index {
    AFChildScrollViewModel *model = [self modelAtIndex:index];
    if (!model) {
        model = [AFChildScrollViewModel modelWithScrollView:childScrollView index:index];
        [self.data setValue:model forKey:[NSString stringWithFormat:@"AFChildScrollViewModelIndex_%ld", index]];
        if (childScrollView.panGestureRecognizer) {
            [childScrollView removeGestureRecognizer:childScrollView.panGestureRecognizer];
        }
    }
}


#pragma mark - 获取model
- (AFChildScrollViewModel *)modelAtIndex:(NSInteger)index {
    return [self.data valueForKey:[NSString stringWithFormat:@"AFChildScrollViewModelIndex_%ld", index]];
}

- (CGFloat)header_H {
    if ([self.scrollView isKindOfClass:UITableView.class]) {
        return [(UITableView *)self.scrollView tableHeaderView].frame.size.height;
    }
    return 0.f;
}


#pragma mark - 手势拦截，保持与当前的子ScrollView数据同步
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIScrollView *currentScrollView = self.proxyDelegate.childScrollViewForCurrentIndex;
    CGFloat content_H = self.scrollView.contentSize.height; //contentSize的最小值
    content_H = fmax(content_H, self.header_H + currentScrollView.contentSize.height);
    self.contentSize = CGSizeMake(self.contentSize.width, content_H);
    self.contentOffset = CGPointMake(self.contentOffset.x, self.scrollView.contentOffset.y + currentScrollView.contentOffset.y);
    return YES;
}


#pragma mark - 监听滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offY = self.contentOffset.y;
    if (offY >= 0) {
        if (offY <= self.header_H) {
            // 没有超出头部，直接滚动最外层的tableView
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, offY);
        } else {
            // 超出头部，滚动当前index的子scrollView
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.header_H);
            UIScrollView *currentScrollView = self.proxyDelegate.childScrollViewForCurrentIndex;
            currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, offY - self.header_H);
        }
    } else {
        // 获取下拉对应的ScrollView
        UIScrollView *pullScrollView = self.proxyDelegate.scrollViewForPull;
        pullScrollView.contentOffset = CGPointMake(pullScrollView.contentOffset.x, offY);
        if (pullScrollView == self.scrollView) {
            UIScrollView *currentScrollView = self.proxyDelegate.childScrollViewForCurrentIndex;
            currentScrollView.contentOffset = CGPointMake(currentScrollView.contentOffset.x, 0);
        } else {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
        }
    }
}


@end

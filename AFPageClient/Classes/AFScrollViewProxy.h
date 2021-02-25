//
//  AFScrollViewProxy.h
//  AFPageClient
//
//  Created by alfie on 2021/2/25.
//

#import <Foundation/Foundation.h>

@protocol AFScrollViewProxyDelegate <NSObject>

- (UIScrollView *)childScrollViewForCurrentIndex;

- (UIScrollView *)scrollViewForPull;

@end


@interface AFScrollViewProxy : UIScrollView

/** 代理 */
@property (nonatomic, weak) id <AFScrollViewProxyDelegate>  proxyDelegate;

+ (instancetype)proxyWithScrollView:(UIScrollView *)scrollView;

- (void)addChildScrollView:(UIScrollView *)childScrollView atIndex:(NSInteger)index;

@end






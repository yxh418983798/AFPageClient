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

- (BOOL)isTouchContentInLocation:(CGPoint)location;

@end


@interface AFScrollViewProxy : UIScrollView

+ (instancetype)proxyWithScrollView:(UIScrollView *)scrollView delegate:(id <AFScrollViewProxyDelegate>)delegate;

@end








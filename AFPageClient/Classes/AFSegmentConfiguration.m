//
//  AFSegmentConfiguration.m
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import "AFSegmentConfiguration.h"

@implementation AFSegmentConfiguration

- (instancetype)init {
    if(self = [super init]) {
        _showBottomLine = NO;
        _animatedEnable = YES;
        self.backgroundColor = UIColor.whiteColor;
        self.lineColor = UIColor.grayColor;
        self.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 45);
        self.itemSpace = 25.f;
        
        _showScrollBar = YES;
        _scrollBarAnimated = YES;
        self.scrollBar_minW = 6.f;
        self.scrollBar_maxW = 60.f;
        self.scrollBar_H = 6.f;
        self.scrollBarColor = [UIColor colorWithRed:0 green:0.827 blue:0.58 alpha:1];

    }
    return self;
}

@end

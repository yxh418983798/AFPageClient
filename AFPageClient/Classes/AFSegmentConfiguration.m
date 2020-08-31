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
        _showScrollBar = YES;
        _showBottomLine = YES;
        _adjustEnable = YES;
        
        self.backgroundColor = UIColor.whiteColor;
        self.lineColor = UIColor.grayColor;
        
        self.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 45);
        self.shouldFill = YES;
        self.itemSpace = 25.f;
    }
    return self;
}

@end

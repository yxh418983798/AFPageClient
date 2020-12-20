//
//  AFPageItemBadge.m
//  AFPageClient
//
//  Created by alfie on 2020/12/20.
//

#import "AFPageItemBadge.h"

@implementation AFPageItemBadge


- (instancetype)init {
    if(self = [super init]) {
        self.textColor = UIColor.whiteColor;
        self.font = [UIFont systemFontOfSize:10];
        self.cornerRadius = 3.f;
        self.backgroundColor = UIColor.redColor;
        self.contentInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    }
    return self;
}

@end

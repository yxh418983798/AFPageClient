//
//  AFPageScrollBar.m
//  AFPageClient
//
//  Created by alfie on 2020/8/31.
//

#import "AFPageScrollBar.h"


typedef NS_ENUM(NSInteger, AFPageScrollBarStatus)  {
    AFPageScrollBarStatusNormal,    /// 普通状态
    AFPageScrollBarStatusStretch,   /// 拉长
    AFPageScrollBarStatusMove,      /// 移动
    AFPageScrollBarStatusShorten,   /// 缩短
};

typedef NS_ENUM(NSInteger, AFPageScrollBarDirection)  {
    AFPageScrollBarDirectionUnknow,  /// 未知
    AFPageScrollBarDirectionLeft,    /// 左滑
    AFPageScrollBarDirectionRight,   /// 右滑
};


@interface AFPageScrollBar ()

/** displayLink */
@property (strong, nonatomic) CADisplayLink      *displayLink;

/** 起始值 */
@property (nonatomic, assign) CGFloat            fromValue;

/** 结束值 */
@property (nonatomic, assign) CGFloat            toValue;

/** 状态 */
@property (nonatomic, assign) AFPageScrollBarStatus            status;

/** 方向 */
@property (nonatomic, assign) AFPageScrollBarDirection         direction;

@end


@implementation AFPageScrollBar

static CGFloat Min_W = 6.f;
static CGFloat Max_W = 60.f;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:0 green:0.827 blue:0.58 alpha:1];
    }
    return self;
}

/// 定时器
- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerAction)];
        _displayLink.frameInterval = 1;
    }
    return _displayLink;
}


#pragma mark - 动画
- (void)scrollFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue {
    if (fabs(fromValue - toValue) < 5 && self.status == AFPageScrollBarStatusNormal) return;
    self.fromValue = fromValue;
    self.toValue = toValue;
    if (_toValue > _fromValue) {
        self.direction = AFPageScrollBarDirectionRight;
    } else if (_toValue < fromValue) {
        self.direction = AFPageScrollBarDirectionLeft;
    } else {
        
    }
    
    if (self.frame.size.width < Max_W) {
        if (_toValue < _fromValue && self.frame.origin.x <= _toValue) {
            self.status = AFPageScrollBarStatusShorten;
        } else if (_toValue > _fromValue && self.frame.origin.x + self.frame.size.width >= _toValue) {
            self.status = AFPageScrollBarStatusShorten;
        } else if (fabs(fromValue - toValue) > 0.1) {
            self.status = AFPageScrollBarStatusStretch;
        }
    } else {
        self.status = AFPageScrollBarStatusMove;
    }
    if (!_displayLink) {
        [self.displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
    }
}


- (void)timerAction {
//    CGFloat distance = fmax(fabs(_toValue - _fromValue)/100, 0.2);
    CGFloat distance = fmax(fabs(_toValue - _fromValue)/15, 3.f);
    CGRect frame = self.frame;
    // 右滑
    if (self.direction == AFPageScrollBarDirectionRight) {
        switch (self.status) {
            case AFPageScrollBarStatusStretch:
                if (frame.origin.x + frame.size.width >= _toValue) {
                    self.status = AFPageScrollBarStatusShorten;
                    break;
                }
                frame.size.width = fmin(frame.size.width + distance, Max_W);
                if (frame.size.width >= Max_W) {
                    self.status = AFPageScrollBarStatusMove;
                }
                break;
            case AFPageScrollBarStatusMove:
                frame.origin.x = fmin(frame.origin.x + distance, _toValue - Max_W);
                if (frame.origin.x + frame.size.width >= _toValue) {
                    self.status = AFPageScrollBarStatusShorten;
                }
                break;
            case AFPageScrollBarStatusShorten:
                frame.size.width = fmax(frame.size.width - distance, Min_W);
                frame.origin.x = _toValue - frame.size.width;
                if (frame.size.width <= Min_W) {
                    self.status = AFPageScrollBarStatusNormal;
                    [_displayLink invalidate];
                    _displayLink = nil;
                }
                break;
            default:
                [_displayLink invalidate];
                _displayLink = nil;
                return;
        }
        self.frame = frame;
    }
    // 左滑
    else if (self.direction == AFPageScrollBarDirectionLeft) {
        switch (self.status) {
            case AFPageScrollBarStatusStretch:
                if (frame.origin.x <= _toValue) {
                    self.status = AFPageScrollBarStatusShorten;
                    break;
                }
                frame.size.width = fmin(frame.size.width + distance, Max_W);
                frame.origin.x = _fromValue - frame.size.width;
                if (frame.size.width >= Max_W) {
                    self.status = AFPageScrollBarStatusMove;
                }
                break;
            case AFPageScrollBarStatusMove:
                frame.origin.x = fmax(frame.origin.x - distance, _toValue);
                if (frame.origin.x <= _toValue) {
                    self.status = AFPageScrollBarStatusShorten;
                }
                break;
            case AFPageScrollBarStatusShorten:
                frame.origin.x = _toValue;
                frame.size.width = fmax(frame.size.width - distance, Min_W);
                if (frame.size.width <= Min_W) {
                    self.status = AFPageScrollBarStatusNormal;
                    [_displayLink invalidate];
                    _displayLink = nil;
                }
                break;
            default:
                [_displayLink invalidate];
                _displayLink = nil;
                return;
        }
        self.frame = frame;
    }
    /// 相等
    else {
        switch (self.status) {
            case AFPageScrollBarStatusStretch:
                if (frame.origin.x <= _toValue) {
                    self.status = AFPageScrollBarStatusShorten;
                    break;
                }
                frame.size.width = fmin(frame.size.width + distance, Max_W);
                frame.origin.x = _fromValue - frame.size.width;
                if (frame.size.width >= Max_W) {
                    self.status = AFPageScrollBarStatusMove;
                }
                break;
            case AFPageScrollBarStatusMove:
                frame.origin.x = fmax(frame.origin.x - distance, _toValue);
                if (frame.origin.x <= _toValue) {
                    self.status = AFPageScrollBarStatusShorten;
                }
                break;
            case AFPageScrollBarStatusShorten:
                frame.origin.x = _toValue;
                frame.size.width = fmax(frame.size.width - distance, Min_W);
                if (frame.size.width <= Min_W) {
                    self.status = AFPageScrollBarStatusNormal;
                    [_displayLink invalidate];
                    _displayLink = nil;
                }
                break;
            default:
                [_displayLink invalidate];
                _displayLink = nil;
                return;
        }
        self.frame = frame;
    }
}


#pragma mark - 手势交互滑动，实时更新
- (void)interactionScrollFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue percent:(CGFloat)percent {

    AFPageScrollBarDirection direction;
    AFPageScrollBarStatus status = AFPageScrollBarStatusNormal;
    if (toValue > fromValue) {
        direction = AFPageScrollBarDirectionRight;
    } else if (toValue < fromValue) {
        direction = AFPageScrollBarDirectionLeft;
    } else {
        return;
    }
    
    CGRect frame = self.frame;
    CGFloat stretchPercent = fabs((Max_W - Min_W)/(toValue - fromValue));
    CGFloat shortenPercent = 1 - stretchPercent;

    if (percent < stretchPercent) {
        // 拉伸
        frame.size.width = fmin(Min_W + (percent/stretchPercent) * (Max_W - Min_W), Max_W);
        if (toValue < fromValue) {
            frame.origin.x = fromValue - frame.size.width;
        }
    } else if (percent < shortenPercent) {
        // 移动
        if (toValue > fromValue) {
            frame.origin.x += fabs(toValue - fromValue) * (percent - stretchPercent)/(1 - stretchPercent);
        } else {
            frame.origin.x -= fabs(toValue - fromValue) * (percent - stretchPercent)/(1 - stretchPercent);
        }
    } else {
        // 缩短
        frame.size.width = fmax((Max_W - (percent - shortenPercent)/shortenPercent) * (Max_W - Min_W), Min_W);
        if (toValue > fromValue) {
            frame.origin.x = toValue - frame.size.width;
        }
    }
    self.frame = frame;
}



//- (void)dealloc {
//    NSLog(@"-------------------------- svrollbar释放 --------------------------");
//}
@end

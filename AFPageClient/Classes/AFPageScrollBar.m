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
    AFPageScrollBarDirectionBack,    /// 复位
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
    if (fabs(fromValue - toValue) < 5 && self.status == AFPageScrollBarStatusNormal) {
        if (self.frame.size.width == Min_W && self.frame.origin.x == toValue) {
            return;
        }
    }
    self.fromValue = fromValue;
    self.toValue = toValue;
    if (_toValue - _fromValue > 5) {
        self.direction = AFPageScrollBarDirectionRight;
    } else if (_toValue - fromValue < -5) {
        self.direction = AFPageScrollBarDirectionLeft;
    } else {
        self.direction = AFPageScrollBarDirectionBack;
        self.status = AFPageScrollBarStatusShorten;
        if (!_displayLink) [self.displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
        return;
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
                if (frame.origin.x + frame.size.width >= _toValue + Min_W) {
                    self.status = AFPageScrollBarStatusShorten;
                    break;
                }
                frame.size.width = fmin(frame.size.width + distance, Max_W);
                if (frame.size.width >= Max_W) {
                    self.status = AFPageScrollBarStatusMove;
                }
//                NSLog(@"-------------------------- 右滑拉伸：%g -- %g --------------------------", frame.origin.x, frame.size.width);
                break;
            case AFPageScrollBarStatusMove:
                frame.origin.x = fmin(frame.origin.x + distance, _toValue + Min_W - Max_W);
                frame.size.width =  Max_W;
                if (frame.origin.x + frame.size.width >= _toValue + Min_W) {
                    self.status = AFPageScrollBarStatusShorten;
                }
//                NSLog(@"-------------------------- 右滑移动：%g -- %g --------------------------", frame.origin.x, frame.size.width);
                break;
            case AFPageScrollBarStatusShorten:
                frame.size.width = fmax(frame.size.width - distance, Min_W);
                frame.origin.x = _toValue + Min_W - frame.size.width;
                if (frame.size.width <= Min_W) {
                    self.status = AFPageScrollBarStatusNormal;
                    [_displayLink invalidate];
                    _displayLink = nil;
                }
//                NSLog(@"-------------------------- 右滑缩短：%g -- %g --------------------------", frame.origin.x, frame.size.width);
                break;
            default:
                [_displayLink invalidate];
                _displayLink = nil;
//                NSLog(@"-------------------------- 右滑结束：%g -- %g --------------------------", frame.origin.x, frame.size.width);;
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
//                NSLog(@"-------------------------- 左滑拉伸：%g -- %g --------------------------", frame.origin.x, frame.size.width);
                break;
            case AFPageScrollBarStatusMove:
                frame.origin.x = fmax(frame.origin.x - distance, _toValue);
                frame.size.width =  Max_W;
                if (frame.origin.x <= _toValue) {
                    self.status = AFPageScrollBarStatusShorten;
                }
//                NSLog(@"-------------------------- 左滑移动：%g -- %g --------------------------", frame.origin.x, frame.size.width);
                break;
            case AFPageScrollBarStatusShorten:
                frame.origin.x = _toValue;
                frame.size.width = fmax(frame.size.width - distance, Min_W);
                if (frame.size.width <= Min_W) {
                    self.status = AFPageScrollBarStatusNormal;
                    [_displayLink invalidate];
                    _displayLink = nil;
                }
//                NSLog(@"-------------------------- 左滑缩短：%g -- %g --------------------------", frame.origin.x, frame.size.width);
                break;
            default:
                [_displayLink invalidate];
                _displayLink = nil;
//                NSLog(@"-------------------------- 左滑结束：%g -- %g --------------------------", frame.origin.x, frame.size.width);
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
//                NSLog(@"-------------------------- 复位拉伸：%g -- %g --------------------------", frame.origin.x, frame.size.width);
                break;
            case AFPageScrollBarStatusMove:
                frame.origin.x = fmax(frame.origin.x - distance, _toValue);
                frame.size.width =  Max_W;
                if (frame.origin.x <= _toValue) {
                    self.status = AFPageScrollBarStatusShorten;
                }
//                NSLog(@"-------------------------- 复位移动：%g -- %g --------------------------", frame.origin.x, frame.size.width);
                break;
            case AFPageScrollBarStatusShorten:
                frame.origin.x = _toValue;
//                frame.size.width = fmax(frame.size.width - distance, Min_W);
                frame.size.width = fmax(frame.size.width - distance, Min_W);
                if (frame.size.width <= Min_W) {
                    self.status = AFPageScrollBarStatusNormal;
                    [_displayLink invalidate];
                    _displayLink = nil;
                }
//                NSLog(@"-------------------------- 复位缩短：%g -- %g --------------------------", frame.origin.x, frame.size.width);
                break;
            default:
                [_displayLink invalidate];
                _displayLink = nil;
//                NSLog(@"-------------------------- 复位结束：%g -- %g --------------------------", frame.origin.x, frame.size.width);
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
    CGFloat totalDistance = fabs(toValue - fromValue) + Max_W - Min_W*2; // 总共要移动的距离
    CGFloat stretchPercent = (Max_W - Min_W)/totalDistance; // 整个伸长过程 要移动的距离百分比
    CGFloat shortenPercent = 1 - stretchPercent; // 开始缩短 所要移动的百分比
 
    if (percent < stretchPercent) {
        // 拉伸
//        NSLog(@"-------------------------- 拉伸：%g -- %g --------------------------", stretchPercent, shortenPercent);
        frame.size.width = fmin(Min_W + (percent/stretchPercent) * (Max_W - Min_W), Max_W);
        if (toValue < fromValue) {
            frame.origin.x = fromValue - frame.size.width;
        }
    } else if (percent < shortenPercent) {
        frame.size.width =  Max_W;
        // 移动
        if (toValue > fromValue) {
            frame.origin.x = fromValue + (toValue - fromValue - Max_W) * (percent - stretchPercent)/(shortenPercent - stretchPercent);
        } else {
            frame.origin.x = fromValue - Max_W - (fromValue - toValue - Max_W) * (percent - stretchPercent)/(shortenPercent - stretchPercent);
        }
//        NSLog(@"-------------------------- 移动：%g -- %g -- %g--------------------------", stretchPercent, (percent - stretchPercent)/(shortenPercent - stretchPercent), frame.origin.x);
    } else {
        // 缩短
        frame.size.width = fmax(Max_W - (percent - shortenPercent)/stretchPercent * (Max_W - Min_W), Min_W);
        if (toValue > fromValue) {
            frame.origin.x = toValue - frame.size.width;
        }
//        NSLog(@"-------------------------- 缩短：%g -- %g -- %g--------------------------", stretchPercent, (percent - stretchPercent)/(shortenPercent - stretchPercent), frame.size.width);
    }
    self.frame = frame;
}


#pragma mark - 停止
- (void)stop {
    [_displayLink invalidate];
    _displayLink = nil;
}

//- (void)dealloc {
//    NSLog(@"-------------------------- svrollbar释放 --------------------------");
//}
@end

//
//  AFPageScrollBar.m
//  AFPageClient
//
//  Created by alfie on 2020/8/31.
//

#import "AFPageScrollBar.h"
#import "AFSegmentConfiguration.h"


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

/** 配置 */
@property (nonatomic, strong) AFSegmentConfiguration *configuration;

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

#define Min_W self.configuration.scrollBar_minW
#define Max_W self.configuration.scrollBar_maxW

#pragma mark - 生命周期
- (instancetype)initWithConfiguration:(AFSegmentConfiguration *)configuration {
    if (self = [super init]) {
        self.configuration = configuration;
        self.backgroundColor = self.configuration.scrollBarColor;
        self.layer.cornerRadius = configuration.scrollBar_H/2.f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

//- (void)dealloc {
//    NSLog(@"-------------------------- ScrollBar释放 --------------------------");
//}

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


#pragma mark - 定时器
- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerAction)];
        _displayLink.frameInterval = 1;
    }
    return _displayLink;
}

/// 停止定时器动画
- (void)stop {
    [_displayLink invalidate];
    _displayLink = nil;
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
                if (frame.origin.x < _toValue) {
                    frame.origin.x = _toValue;
                }
                if (frame.size.width >= Max_W) {
                    self.status = AFPageScrollBarStatusMove;
                }
//                NSLog(@"-------------------------- 左滑拉伸：%g -- %g --------------------------", frame.origin.x, frame.size.width);
                break;
            case AFPageScrollBarStatusMove:
                frame.origin.x = fmax(frame.origin.x - distance, _toValue);
                frame.size.width =  Max_W;
                if (frame.origin.x <= _toValue) {
                    frame.origin.x = _toValue;
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


#pragma mark - 滑动ScrollBar，实时更新
- (void)updatePrevious:(CGFloat)previous next:(CGFloat)next offsetPercent:(CGFloat)percent {
    
    if (next <= previous || percent < 0 || percent > 1) {
//        NSLog(@"-----------过滤异常 previous:%f -- next:%f -- percent：%f", previous, next, percent);
        return;
    }
    [self stop];
    
    CGRect frame = self.frame;
    CGFloat totalDistance = next - previous + Max_W - Min_W; // 移动一个item完整的距离
    CGFloat distance = totalDistance * percent; // 根据百分比计算出当前的距离
    /// 拉伸过程
    if (distance <= Max_W - Min_W) {
        frame.size.width = Min_W + distance;
        frame.origin.x = previous;
        self.frame = frame;
        return;
    }
    
    /// 移动过程
    if (distance <= next - previous) {
        frame.origin.x = previous + (distance - (Max_W - Min_W));
        frame.size.width = Max_W;
        self.frame = frame;
        return;
    }
    
    /// 缩短过程
    frame.size.width = Max_W - (distance - (next - previous));
    frame.origin.x = next + Min_W - frame.size.width;
    self.frame = frame;
}


@end

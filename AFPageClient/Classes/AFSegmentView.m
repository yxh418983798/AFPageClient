//
//  AFSegmentView.m
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import "AFSegmentView.h"
#import <Masonry/Masonry.h>
#import "AFSegmentViewCell.h"
#import "AFPageItem.h"
#import "AFSegmentConfiguration.h"
#import "AFCollectionViewFlowLayout.h"

#define ScrollBar_W self.configuration.scrollBar_minW

@interface AFSegmentView () <UICollectionViewDelegate, UICollectionViewDataSource, AFFlowLayoutDelegate>

/** collection */
@property (strong, nonatomic) UICollectionView              *collectionView;

/** 线条 */
@property (strong, nonatomic) UIView                    *lineView;

/** cellClass */
@property (strong, nonatomic) NSMutableArray            *cellClass;

/** 复用标识 */
@property (strong, nonatomic) NSMutableArray            *reuseIdentifier;

/** 布局属性 */
@property (strong, nonatomic) AFCollectionViewFlowLayout          *flowLayout;

@property (assign, nonatomic) NSInteger            before_last_index;

/** 记录自适应宽度的补充宽度 */
//@property (assign, nonatomic) CGFloat                   supplement_W;

@end


@implementation AFSegmentView

//- (void)dealloc {
//    NSLog(@"-------------------------- segmentView释放 --------------------------");
//}

#pragma mark - UI
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat collection_W = self.frame.size.width;
        if (self.leftView) collection_W -= self.leftView.frame.size.width;
        if (self.rightView) collection_W -= self.rightView.frame.size.width;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.leftView.frame.size.width, 0, collection_W, self.frame.size.height) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator   = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
//        _collectionView.gestureShouldRecognizer = YES;
        _collectionView.backgroundColor = self.configuration.backgroundColor;
        [_collectionView registerClass:[AFSegmentViewCell class] forCellWithReuseIdentifier:@"AFSegmentViewCell"];
        if (_cellClass.count) {
            for (int i = 0; i < _cellClass.count; i++) {
                [_collectionView registerClass:NSClassFromString(_cellClass[i]) forCellWithReuseIdentifier:_reuseIdentifier[i]];
            }
        }
    }
    return _collectionView;
}

- (AFPageScrollBar *)scrollBar {
    if (!_scrollBar) {
        _scrollBar = [[AFPageScrollBar alloc] initWithConfiguration:self.configuration];
    }
    return _scrollBar;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = self.configuration.lineColor;
        [self addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.bottom.offset(0);
            make.height.offset(0.5);
        }];
    }
    return _lineView;
}

#pragma mark - 数据
- (AFSegmentConfiguration *)configuration {
    if (!_configuration) {
        _configuration = AFSegmentConfiguration.new;
    }
    return _configuration;
}

- (AFCollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout= [[AFCollectionViewFlowLayout.new makeLayoutStyle:(AFFlowLayoutStyleWaterfallHorizantal)] makeNumberOfLines:1];
        _flowLayout.delegate = self;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = self.configuration.insets;
    }
    return _flowLayout;
}


#pragma mark - 刷新
- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)update {
    
    self.backgroundColor = self.configuration.backgroundColor;
    self.frame = self.configuration.frame;
    
    // leftView
    if (self.leftView && !self.leftView.superview) {
        [self addSubview:self.leftView];
        [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(0);
            make.centerY.offset(0);
            make.width.offset(self.leftView.frame.size.width);
            make.height.offset(self.leftView.frame.size.height);
        }];
    }
    
    // rightView
    if (self.rightView && !self.rightView.superview) {
        [self addSubview:self.rightView];
        [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.offset(0);
            make.centerY.offset(0);
            make.width.offset(self.rightView.frame.size.width);
            make.height.offset(self.rightView.frame.size.height);
        }];
    }
    
    // 分割线
    if (self.configuration.showBottomLine) {
        [self lineView];
    }
    
    // collectionView
    if (_collectionView) {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
        _flowLayout = nil;
        _current_index = _default_index;
    }
    
    [self.flowLayout attachAllLinesFixedSize:self.frame.size.height];
    [self insertSubview:self.collectionView atIndex:0];
    
//    if (self.configuration.adjustEnable) {
//        if (self.configuration.shouldFill) {
//            CGFloat width = 0.f;
//            for (NSString *title in self.titles) {
//                CGFloat title_W = [title widthForFont:self.configuration.selectedFont] + self.configuration.titleSpace;
//                width += title_W;
//            }
//            if (self.rightView) {
//                width += self.rightView.width;
//            }
//            self.collectionView.scrollEnabled = (width > self.width);
//            _supplement_W = (self.width - width)/self.titles.count;
//        }
//
////        self.collectionView.scrollEnabled = (self.titles.count > _style.adjustMaxCount);
//    } else {
//        self.collectionView.scrollEnabled = self.configuration.scrollEnable;
//    }

    //滚动条
    if (self.configuration.showScrollBar) {
        CGFloat cell_W = 0.f;
        AFPageItem *item = [self.delegate segmentView:self itemForSegmentAtIndex:0];
        if (CGSizeEqualToSize(item.itemSize, CGSizeZero)) {
            if (self.collectionView.scrollEnabled) {
                cell_W = [item widthWithItemSpace:self.configuration.itemSpace];
            } else {
                cell_W = (self.collectionView.frame.size.width - self.configuration.insets.left - self.configuration.insets.right)/[self.delegate numberOfItemsInSegmentView:self];
            }
        } else {
            cell_W = item.itemSize.width;
        }
        if (self.current_index == 0) {
            self.scrollBar.frame = CGRectMake(self.configuration.insets.left + (cell_W - ScrollBar_W)/2, self.collectionView.frame.size.height - self.configuration.scrollBar_H - self.configuration.scrollBar_bottomInset, ScrollBar_W, self.configuration.scrollBar_H);
        } else {
            dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.current_index inSection:0];
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:NO];
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                if (!cell) {
                    [self.collectionView layoutIfNeeded];
                    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                    self.scrollBar.frame = CGRectMake((cell_W - ScrollBar_W)/2 + cell.frame.origin.x, self.collectionView.frame.size.height - self.configuration.scrollBar_H - self.configuration.scrollBar_bottomInset, ScrollBar_W, self.configuration.scrollBar_H);
                } else {
                    self.scrollBar.frame = CGRectMake((cell_W - ScrollBar_W)/2 + cell.frame.origin.x, self.collectionView.frame.size.height - self.configuration.scrollBar_H - self.configuration.scrollBar_bottomInset, ScrollBar_W, self.configuration.scrollBar_H);
                }
            });
        }
        [self.collectionView addSubview:self.scrollBar];
        
    } else if (_lineView) {
        [_scrollBar removeFromSuperview];
        _scrollBar = nil;
    }
    
    if (self.configuration.showBottomLine) {
        [self lineView];
    } else {
        [_lineView removeFromSuperview];
        _lineView = nil;
    }
    
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.current_index inSection:0] animated:NO scrollPosition:(UICollectionViewScrollPositionNone)];
}

- (void)selectedAtIndex:(NSInteger)index  {
    if (!_collectionView) {
        self.current_index = index;
        return;
    }
    if (self.current_index == index) return;
    self.before_last_index = self.last_index;
    self.last_index = self.current_index;
    self.current_index = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
}


#pragma mark -- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate numberOfItemsInSegmentView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AFSegmentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AFSegmentViewCell" forIndexPath:indexPath];
    AFPageItem *item = [self.delegate segmentView:self itemForSegmentAtIndex:indexPath.item];
    item.frame = cell.frame;
    cell.item = item;
    [cell setContentSelected:(indexPath.item == self.current_index)];
    [cell displayBadge:item.badge];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.current_index == indexPath.item) {
        return;
    }
    self.before_last_index = self.last_index;
    self.last_index = self.current_index;
    self.current_index = indexPath.item;
    
    if (collectionView.scrollEnabled) {
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
    }
    if ([self.delegate respondsToSelector:@selector(segmentView:didSelectItemAtIndex:)]) {
        [self.delegate segmentView:self didSelectItemAtIndex:indexPath.item];
    }
}

/// 返回item的宽度
- (CGFloat)collectionViewLayout:(AFCollectionViewFlowLayout *)layout heightForItemFixedSize:(CGFloat)fixed_size atIndexPath:(NSIndexPath *)indexPath {
    
    // 没有实现协议，则返回item的指定size
    AFPageItem *item = [self.delegate segmentView:self itemForSegmentAtIndex:indexPath.item];
    if (!CGSizeEqualToSize(item.itemSize, CGSizeZero)) return item.itemSize.width;
    // 都没有指定的情况，则自适应size
    if (self.collectionView.scrollEnabled) {
        return [item widthWithItemSpace:self.configuration.itemSpace];
    } else {
//        if (self.configuration.adjustEnable) {
//            return [title widthForFont:self.configuration.selectedFont] + self.configuration.titleSpace + self.supplement_W;
//        } else {
            return (self.collectionView.frame.size.width - self.configuration.insets.left - self.configuration.insets.right)/[self.delegate numberOfItemsInSegmentView:self];
//        }
    }
}


- (CGSize)contentSizeForCollectionViewLayout:(AFCollectionViewFlowLayout *)layout adjustsSize:(CGSize)adjustsSize {
    return CGSizeMake(adjustsSize.width + 1, self.collectionView.frame.size.height);
}


#pragma mark - 监听滑动，实时更新UI
- (void)didScrollHorizontal:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width) {
        return;
    }
    
    // 更新字体大小和滚动条
    if (labs(self.current_index - self.last_index) > 1) {
        AFSegmentViewCell *toCell = (AFSegmentViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.current_index inSection:0]];
        AFSegmentViewCell *fromCell = (AFSegmentViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.last_index inSection:0]];
        [toCell updateScrollPercent:1 animated:self.configuration.animatedEnable];
        [fromCell updateScrollPercent:0 animated:self.configuration.animatedEnable];
        if (self.last_index != self.before_last_index && self.current_index != self.before_last_index) {
            // 防止前一个cell动画未完成就切换，需要对前一个cell进行复原操作
            AFSegmentViewCell *beforeLastCell = (AFSegmentViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.before_last_index inSection:0]];
            [beforeLastCell updateScrollPercent:0 animated:self.configuration.animatedEnable];
        }
        if (self.configuration.showScrollBar) {
            [self.scrollBar scrollFromValue:self.scrollBar.frame.origin.x toValue:toCell.frame.origin.x + (toCell.frame.size.width - ScrollBar_W)/2];
        }

    } else {
        CGFloat offX = scrollView.contentOffset.x - scrollView.frame.size.width * self.current_index;
        CGFloat percent = fabs(offX/scrollView.frame.size.width);
        CGFloat offsetPercent = percent;
        NSInteger previousIndex;
        NSInteger nextIndex;
        if (offX > 0) {
            previousIndex = self.current_index;
            nextIndex = fmin(self.current_index+1, [self.delegate numberOfItemsInSegmentView:self]);
        } else if (offX < 0) {
            previousIndex = fmax(self.current_index - 1, 0);
            nextIndex = self.current_index;
            offsetPercent = 1 - percent;
        } else {
            if (self.current_index >= self.last_index) {
                previousIndex = self.last_index;
                nextIndex = self.current_index;
                offsetPercent = 1;
            } else {
                previousIndex = self.current_index;
                nextIndex = self.last_index;
                offsetPercent = 0;
            }
        }
        if (nextIndex >= [self.delegate numberOfItemsInSegmentView:self] || nextIndex == previousIndex) {
            return;
        }
        AFSegmentViewCell *previousCell = (AFSegmentViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:previousIndex inSection:0]];
        CGRect previousFrame = previousCell ? previousCell.frame : [self.delegate segmentView:self itemForSegmentAtIndex:previousIndex].frame;

        AFSegmentViewCell *nextCell = (AFSegmentViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex inSection:0]];
        CGRect nextFrame = nextCell ? nextCell.frame : [self.delegate segmentView:self itemForSegmentAtIndex:nextIndex].frame;
        
        [self.scrollBar updatePrevious:CGRectGetMidX(previousFrame) - ScrollBar_W/2 next:CGRectGetMidX(nextFrame) - ScrollBar_W/2 offsetPercent:offsetPercent];
        [previousCell updateScrollPercent:1-offsetPercent animated:NO];
        [nextCell updateScrollPercent:offsetPercent animated:NO];
        
        if (self.last_index != self.before_last_index && self.current_index != self.before_last_index) {
            // 防止前一个cell动画未完成就切换，需要对前一个cell进行复原操作
            AFSegmentViewCell *beforeLastCell = (AFSegmentViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.before_last_index inSection:0]];
            [beforeLastCell updateScrollPercent:0 animated:NO];
        }
    }
}


@end




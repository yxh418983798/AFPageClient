//
//  AFSegmentView.m
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import "AFSegmentView.h"
#import <Masonry/Masonry.h>
#import "AFSegmentViewCell.h"
#import "AFSegmentItem.h"
#import "AFSegmentConfiguration.h"
#import "AFCollectionViewFlowLayout.h"

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

/** 记录自适应宽度的补充宽度 */
@property (assign, nonatomic) CGFloat                   supplement_W;


@end


@implementation AFSegmentView


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
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat collection_W = self.rightView ? self.frame.size.width - self.rightView.frame.size.width + self.configuration.rightOverSpace : self.frame.size.width;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, collection_W, self.frame.size.height) collectionViewLayout:self.flowLayout];
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


#pragma mark - 刷新
- (instancetype)update {
    
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
    
    self.flowLayout.sectionInset = self.configuration.insets;
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
//    if (self.configuration.showLine) {
//        CGFloat cell_W = 0.f;
//        if (CGSizeEqualToSize(self.configuration.itemSize, CGSizeZero)) {
//            if (self.collectionView.scrollEnabled) {
//                cell_W = [self.titles.firstObject widthForFont:self.configuration.selectedFont] + self.configuration.titleSpace;
//            } else {
//                cell_W =  (self.collectionView.width - self.configuration.insets.left - self.configuration.insets.right)/self.titles.count;
//            }
//        } else {
//            cell_W = self.configuration.itemSize.width;
//        }
//        self.lineView.frame = CGRectMake(self.configuration.insets.left + (cell_W  -  35)/2, self.collectionView.height - 7, 35, 2);
//        [self.collectionView addSubview:self.lineView];
//    } else if (_lineView) {
//        [_lineView removeFromSuperview];
//        _lineView = nil;
//    }
    
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.current_index inSection:0] animated:NO scrollPosition:(UICollectionViewScrollPositionNone)];
    return self;
}


- (void)selectedAtIndex:(NSInteger)index  {
    self.last_index = self.current_index;
    self.current_index = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
    UICollectionViewCell  *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (self.configuration.showScrollBar) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.lineView.frame;
            frame.origin.x = cell.frame.origin.x + (cell.frame.size.width  -  self.lineView.frame.size.width)/2;
            self.lineView.frame = frame;
        }];
    }
}


#pragma mark -- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(numberOfItemsInSegmentView:)]) {
        return [self.delegate numberOfItemsInSegmentView:self];
    } else {
        return self.items.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AFSegmentItem *item;
    if ([self.delegate respondsToSelector:@selector(segmentView:itemForSegmentAtIndex:)]) {
        item = [self.delegate segmentView:self itemForSegmentAtIndex:indexPath.item];
    } else {
        if (self.items.count > indexPath.item) item = self.items[indexPath.item];
    }
    AFSegmentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AFSegmentViewCell" forIndexPath:indexPath];
    cell.item = item;
    cell.selected = (indexPath.item == self.current_index);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.last_index = self.current_index;
    self.current_index = indexPath.item;
    
    if (collectionView.scrollEnabled) {
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
    }
    UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(segmentView:didSelectItemAtIndex:)]) {
        [self.delegate segmentView:self didSelectItemAtIndex:indexPath.item];
    }
    if (self.configuration.showScrollBar) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.lineView.frame;
            frame.origin.x = cell.frame.origin.x + (cell.frame.size.width  -  self.lineView.frame.size.width)/2;
            self.lineView.frame = frame;
        }];
    }
}

/// 返回item的宽度
- (CGFloat)collectionViewLayout:(AFCollectionViewFlowLayout *)layout heightForItemFixedSize:(CGFloat)fixed_size atIndexPath:(NSIndexPath *)indexPath {
    
    // 有实现协议，优先返回协议实现的size
    if ([self.delegate respondsToSelector:@selector(segmentView:sizeForItemAtIndex:)]) {
        return [self.delegate segmentView:self sizeForItemAtIndex:indexPath.item].width;
    }
    // 没有实现协议，则返回item的指定size
    AFSegmentItem *item = [self itemAtIndex:indexPath.item];
    if (!CGSizeEqualToSize(item.itemSize, CGSizeZero)) return item.itemSize.width;
    // 没有制定item的size，则返回Configuration指定的size
    if (!CGSizeEqualToSize(self.configuration.itemSize, CGSizeZero)) return self.configuration.itemSize.width;
    // 都没有指定的情况，则自适应size
    if (self.collectionView.scrollEnabled) {
        return [item widthWithItemSpace:self.configuration.itemSpace]; 
    } else {
//        if (self.configuration.adjustEnable) {
//            return [title widthForFont:self.configuration.selectedFont] + self.configuration.titleSpace + self.supplement_W;
//        } else {
            return (self.collectionView.frame.size.width - self.configuration.insets.left - self.configuration.insets.right)/self.items.count;
//        }
    }
}


- (CGSize)contentSizeForCollectionViewLayout:(AFCollectionViewFlowLayout *)layout adjustsSize:(CGSize)adjustsSize {
    return CGSizeMake(adjustsSize.width + 1, self.collectionView.frame.size.height);
}


#pragma mark - 根据index获取item
- (AFSegmentItem *)itemAtIndex:(NSUInteger)index {
    if (self.items.count > index) return self.items[index];
    if ([self.delegate respondsToSelector:@selector(segmentView:itemForSegmentAtIndex:)]) {
        return [self.delegate segmentView:self itemForSegmentAtIndex:index];
    }
    return nil;
}


@end




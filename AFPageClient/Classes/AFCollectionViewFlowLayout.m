//
//  AFCollectionViewFlowLayout.m
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import "AFCollectionViewFlowLayout.h"

@implementation AFFlowLayoutDatasouce
@end


@interface AFCollectionViewFlowLayout ()

/** section间距 */
@property (nonatomic, assign) CGFloat              sectionSpacing;

/** section外边距 */
@property (nonatomic, assign) UIEdgeInsets         margin;

/** 布局方式 */
@property (nonatomic, assign) AFFlowLayoutStyle    style;

/** 行数据源 -- 开启瀑布流布局时，默认至少一行 */
@property (nonatomic, strong) NSMutableArray <AFFlowLayoutDatasouce *>      *datasouce;

/** 布局数组 */
@property (nonatomic, strong) NSMutableArray            *attributesArray;


/** 记录上一个item的布局 */
@property (nonatomic, strong) UICollectionViewLayoutAttributes  *last_itemAttributes;

/** 记录最短的行 */
@property (nonatomic, assign) NSInteger            min_Line;

/** 记录最长的行 */
@property (nonatomic, assign) NSInteger            max_Line;

/** 记录最长的行的值 */
@property (nonatomic, assign) CGFloat              max_size;

@end


@implementation AFCollectionViewFlowLayout
#pragma mark - 初始化 属性设置
- (instancetype)init {
    if (self = [super init]) {
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
    }
    return self;
}


//itemSize
- (instancetype)makeItemSize:(CGSize)itemSize {
    self.itemSize = itemSize;
    return self;
}
//项间距
- (instancetype)makeItemSpacing:(CGFloat)itemSpacing {
    self.minimumInteritemSpacing = itemSpacing;
    return self;
}
//行间距
- (instancetype)makeLineSpacing:(CGFloat)lineSpacing {
    self.minimumLineSpacing = lineSpacing;
    return self;
}
//section间距
- (instancetype)makeSectionSpacing:(CGFloat)sectionSpacing {
    self.sectionSpacing = sectionSpacing;
    return self;
}
//内边距
- (instancetype)makeSectionInset:(UIEdgeInsets)sectionInset {
    self.sectionInset = sectionInset;
    return self;
}
//外边距
- (instancetype)makeMargin:(UIEdgeInsets)margin {
    self.margin = margin;
    return self;
}
//行数
- (instancetype)makeNumberOfLines:(NSInteger)numberOfLines {
    
    [self.datasouce removeAllObjects];
    for (int i = 0; i < numberOfLines; i++) {
        AFFlowLayoutDatasouce *datasouce = [AFFlowLayoutDatasouce new];
        [self.datasouce addObject:datasouce];
    }
    return self;
}
//布局方式
- (instancetype)makeLayoutStyle:(AFFlowLayoutStyle)style {
    self.style = style;
    return self;
}


#pragma mark - 瀑布流 -- 固定边长
//根据flowLayout 自适应行的 宽/高度
- (void)adjustsLinesSizeWithCollectionView:(UICollectionView *)collectionView {
    
    CGFloat fixed_size;
    if (self.scrollDirection) {
        fixed_size = (collectionView.frame.size.height - self.margin.top - self.margin.bottom - self.sectionInset.top - self.sectionInset.bottom - (self.datasouce.count-1) * self.minimumLineSpacing) / self.datasouce.count;
    } else {
        fixed_size = (collectionView.frame.size.width - self.margin.left - self.margin.right - self.sectionInset.left - self.sectionInset.right - (self.datasouce.count-1) * self.minimumLineSpacing) / self.datasouce.count;
    }
        
    for (AFFlowLayoutDatasouce *datasouce in self.datasouce) {
        datasouce.fixed_size = fixed_size;
    }
}


//设置所有行的固定 宽/高度
- (void)attachAllLinesFixedSize:(CGFloat)size {
    for (AFFlowLayoutDatasouce *data in self.datasouce) {
        data.fixed_size = size;
    }
}


//设置某一行的固定 宽/高度
- (void)attachFixedSize:(CGFloat)size inLine:(NSInteger)line {
    if (line > self.datasouce.count - 1) {
//        NSLog(@"<------------------------------ 数组越界，line:%lu, dataCount:%lu ------------------------------>", line, self.datasouce.count);
        return;
    }
    
    AFFlowLayoutDatasouce *datasouce = self.datasouce[line];
    datasouce.fixed_size = size;
}



#pragma mark - 是否更新布局
//bounds发生变化时（改变frame，滑动时都会触发），是否注销布局 -- YES:会重新调用获取布局的方法，耗费性能
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    AFLog(@"<------------------------------ 11:old:%@ new:%@------------------------------>", NSStringFromCGRect(self.collectionView.bounds), NSStringFromCGRect(newBounds));
    return self.updateAttributesEnable;
}


#pragma mark - 布局准备
- (void)prepareLayout {
//    AFLog(@"<------------------------------ 22--prepare ------------------------------>");
    [super prepareLayout];
}


#pragma mark - contentSize
- (CGSize)collectionViewContentSize {
    
//    AFLog(@"<------------------------------ 33--AdjustsSize:%@ ------------------------------>", NSStringFromCGSize(adjustsSize));
    if ([self.delegate respondsToSelector:@selector(contentSizeForCollectionViewLayout:adjustsSize:)]) {
        CGSize adjustsSize = CGSizeZero;
        switch (self.style) {
            case AFFlowLayoutStyleAdjustsSizeVertical: {
                CGFloat current_y = self.last_itemAttributes ? self.last_itemAttributes.frame.origin.y : self.margin.top + self.sectionInset.top;
                adjustsSize = CGSizeMake(0, current_y + _max_size + self.margin.bottom);
            }
                break;
                
            case AFFlowLayoutStyleWaterfallVertical: {
                adjustsSize = CGSizeMake(0, [self getMaxLineSize] + self.margin.bottom);
            }
                break;
                
            case AFFlowLayoutStyleWaterfallHorizantal: {
                adjustsSize = CGSizeMake([self getMaxLineSize] + self.margin.right, 0);
            }
                break;
                
            default:
                adjustsSize = [super collectionViewContentSize];
                break;
        }
        return [self.delegate contentSizeForCollectionViewLayout:self adjustsSize:adjustsSize];
    }
    return [super collectionViewContentSize];
}


#pragma mark - 所有布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//    AFLog(@"<------------------------------ 44--Array ------------------------------>");
    if (self.style == AFFlowLayoutStyleDefault) {
        return [super layoutAttributesForElementsInRect:rect];
    }
    return  self.attributesArray;
}


- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
        NSInteger sections = [self.collectionView numberOfSections];
        for (int i = 0; i < sections; i++) {
            //heaedr
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
            UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
            if (headerAttributes) {
                [_attributesArray addObject:headerAttributes];
            }

            //cell
            NSInteger items = [self.collectionView numberOfItemsInSection:i];
            for (int j = 0; j < items; j++) {
                UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
                if (cellAttributes) {
                    [_attributesArray addObject:cellAttributes];
                }
            }
            
            //footer
            UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
            if (footerAttributes) {
                [_attributesArray addObject:footerAttributes];
            }
        }
    }
    return _attributesArray;
}



#pragma mark - cell布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.style == AFFlowLayoutStyleDefault) {
        UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//        AFLog(@"<------------------------------ 55--Attri--indexPath:%@  frame:%@ ------------------------------>", indexPath, NSStringFromCGRect(attributes.frame));
        return attributes;
    }
    
    //计算 Cell的frame
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    switch (self.style) {
            
        //自适应size布局
        case AFFlowLayoutStyleAdjustsSizeVertical: {
            CGSize size = self.itemSize;
            if ([self.delegate respondsToSelector:@selector(collectionViewLayout:sizeForItemAtIndexPath:)]) {
                size = [self.delegate collectionViewLayout:self sizeForItemAtIndexPath:indexPath];
            }
            CGFloat x = 0.f;
            CGFloat y = 0.f;
            if (indexPath.item == 0) {
                x = self.margin.left + self.sectionInset.left;
                y = CGRectGetMaxY(self.last_itemAttributes.frame) + self.sectionInset.top;
            } else {
                _max_size   = fmaxf(_max_size, size.height);
                CGFloat current_x = self.last_itemAttributes ? CGRectGetMaxX(self.last_itemAttributes.frame) + self.minimumInteritemSpacing : self.margin.left + self.sectionInset.left;
                CGFloat current_y = self.last_itemAttributes ? self.last_itemAttributes.frame.origin.y : self.margin.top + self.sectionInset.top;
                if (current_x + size.width + self.sectionInset.right + self.margin.right <= self.collectionView.frame.size.width) {
                    x = current_x;
                    y = current_y;
                } else {
                    x = self.margin.left + self.sectionInset.left;
                    y = current_y + _max_size + self.minimumLineSpacing;
                    _max_size = size.height;
                }
            }
            attributes.frame = CGRectMake(x, y, size.width, size.height);
            self.last_itemAttributes = attributes;
        }
            break;
            
        //瀑布流垂直布局
        case AFFlowLayoutStyleWaterfallVertical: {
            CGFloat min_line_size = [self getMinLineSize];
            CGFloat width = self.datasouce[self.min_Line].fixed_size;
            CGFloat height = 0.f;
            if ([self.delegate respondsToSelector:@selector(collectionViewLayout:heightForItemFixedSize:atIndexPath:)]) {
                height = [self.delegate collectionViewLayout:self heightForItemFixedSize:width atIndexPath:indexPath];
            }
            CGFloat x = self.margin.left + self.sectionInset.left + _min_Line * (width + self.minimumLineSpacing);
            CGFloat y;
            if (min_line_size > 0) {
                y = min_line_size + self.minimumInteritemSpacing;
            } else {
                y = min_line_size + self.sectionInset.top;
            }
            attributes.frame = CGRectMake(x, y, width, height);
            self.datasouce[_min_Line].current_size = y + height;
        }
            break;
            
        //瀑布流水平布局
        case AFFlowLayoutStyleWaterfallHorizantal: {
            CGFloat min_line_size = [self getMinLineSize];
            CGFloat height = self.datasouce[self.min_Line].fixed_size;
            CGFloat width = 0.f;
            if ([self.delegate respondsToSelector:@selector(collectionViewLayout:heightForItemFixedSize:atIndexPath:)]) {
                width = [self.delegate collectionViewLayout:self heightForItemFixedSize:width atIndexPath:indexPath];
            }
            CGFloat x = min_line_size + (min_line_size > 0 ? self.minimumInteritemSpacing : self.sectionInset.left);
            if (min_line_size > 0) {
                x = min_line_size + self.minimumInteritemSpacing;
            } else {
                x = min_line_size + self.sectionInset.left;
            }
            CGFloat y = self.margin.top + self.sectionInset.top + _min_Line * (height + self.minimumLineSpacing);
            attributes.frame = CGRectMake(x, y, width, height);
            self.datasouce[_min_Line].current_size = x + width;
        }
            break;
            
        default:
//            CGFloat x = self.margin.left + self.sectionInset.left + (_min_Line + indexPath.section * 5) * (width + self.minimumLineSpacing);
//            if (indexPath.section) {
//                x = AF_Width + (width + self.minimumLineSpacing) * indexPath.item;
//            }
//            if (indexPath.item < 5) {
//                //最后一个
//                min_line_size = 0;
//
//            }
            //        if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section] - 1) {
            //            attributes.frame =
            //        }
            break;
    }
//    AFLog(@"<------------------------------ 55--Attri--indexPath:%@ frame:%@ ------------------------------>", indexPath, NSStringFromCGRect(attributes.frame));
    return attributes;
}



- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (self.style == AFFlowLayoutStyleDefault) {
        return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    }
    
#pragma mark - header布局属性
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
//        AFLog(@"<------------------------------ 66--SupplementHeader--IndexPath:%@ ------------------------------>", indexPath);
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes  layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        CGSize headerSize = self.headerReferenceSize;
        if ([self.delegate respondsToSelector:@selector(collectionViewLayout:sizeForSupplementHeaderAtIndexPath:)]) {
            headerSize = [self.delegate collectionViewLayout:self sizeForSupplementHeaderAtIndexPath:indexPath];
        }

        switch (self.style) {
            //自适应布局
            case AFFlowLayoutStyleAdjustsSizeVertical: {
                CGFloat y = self.last_itemAttributes ? CGRectGetMaxY(self.last_itemAttributes.frame) + self.sectionSpacing : self.margin.top;
                attributes.frame = CGRectMake(self.margin.left, y, headerSize.width, headerSize.height);
                _max_size = 0;
                self.last_itemAttributes = attributes;
            }
                break;
                
            //垂直布局
            case AFFlowLayoutStyleWaterfallVertical: {

                CGFloat max_line_size = [self getMaxLineSize];
                CGFloat y;
                if (indexPath.section == 0) {
                    y = self.margin.top;
                } else {
                    y = max_line_size + self.sectionSpacing;
                }
                attributes.frame = CGRectMake(self.margin.left, y, headerSize.width, headerSize.height);
                for (AFFlowLayoutDatasouce *datasouce in self.datasouce) {
                    datasouce.current_size = y + headerSize.height;
                }
            }
                break;
                
            //水平布局
            case AFFlowLayoutStyleWaterfallHorizantal: {
                if (![self.delegate respondsToSelector:@selector(collectionViewLayout:sizeForSupplementHeaderAtIndexPath:)]) {
                    return [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                }

                CGFloat max_line_size = [self getMaxLineSize];
                CGFloat x;
                if (indexPath.section == 0) {
                    x = self.margin.left;
                } else {
                    x = max_line_size + self.sectionSpacing;
                }
                attributes.frame = CGRectMake(x, self.margin.top, headerSize.width, headerSize.height);
                for (AFFlowLayoutDatasouce *datasouce in self.datasouce) {
                    datasouce.current_size = x + headerSize.width;
                }
            }
                break;
                
            default:
                break;
        }
        return attributes;
    }
    
    
#pragma mark - footer布局属性
//    AFLog(@"<------------------------------ 77--SupplementFooter--IndexPath:%@ ------------------------------>", indexPath);
    if (![self.delegate respondsToSelector:@selector(collectionViewLayout:sizeForSupplementFooterAtIndexPath:)]) {
        return [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
    }
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes  layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
    CGSize footerSize = self.footerReferenceSize;
    if ([self.delegate respondsToSelector:@selector(collectionViewLayout:sizeForSupplementFooterAtIndexPath:)]) {
        footerSize = [self.delegate collectionViewLayout:self sizeForSupplementFooterAtIndexPath:indexPath];
    }
    
    switch (self.style) {
            //垂直布局
        case AFFlowLayoutStyleWaterfallVertical: {
            CGFloat max_line_size = [self getMaxLineSize];
            CGFloat y = max_line_size + self.sectionInset.bottom;
            attributes.frame = CGRectMake(self.margin.left, y, footerSize.width, footerSize.height);
            for (AFFlowLayoutDatasouce *datasouce in self.datasouce) {
                datasouce.current_size = y + footerSize.height;
            }
        }
            break;
            
            //水平布局
        case AFFlowLayoutStyleWaterfallHorizantal: {
            CGFloat max_line_size = [self getMaxLineSize];
            CGFloat x = max_line_size + self.sectionInset.right;
            attributes.frame = CGRectMake(x, self.margin.top, footerSize.width, footerSize.height);
            for (AFFlowLayoutDatasouce *datasouce in self.datasouce) {
                datasouce.current_size = x + footerSize.width;
            }
        }
            break;
            
            //自适应布局
        case AFFlowLayoutStyleAdjustsSizeVertical: {
            CGFloat y = self.last_itemAttributes ? CGRectGetMaxY(self.last_itemAttributes.frame) + self.sectionInset.bottom : self.margin.top;
            attributes.frame = CGRectMake(self.margin.left, y, footerSize.width, footerSize.height);
            _max_size = 0;
            self.last_itemAttributes = attributes;
        }
            break;
            
        default:
            break;
    }
    return attributes;
}



//获取当前最长的行 及其长度
- (CGFloat)getMaxLineSize {
    _max_Line = 0;
    CGFloat max_line_size = self.datasouce.firstObject.current_size;
    for (int i = 0; i < self.datasouce.count; i++) {
        CGFloat current_size = self.datasouce[i].current_size;
        if (max_line_size < current_size) {
            max_line_size = current_size;
            _max_Line = i;
        }
    }
    return max_line_size;
}




//获取当前最短的行 及其长度
- (CGFloat)getMinLineSize {
    _min_Line = 0;
    CGFloat min_line_size = self.datasouce.firstObject.current_size;
    for (int i = 0; i < self.datasouce.count; i++) {
        CGFloat current_size = self.datasouce[i].current_size;
        if (min_line_size > current_size) {
            min_line_size = current_size;
            _min_Line = i;
        }
    }
    return min_line_size;
}



#pragma mark - 数据源 -- 刷新布局
- (void)reloadData {
    switch (self.style) {
        case AFFlowLayoutStyleWaterfallVertical:
        case AFFlowLayoutStyleWaterfallHorizantal: {
            for (AFFlowLayoutDatasouce *datasouce in self.datasouce) {
                datasouce.current_size = 0;
            }
        }
            break;
            
        case AFFlowLayoutStyleAdjustsSizeVertical:
            self.last_itemAttributes = nil;
            _max_size = 0;
            break;
            
        default:
            return;
    }
    self.attributesArray = nil;
}


- (void)addData {
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = self.attributesArray.count; i < count; i++) {
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [_attributesArray addObject:attrs];
    }
}


- (void)removeDataAtIndexPath:(NSIndexPath *)indexPath {
    if (self.attributesArray.count > indexPath.item) {
        [self.attributesArray removeObjectAtIndex:indexPath.item];
    }
}


- (NSMutableArray<AFFlowLayoutDatasouce *> *)datasouce {
    if (!_datasouce) {
        _datasouce = [NSMutableArray array];
        AFFlowLayoutDatasouce *datasouce = [AFFlowLayoutDatasouce new];
        [_datasouce addObject:datasouce];
    }
    return _datasouce;
}

//根据item在UICollectionView中的位置获取该item的NSIndexPath。
//第一个参数该item原来的index path，第二个参数是item在collection view中的位置。
//在item移动的过程中，该方法将UICollectionView中的location映射成相应 NSIndexPaths。该方法的默认是显示，查找指定位置的已经存在的cell，返回该cell的NSIndexPaths 。如果在相同的位置有多个cell，该方法默认返回最上层的cell。

- (NSIndexPath *)targetIndexPathForInteractivelyMovingItem:(NSIndexPath *)previousIndexPath withPosition:(CGPoint)position {
//    AFLog(@"-------------------------- 111 --------------------------");
    NSIndexPath *indexPath = [super targetIndexPathForInteractivelyMovingItem:previousIndexPath withPosition:position];
    NSIndexPath *newIndexPath;
    if ([self.delegate respondsToSelector:@selector(targetIndexPathForInteractivelyMovingItem:toIndexPath:withPosition:)]) {
        newIndexPath = [self.delegate targetIndexPathForInteractivelyMovingItem:previousIndexPath toIndexPath:indexPath withPosition:position];
    }
    return newIndexPath ?: indexPath;
}

//当item在手势交互下移动时，通过该方法返回这个item布局的attributes 。
//默认实现是，复制已存在的attributes，改变attributes两个值，一个是中心点center；另一个是z轴的坐标值，设置成最大值。
//所以该item在collection view的最上层。子类重载该方法，可以按照自己的需求更改attributes，
//首先需要调用super类获取attributes,然后自定义返回的数据结构。
- (UICollectionViewLayoutAttributes *)layoutAttributesForInteractivelyMovingItemAtIndexPath:(NSIndexPath *)indexPath withTargetPosition:(CGPoint)position {
//    AFLog(@"-------------------------- 222 --------------------------");
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForInteractivelyMovingItemAtIndexPath:indexPath withTargetPosition:position];
    UICollectionViewLayoutAttributes *newAttributes;
    if ([self.delegate respondsToSelector:@selector(layoutAttributesForInteractivelyMovingItemWithLayoutAttributes:atIndexPath:withTargetPosition:)]) {
        newAttributes = [self.delegate layoutAttributesForInteractivelyMovingItemWithLayoutAttributes:attributes atIndexPath:indexPath withTargetPosition:position];
    }
    return newAttributes ?: attributes;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition {
//    AFLog(@"-------------------------- 333 --------------------------");
    return  [super invalidationContextForInteractivelyMovingItems:targetIndexPaths withTargetPosition:targetPosition previousIndexPaths:previousIndexPaths previousPosition:previousPosition];
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled {
//    NSLog(@"-------------------------- 444 --------------------------");
    return [super invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:indexPaths previousIndexPaths:previousIndexPaths movementCancelled:movementCancelled];
}


@end

//
//  AFCollectionViewFlowLayout.h
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AFFlowLayoutStyle)  {
    AFFlowLayoutStyleDefault,              /// 默认布局
    AFFlowLayoutStyleAdjustsSizeVertical,  /// 自适应Size--垂直
    AFFlowLayoutStyleWaterfallVertical,    /// 瀑布流--垂直
    AFFlowLayoutStyleWaterfallHorizantal   /// 瀑布流--水平
};

#pragma mark - 协议
@class AFCollectionViewFlowLayout;

@protocol AFFlowLayoutDelegate <NSObject>
@optional

- (NSIndexPath *)targetIndexPathForInteractivelyMovingItem:(NSIndexPath *)previousIndexPath toIndexPath:(NSIndexPath *)toIndexPath withPosition:(CGPoint)position;

- (UICollectionViewLayoutAttributes *)layoutAttributesForInteractivelyMovingItemWithLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath withTargetPosition:(CGPoint)position;

/// Cell 自适应size
- (CGSize)collectionViewLayout:(AFCollectionViewFlowLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/// Cell 瀑布流 宽度/高度
- (CGFloat)collectionViewLayout:(AFCollectionViewFlowLayout *)layout heightForItemFixedSize:(CGFloat)fixed_size atIndexPath:(NSIndexPath *)indexPath;

/// Header size
- (CGSize)collectionViewLayout:(AFCollectionViewFlowLayout *)layout sizeForSupplementHeaderAtIndexPath:(NSIndexPath *)indexPath;

/// footer size
- (CGSize)collectionViewLayout:(AFCollectionViewFlowLayout *)layout sizeForSupplementFooterAtIndexPath:(NSIndexPath *)indexPath;

/// contentSize
- (CGSize)contentSizeForCollectionViewLayout:(AFCollectionViewFlowLayout *)layout adjustsSize:(CGSize)adjustsSize;

@end



@interface AFCollectionViewFlowLayout : UICollectionViewFlowLayout

/** 代理 */
@property (nonatomic, weak) id <AFFlowLayoutDelegate>          delegate;

/** 是否允许更新布局 -- 节约性能，默认NO，reloadData内部会自动处理 */
@property (nonatomic, assign) BOOL            updateAttributesEnable;

//项大小
- (instancetype)makeItemSize:(CGSize)itemSize;
//项间距
- (instancetype)makeItemSpacing:(CGFloat)itemSpacing;
//行间距
- (instancetype)makeLineSpacing:(CGFloat)lineSpacing;
//section间距
- (instancetype)makeSectionSpacing:(CGFloat)sectionSpacing;
//内边距
- (instancetype)makeSectionInset:(UIEdgeInsets)sectionInset;
//外边距
- (instancetype)makeMargin:(UIEdgeInsets)margin;
//设置行数 -- 瀑布流需要设置
- (instancetype)makeNumberOfLines:(NSInteger)numberOfLines;
//布局方式
- (instancetype)makeLayoutStyle:(AFFlowLayoutStyle)style;



//根据flowLayout 自适应行的 宽/高度
- (void)adjustsLinesSizeWithCollectionView:(UICollectionView *)collectionView;
//设置所有行的固定 宽/高度
- (void)attachAllLinesFixedSize:(CGFloat)size;
//设置某一行的固定 宽/高度
- (void)attachFixedSize:(CGFloat)size inLine:(NSInteger)line;



//数据变动 更新布局
- (void)reloadData;
- (void)addData;
- (void)removeDataAtIndexPath:(NSIndexPath *)indexPath;


@end



#pragma mark - 行 数据源
@interface AFFlowLayoutDatasouce : NSObject

/** 固定 宽度或高度 */
@property (nonatomic, assign) CGFloat            fixed_size;

/** 记录当前 宽度或高度 -- 每次计算item布局时 都会更新该值 */
@property (nonatomic, assign) CGFloat            current_size;

@end


//
//  AFPageClient.m
//  AFPageClient
//
//  Created by alfie on 2020/8/30.
//

#import "AFPageClient.h"
#import "AFPageCollectionView.h"
#import "AFSegmentView.h"

/// 子控制器的view的tag
static NSInteger AFPageChildViewTag = 66661201;


@interface AFPageClient () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, AFSegmentViewDelegate>

/** 容器 */
@property (weak, nonatomic) UIViewController        *parentViewController;

/** contentVell */
@property (strong, nonatomic) UITableViewCell       *contentCell;

/** collection */
@property (strong, nonatomic) AFPageCollectionView  *collectionView;

/** segment */
@property (strong, nonatomic) AFSegmentView         *segmentView;

/** view */
@property (nonatomic, strong) UIView                *contentView;

/** tableView容器 */
@property (strong, nonatomic) UITableView           *tableView;

/** frame */
@property (nonatomic, assign) CGRect                frame;

/** BOOL */
@property (nonatomic, assign) BOOL                  isFixed;

/** 是否能滚动 默认YES */
@property (assign, nonatomic) BOOL                  scrollEnable;

/** segment样式 */
@property (strong, nonatomic) AFSegmentConfiguration *configuration;

/** 记录item数据源 */
@property (strong, nonatomic) NSMutableDictionary <NSString *, AFPageItem *>   *pageItems;

@end


@implementation AFPageClient

#pragma mark -- 生命周期
- (instancetype)initWithFrame:(CGRect)frame parentController:(UIViewController *)viewController configuration:(AFSegmentConfiguration *)configuration {
    if (self = [super init]) {
        NSAssert(viewController, @"parentViewController不能为空!");
        self.parentViewController = viewController;
        self.frame = frame;
        self.configuration = configuration;
        _scrollEnable = YES;
    }
    return self;
}


#pragma mark - UI
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.frame];
    }
    return _contentView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (UITableViewCell *)contentCell {
    if (!_contentCell && !self.isFixed) {
        _contentCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"AFPageContentCell"];
        _contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_contentCell.contentView addSubview:self.collectionView];
    }
    return _contentCell;
}

- (AFSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = AFSegmentView.new;
        _segmentView.configuration = self.configuration;
        _segmentView.frame = self.configuration.frame;
        _segmentView.delegate = self;
        _segmentView.pageController = self.parentViewController;
        if ([self.delegate respondsToSelector:@selector(leftViewForSegmentInPageClient:)]) {
            _segmentView.leftView = [self.delegate leftViewForSegmentInPageClient:self];
        }
        if ([self.delegate respondsToSelector:@selector(rightViewForSegmentInPageClient:)]) {
            _segmentView.rightView = [self.delegate rightViewForSegmentInPageClient:self];
        }
    }
    return _segmentView;
}

- (AFPageCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height - self.configuration.frame.size.height);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[AFPageCollectionView alloc] initWithFrame:(CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height)) collectionViewLayout:layout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AFPageChildViewControllerCell"];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator   = NO;
        _collectionView.backgroundColor = self.configuration.backgroundColor;
//        _collectionView.gestureShouldRecognizer = YES;
//        _collectionView.responseDelegate = self;
    }
    return _collectionView;
}


#pragma mark - 数据
- (NSMutableDictionary *)pageItems {
    if (!_pageItems) {
        _pageItems = NSMutableDictionary.dictionary;
    }
    return _pageItems;
}

/// segment的配置
- (AFSegmentConfiguration *)configuration {
    if (!_configuration) {
        _configuration = AFSegmentConfiguration.new;
    }
    return _configuration;
}

/// 返回item 数量
- (NSInteger)numberOfItems {
    return [self.delegate numberOfItemsInPageClient:self];
}


#pragma mark - 刷新
- (void)reloadData {

    for (AFPageItem *item in self.pageItems.allValues) {
        [item.childViewController.view removeFromSuperview];
        [item.childViewController removeFromParentViewController];
//        NSLog(@"-------------------------- 释放:%@ --------------------------", item.childViewController);
    }
    [self.pageItems removeAllObjects];
    [self update];
}

/// 刷新SegmentView
- (void)reloadSegment {
    [self.segmentView reloadData];
}

- (void)update {
    
    _collectionView = nil;
    _contentCell = nil;
    [self segmentView:self.segmentView didSelectItemAtIndex:self.selectedIndex];

    if (self.isFixed) {
        // 固定
        self.segmentView.frame = self.configuration.frame;
        self.collectionView.frame = CGRectMake(0, self.segmentView.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height - self.segmentView.frame.size.height);
        [self.parentViewController.view addSubview:self.segmentView];
        [self.parentViewController.view addSubview:self.collectionView];
    } else {
        // 可滚动
        if (!self.tableView.superview) {
            [self.parentViewController.view addSubview:self.tableView];
        }
    }

//    //header
//    if ([self.delegate respondsToSelector:@selector(headerViewForContainer)]) {
//        self.tableView.tableHeaderView = self.delegate.headerViewForContainer;
//        self.tableView.bounces = YES;
//        [self.parentViewController.view insertSubview:self.multiScrollView atIndex:0];
//    }
    
    //collection
    if (self.parentViewController.navigationController.interactivePopGestureRecognizer) {
        [self.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.parentViewController.navigationController.interactivePopGestureRecognizer];
    } else {
//        for (UIGestureRecognizer *pan in self.parentViewController.view.gestureRecognizers) {
//            if ([pan isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//                [self.collectionView.panGestureRecognizer requireGestureRecognizerToFail:pan];
//                break;
//            }
//        }
    }
    [self.collectionView reloadData];
    [self.segmentView update];
    if (!self.isFixed) {
        [self.tableView reloadData];
    }
}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.contentCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segmentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.segmentView.frame.size.height;
}


#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate numberOfItemsInPageClient:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AFPageChildViewControllerCell" forIndexPath:indexPath];
    [[cell.contentView viewWithTag:AFPageChildViewTag] removeFromSuperview];
    NSString *key = [NSString stringWithFormat:@"AFPageItemIndex_%ld", indexPath.item];
    AFPageItem *item = [self.pageItems valueForKey:key];
    if (!item) {
        item = [self.delegate pageClient:self itemForPageAtIndex:indexPath.item];
        [self.pageItems setValue:item forKey:key];
    }
    
    UIViewController *childVc = item.childViewController;
    [self.parentViewController addChildViewController:childVc];
    [childVc didMoveToParentViewController:self.parentViewController];
//    if (self.tableView.tableHeaderView && !childVc.view.superview && [childVc respondsToSelector:@selector(scrollViewForChildViewController)]) {
//        [self.monitor addChildScrollView:childVc.scrollViewForChildViewController forParentScrollView:self.tableView atIndex:indexPath.item];
//    }
    childVc.view.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    [cell.contentView addSubview:childVc.view];
    return cell;
}


#pragma mark - 监听滚动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView == self.collectionView) {
//        NSInteger page = (NSInteger)(scrollView.contentOffset.x / self.collectionView.frame.size.width);
//        if (_selectedIndex != page) {
//            _selectedIndex = page;
//            [self.segmentView selectedAtIndex:page];
//            if ([self.delegate respondsToSelector:@selector(pageClient:didSelectItemAtIndex:)]) {
//                [self.delegate pageClient:self didSelectItemAtIndex:page];
//            }
//        }
//    }
//    NSLog(@"-------------------------- 停了：%g --------------------------", self.segmentView.scrollBar.frame.origin.x);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     if (scrollView == self.collectionView) {
         [self.segmentView pageScrollViewDidScroll:scrollView];
//        if ([self.delegate respondsToSelector:@selector(pageCollectionViewDidScroll:)]) {
//            [self.delegate pageCollectionViewDidScroll:self.collectionView];
//        }

    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.collectionView) {
        CGFloat offX = targetContentOffset->x;
        NSInteger page = (NSInteger)(offX / self.collectionView.frame.size.width);
        [self.segmentView selectedAtIndex:page];
        if (_selectedIndex != page) {
            _selectedIndex = page;
            if ([self.delegate respondsToSelector:@selector(pageClient:didSelectItemAtIndex:)]) {
                [self.delegate pageClient:self didSelectItemAtIndex:page];
            }
        }
    }
//    NSLog(@"-------------------------- 离开手指，%d --------------------------", scrollView.decelerating);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"-------------------------- 结束了 --------------------------");
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.segmentView.scrollBar stop];
}



#pragma mark -- 手动设置显示的控制器
- (void)setSelectedIndex:(NSInteger)selectedIndex {
//    if (self.segmentView.delegate == self) {
//        [self.segmentView selectedAtIndex:index];
//    } else {
//        [self selectedViewControllerAtIndex:index];
//    }
    [self selectedViewControllerAtIndex:index];
}

- (void)selectedViewControllerAtIndex:(NSInteger)index {
    if ((index >= [self.delegate numberOfItemsInPageClient:self] || (index == self.selectedIndex))) {
        return;
    }
    if (abs((int)(index - self.selectedIndex)) > 1) {
        //不做动画
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:(UICollectionViewScrollPositionLeft) animated:NO];
    } else {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:(UICollectionViewScrollPositionLeft) animated:YES];
    }
    [self.segmentView selectedAtIndex:index];
    _selectedIndex = index;
}

- (UIViewController *)currentVc {
    NSString *key = [NSString stringWithFormat:@"AFPageItemIndex_%ld", self.selectedIndex];
    AFPageItem *item = [self.pageItems valueForKey:key];
    if (!item) {
        item = [self.delegate pageClient:self itemForPageAtIndex:self.selectedIndex];
        [self.pageItems setValue:item forKey:key];
    }
    return item.childViewController;
}


#pragma mark - AFSegmentViewDelegate
/// item的数量
- (NSInteger)numberOfItemsInSegmentView:(AFSegmentView *)segmentView {
    return [self.delegate numberOfItemsInPageClient:self];
}
 
/// 自定义每个item的数据源
- (AFPageItem *)segmentView:(AFSegmentView *)segmentView itemForSegmentAtIndex:(NSInteger)index {
    NSString *key = [NSString stringWithFormat:@"AFPageItemIndex_%ld", index];
    AFPageItem *item = [self.pageItems valueForKey:key];
    if (!item) {
        item = [self.delegate pageClient:self itemForPageAtIndex:index];
        [self.pageItems setValue:item forKey:key];
    }
    return item;
}

/// 选中Item的回调
- (void)segmentView:(AFSegmentView *)segmentView didSelectItemAtIndex:(NSInteger)index {
    if (index >= [self.delegate numberOfItemsInPageClient:self]) return;
    [self selectedViewControllerAtIndex:index];
    if ([self.delegate respondsToSelector:@selector(pageClient:didSelectItemAtIndex:)]) {
        [self.delegate pageClient:self didSelectItemAtIndex:index];
    }
}


@end

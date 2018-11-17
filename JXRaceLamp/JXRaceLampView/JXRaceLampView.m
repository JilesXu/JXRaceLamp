//
//  JXRaceLamp.m
//  JXRaceLamp
//
//  Created by 徐沈俊杰 on 2018/11/17.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "JXRaceLampView.h"
#import "JXRaceLampCell.h"
#import "Masonry.h"
#import "JXUtilities.h"

#define kTitleWidth 82
#define kJXRaceLampCell @"JXRaceLampCell"

@interface JXRaceLampView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *displayDataArray;

@end

@implementation JXRaceLampView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubviews];
        [self setupFrame];
    }
    
    return self;
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.displayDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JXRaceLampCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kJXRaceLampCell forIndexPath:indexPath];
    
    if (self.displayDataArray[indexPath.row] != nil && self.displayDataArray.count > indexPath.row) {
        [cell refreshContentCell:self.displayDataArray[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.displayDataArray.count > indexPath.row) {
        if (self.displayDataArray[indexPath.row] != nil) {
            if (self.bannerPressedBlock) {
                self.bannerPressedBlock(self.displayDataArray[indexPath.row], indexPath.row);
            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self cycleScroll];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self cycleScroll];
}
#pragma mark - Method
- (void)addSubviews {
    [self addSubview:self.titleView];
    [self addSubview:self.collectionView];
}

- (void)setupFrame {
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.bottom.equalTo(self);
        make.width.mas_equalTo(kTitleWidth);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.and.bottom.equalTo(self);
        make.left.equalTo(self.titleView.mas_right);
    }];
}

/**
 循环显示
 */
- (void)cycleScroll {
    CGFloat pageSize = CGRectGetHeight(self.frame);
    NSInteger page = roundf(self.collectionView.contentOffset.y / pageSize);
    //    NSLog(@"%ld", (long)page);
    
    if (self.collectionView.contentOffset.y > (self.displayDataArray.count - 1) * pageSize) {
        //当collectionView偏移量由于手机卡顿,向右滑动出现异常时，即超出最大偏移量，修复至正数第二屏
        self.collectionView.contentOffset = CGPointMake(0, pageSize);//偏移量设置到正数第二屏
    } else if (self.collectionView.contentOffset.y < 0) {
        //当collectionView偏移量由于手机卡顿，向左滑动出现异常时，即低于0，修复至倒数第二屏
        self.collectionView.contentOffset = CGPointMake(0, pageSize * (self.displayDataArray.count - 2));//偏移量设置到倒数第二屏
    } else {
        if (page == 0) {
            //滚动到最左边时，即滚动到第一屏时
            self.collectionView.contentOffset = CGPointMake(0, pageSize * (self.displayDataArray.count - 2));//偏移量设置到倒数第二屏
            
        } else if (page == self.displayDataArray.count - 1){
            //滚动到最右边时，即滚动到最后一屏时
            self.collectionView.contentOffset = CGPointMake(0, pageSize);//偏移量设置到正数第二屏
            
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat pageSize = CGRectGetHeight(self.frame);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView layoutIfNeeded];
        [self.collectionView reloadData];
        [self.collectionView setContentOffset:CGPointMake(0, pageSize) animated:NO];
    });
}
#pragma mark - Setting And Getting
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor redColor];
    }
    
    return _titleView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(82, 0, CGRectGetWidth(self.bounds) - kTitleWidth, CGRectGetHeight(self.bounds)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor greenColor];
        [_collectionView registerClass:[JXRaceLampCell class] forCellWithReuseIdentifier:kJXRaceLampCell];
    }
    
    return _collectionView;
}

- (NSMutableArray *)displayDataArray {
    if (!_displayDataArray) {
        _displayDataArray = [[NSMutableArray alloc] init];
    }
    
    return _displayDataArray;
}

- (void)setOriginDataArray:(NSArray *)originDataArray {
    _originDataArray = originDataArray;
    
    if ([JXUtilities isValidArray:originDataArray]) {
        
        [self.displayDataArray removeAllObjects];
        
        [self.displayDataArray addObjectsFromArray:originDataArray];
        
        [self.displayDataArray addObject:originDataArray.firstObject];
        [self.displayDataArray insertObject:originDataArray.lastObject atIndex:0];
        
        if (originDataArray.count == 1) {
            self.collectionView.scrollEnabled = NO;
        }
    }
}

@end

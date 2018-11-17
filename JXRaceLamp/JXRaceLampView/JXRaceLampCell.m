//
//  JXRaceLampCell.m
//  JXRaceLamp
//
//  Created by 徐沈俊杰 on 2018/11/17.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "JXRaceLampCell.h"
#import "Masonry.h"

#define kSCALE ([UIScreen mainScreen].bounds.size.width/375)
#define kTO_SCALE(x) (kSCALE*x)

@interface JXRaceLampCell ()

@property (nonatomic, strong) UIView *container1View;
@property (nonatomic, strong) UIView *container2View;

@end
@implementation JXRaceLampCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
        [self setupFrame];
    }
    
    return self;
}

- (void)refreshContentCell:(JXRaceLampModel *)model {
    
}

- (void)addSubviews {
    [self.contentView addSubview:self.container1View];
    [self.contentView addSubview:self.container2View];
}

- (void)setupFrame {
    [self.container1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self);
    }];
    [self.container2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.and.right.equalTo(self);
    }];
    
    [@[self.container1View, self.container2View] mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (UIView *)container1View {
    if (!_container1View) {
        _container1View = [[UIView alloc] init];
        _container1View.backgroundColor = [UIColor yellowColor];
        _container1View.clipsToBounds = YES;
    }
    
    return _container1View;
}

- (UIView *)container2View {
    if (!_container2View) {
        _container2View = [[UIView alloc] init];
        _container2View.backgroundColor = [UIColor blueColor];
        _container2View.clipsToBounds = YES;
    }
    
    return _container2View;
}
@end

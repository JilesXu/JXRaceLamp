//
//  JXRaceLamp.h
//  JXRaceLamp
//
//  Created by 徐沈俊杰 on 2018/11/17.
//  Copyright © 2018年 JX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXRaceLampModel.h"

typedef void (^BannerPressed)(JXRaceLampModel *model, NSInteger tag);

@interface JXRaceLampView : UIView

/**
 原始数据
 */
@property (nonatomic, strong) NSArray *originDataArray;
/**
 Banner点击方法
 */
@property (nonatomic, strong) BannerPressed bannerPressedBlock;

- (void)showNextItem;

@end

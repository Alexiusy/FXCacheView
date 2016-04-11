//
//  InfinityCircle.h
//  InfinityScroll
//
//  Created by Zeacone on 16/4/9.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXCacheView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableSet<UIImageView *> *cachedViews;

@property (nonatomic, strong) NSMutableSet<UIImageView *> *usedViews;

@property (nonatomic, assign) BOOL flag;

@property (nonatomic, assign) CGFloat preOffsetX;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UIScrollView *container;

@end

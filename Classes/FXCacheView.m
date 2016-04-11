//
//  InfinityCircle.m
//  InfinityScroll
//
//  Created by Zeacone on 16/4/9.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FXCacheView.h"

@implementation InfinityCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialConfig];
    }
    return self;
}

- (NSMutableSet<UIImageView *> *)cachedViews {
    
    if (!_cachedViews) {
        _cachedViews = [NSMutableSet set];
    }
    return _cachedViews;
}

- (NSMutableSet<UIImageView *> *)usedViews {
    
    if (!_usedViews) {
        _usedViews = [NSMutableSet set];
    }
    return _usedViews;
}

- (void)initialConfig {
    
    self.flag = YES;
    
    self.container = ({
        UIScrollView *scroll = [UIScrollView new];
        scroll.frame = self.frame;
        scroll.delegate = self;
        scroll.backgroundColor = [UIColor whiteColor];
        scroll.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, CGRectGetHeight(self.bounds));
        scroll.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
        scroll.pagingEnabled = YES;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        
        scroll;
    });
    
    
    UIImageView *originalImageView = ({
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.container.bounds), 0, CGRectGetWidth(self.container.bounds), CGRectGetHeight(self.container.bounds))];
        imageview.image = [UIImage imageNamed:@"2.jpg"];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview;
    });
    
    [self.container addSubview:originalImageView];
    
    [self addSubview:_container];
}

#pragma mark - UIScrollView 的代理方法

- (UIImageView *)addImageView {
    
    UIImageView *imageview = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    imageview.image = image;
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    return imageview;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // TODO: 添加 PageControl 之类的指示器
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    CGFloat width = self.container.frame.size.width;
    CGFloat height = self.container.frame.size.height;
    
    if (!_flag) {
        return;
    }
    
    _flag = NO;
    UIImageView *imageview = [self useView];
    
    if (width == 0) {
        imageview.frame = CGRectMake(width, 0, width, height);
    } else if (offsetX < width) {
        imageview.frame = CGRectMake(0, 0, width, height);
    } else if (offsetX > width) {
        imageview.frame = CGRectMake(width * 2, 0, width, height);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _flag = YES;
    CGFloat offsetX = scrollView.contentOffset.x;

    CGFloat width = self.container.frame.size.width;
    
    if (offsetX < width) {
        [self.container setContentOffset:CGPointMake(width * 2, 0) animated:NO];
    } else if (offsetX > width) {
        [self.container setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    [self cacheView];
}

- (UIImageView *)useView {
    
    UIImageView *tempImageview = [self.cachedViews anyObject];
    
    if (tempImageview) {
        [self.cachedViews removeObject:tempImageview];
    } else {
        // 新建UIImageView
        tempImageview = [self addImageView];
    }
    
    [self.usedViews addObject:tempImageview];
    [self.container addSubview:tempImageview];
    
    return tempImageview;
}

- (void)cacheView {
    
    [self.usedViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, BOOL * _Nonnull stop) {
        if (!CGPointEqualToPoint(obj.frame.origin, self.container.contentOffset)) {
            [self.cachedViews addObject:obj];
            [obj removeFromSuperview];
            [self.usedViews removeObject:obj];
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

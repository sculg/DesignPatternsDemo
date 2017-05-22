//
//  HorizontalScrollerView.h
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HorizontalScrollerView;
@protocol HorizontalScrollerViewDelegete <NSObject>
@required
//返回页面展示的水平滑块的数目
- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScrollerView*)scroller;
//返回index上对应的view
- (UIView*)horizontalScroller:(HorizontalScrollerView*)scroller viewAtIndex:(int)index;
//通知代理那个view被点击
- (void)horizontalScroller:(HorizontalScrollerView*)scroller clickedViewAtIndex:(int)index;
@optional
//设置初始化时默认显示的内容
- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScrollerView*)scroller;

@end
@interface HorizontalScrollerView : UIView

@property (assign) id<HorizontalScrollerViewDelegete> delegate;

- (void)reload;
@end

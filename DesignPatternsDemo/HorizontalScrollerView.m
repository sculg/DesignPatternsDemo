//
//  HorizontalScrollerView.m
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import "HorizontalScrollerView.h"

#define VIEW_PADDING 10
#define VIEW_DIMENSIONS 160
#define VIEWS_OFFSET 100


@interface HorizontalScrollerView () <UIScrollViewDelegate>
@end

@implementation HorizontalScrollerView{
    UIScrollView *scroller;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.delegate = self;
        [self addSubview:scroller];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)scrollerTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:gesture.view];
    for (int index=0; index<[self.delegate numberOfViewsForHorizontalScroller:self]; index++)
    {
        UIView *view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location))
        {
            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
            break;
        }
    }
}


- (void)reload
{
    // 1 、如果没有委托，那么不需要做任何事情，仅仅返回即可。
    if (self.delegate == nil) return;
    
    // 2 、移除之前添加到滚动视图的子视图
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    // 3 、所有的视图的位置从给定的偏移量开始。当前的偏移量是100，它可以通过改变文件头部的#DEFINE来很容易的调整。
    CGFloat xValue = VIEWS_OFFSET;
    for (int i=0; i<[self.delegate numberOfViewsForHorizontalScroller:self]; i++)
    {
        // 4 、HorizontalScroller每次从委托请求视图对象，并且根据预先设置的边框来水平的放置这些视图。
        xValue += VIEW_PADDING;
        UIView *view = [self.delegate horizontalScroller:self viewAtIndex:i];
        view.frame = CGRectMake(xValue, VIEW_PADDING, VIEW_DIMENSIONS, VIEW_DIMENSIONS+50);
        [scroller addSubview:view];
        xValue += VIEW_DIMENSIONS+VIEW_PADDING;
    }
    
    // 5、 一旦所有视图都设置好了以后，设置UIScrollerView的内容偏移（contentOffset）以便用户可以滚动的查看所有的专辑封面。
    [scroller setContentSize:CGSizeMake(xValue+VIEWS_OFFSET, self.frame.size.height)];
    
    // 6 、 HorizontalScroller检测是否委托实现了initialViewIndexForHorizontalScroller:方法，这个检测是需要的，因为这个方法是可选的。如果委托没有实现这个方法，0就是缺省值。最后设置滚动视图为协议规定的初始化视图的中间。
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)])
    {
        int initialView = (int)[self.delegate initialViewIndexForHorizontalScroller:self];
        [scroller setContentOffset:CGPointMake(initialView*(VIEW_DIMENSIONS+(2*VIEW_PADDING)), 0) animated:YES];
    }
}

- (void)didMoveToSuperview
{
    [self reload];
}

- (void)centerCurrentView
{
    int xFinal = scroller.contentOffset.x + (VIEWS_OFFSET/2) + VIEW_PADDING;
//    NSLog(@"scroller.contentOffset.x:%f",scroller.contentOffset.x);
//    NSLog(@"xFinal:%d",xFinal);
    int viewIndex = xFinal / (VIEW_DIMENSIONS+(2*VIEW_PADDING));
//    NSLog(@"viewIndex:%d",viewIndex);
    xFinal = viewIndex * (VIEW_DIMENSIONS+(2*VIEW_PADDING));
//    NSLog(@"xFinal:%d",xFinal);
    [scroller setContentOffset:CGPointMake(xFinal,0) animated:YES];
    [self.delegate horizontalScroller:self clickedViewAtIndex:viewIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self centerCurrentView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerCurrentView];
}


@end

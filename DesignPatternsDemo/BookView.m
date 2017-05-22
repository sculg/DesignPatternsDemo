//
//  BookView.m
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import "BookView.h"

@implementation BookView{
    UIImageView *coverImage;
    UIActivityIndicatorView *indicator;
}

-(id)initWithFrame:(CGRect)frame BookCover:(NSString *)bookCover{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        [self addSubview:coverImage];
        
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        
        [coverImage addObserver:self
                     forKeyPath:@"image"
                        options:0
                        context:nil];
        [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLDownloadImageNotification"
                                                            object:self
                                                          userInfo:@{@"imageView":coverImage, @"coverUrl":bookCover}];
    }
    return self;
}
- (void)dealloc
{
    [coverImage removeObserver:self forKeyPath:@"image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"image"])
    {
        [indicator stopAnimating];
    }
}


@end

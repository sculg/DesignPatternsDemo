//
//  LibraryAPI.m
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import "LibraryAPI.h"
#import "HTTPClient.h"
#import "OperationManager.h"

@implementation LibraryAPI{
    OperationManager *operationManager;
    HTTPClient *httpClient;
    BOOL isOnline;
}
+ (LibraryAPI*)sharedInstance{
    // 1、声明一个静态变量去保存类的实例，确保它在类中的全局可用性。
    static LibraryAPI *_sharedInstance = nil;
    
    // 2、声明一个静态变量dispatch_once_t ,它确保初始化器代码只执行一次
    static dispatch_once_t oncePredicate;
    
    /*3、使用Grand Central Dispatch(GCD)执行初始化LibraryAPI变量的block.
    这正是单例模式的关键：一旦类已经被初始化，初始化器永远不会再被调用。*/
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        operationManager = [[OperationManager alloc] init];
        httpClient = [[HTTPClient alloc] init];
        isOnline = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(downloadImage:) name:@"BLDownloadImageNotification"
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)downloadImage:(NSNotification*)notification
{
    // 1
    UIImageView *imageView = notification.userInfo[@"imageView"];
    NSString *coverUrl = notification.userInfo[@"coverUrl"];
    NSLog(@"%@",coverUrl);
    // 2
    imageView.image = [operationManager getImage:[coverUrl lastPathComponent]];
    
    if (imageView.image == nil)
    {
        // 3
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [httpClient downloadImage:coverUrl];
            
            // 4
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [operationManager saveImage:image filename:[coverUrl lastPathComponent]];
            });
        });
    }
}


- (NSArray *)getBooks{
    return [operationManager getBooks];
}
- (void)addBook:(Book *)book atIndex:(int)index{
    [operationManager addBook:book atIndex:index];
    if (isOnline) {
        [httpClient postRequest:@"/api/addAlbum" body:[book description]];

    }
}
- (void)deleteBookAtIndex:(int)index{
    [operationManager deleteBookAtIndex:index];
    if (isOnline) {
        [httpClient postRequest:@"/api/deleteAlbum" body:[@(index) description]];
    }
}

- (void)saveBooks
{
    [operationManager saveBooks];
}

@end

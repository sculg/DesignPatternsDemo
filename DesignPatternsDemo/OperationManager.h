//
//  OperationManager.h
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Book.h"
@interface OperationManager : NSObject
- (NSArray *)getBooks;
- (void)addBook:(Book *)book atIndex:(int)index;
- (void)deleteBookAtIndex:(int)index;
- (void)saveImage:(UIImage*)image filename:(NSString*)filename;
- (UIImage*)getImage:(NSString*)filename;
- (void)saveBooks;
@end

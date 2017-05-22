//
//  LibraryAPI.h
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
@interface LibraryAPI : NSObject
+ (LibraryAPI*)sharedInstance;
- (NSArray *)getBooks;
- (void)addBook:(Book *)book atIndex:(int)index;
- (void)deleteBookAtIndex:(int)index;
- (void)saveBooks;
@end

//
//  Book.h
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject
//book的相关属性
@property (nonatomic, copy, readonly) NSString *name, *author, *type, *country, *coverUrl;
//book的实例初始化方法
-(id)initWithName:(NSString *)name author:(NSString *)author type:(NSString *)type country:(NSString *)country coverUrl:(NSString*)coverUrl;
@end

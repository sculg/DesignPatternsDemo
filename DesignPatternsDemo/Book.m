//
//  Book.m
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import "Book.h"

@implementation Book

-(id)initWithName:(NSString *)name author:(NSString *)author type:(NSString *)type country:(NSString *)country coverUrl:(NSString*)coverUrl{
    self = [super init];
    if (self) {
        _name = name;
        _author =author;
        _type = type;
        _country = country;
        _coverUrl = coverUrl;
    }
    return self;
}
//编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.coverUrl forKey:@"coverUrl"];
    [aCoder encodeObject:self.country forKey:@"country"];
}
//解码
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _author = [aDecoder decodeObjectForKey:@"author"];
        _type = [aDecoder decodeObjectForKey:@"type"];
        _coverUrl = [aDecoder decodeObjectForKey:@"coverUrl"];
        _country = [aDecoder decodeObjectForKey:@"country"];
    }
    return self;
}

@end

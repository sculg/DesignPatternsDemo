//
//  Book+TableRepresentation.m
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import "Book+TableRepresentation.h"

@implementation Book (TableRepresentation)
- (NSDictionary*)tr_tableRepresentation
{
    return @{@"titles":@[@"书名", @"作者", @"类型", @"国家"],
             @"values":@[self.name, self.author, self.type, self.country]};
}
@end

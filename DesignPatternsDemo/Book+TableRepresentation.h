//
//  Book+TableRepresentation.h
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import "Book.h"

@interface Book (TableRepresentation)
- (NSDictionary*)tr_tableRepresentation;
@end

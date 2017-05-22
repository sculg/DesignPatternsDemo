//
//  OperationManager.m
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import "OperationManager.h"

@interface OperationManager(){
    NSMutableArray *books;
}

@end
@implementation OperationManager

-(id)init{
    self = [super init];
    if (self) {
        NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/albums.bin"]];
        books = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (books == nil)
        {
            books = [NSMutableArray arrayWithArray:@[[[Book alloc] initWithName:@"《城南旧事》" author: @"林海音" type:@"小说" country:@"中国台湾" coverUrl:@"https://imgsa.baidu.com/baike/c0%3Dbaike220%2C5%2C5%2C220%2C73/sign=c36898c8b851f819e5280b18bbdd2188/8b13632762d0f7036bf58b3f00fa513d2797c58a.jpg"],
                                                     [[Book alloc] initWithName:@"《飞鸟集》" author: @"泰戈尔" type:@"诗歌" country:@"印度" coverUrl:@"https://img5.doubanio.com/lpic/s8847406.jpg"],
                                                     [[Book alloc] initWithName:@"《百年孤独》" author: @"加西亚·马尔克斯" type:@"魔幻现实主义小说" country:@"哥伦比亚" coverUrl:@"https://img3.doubanio.com/lpic/s6384944.jpg"],
                                                     [[Book alloc] initWithName:@"《追风筝的人》" author: @"卡勒德·胡赛尼" type:@"小说" country:@"美国" coverUrl:@"https://img3.doubanio.com/view/ark_article_cover/retina/public/1162265.jpg?v=1395394775.0"],
                                                     [[Book alloc] initWithName:@"《撒哈拉的故事》" author: @"三毛" type:@"散文" country:@"中国" coverUrl:@"https://img3.doubanio.com/lpic/s3563113.jpg"],
                                                     [[Book alloc] initWithName:@"《小王子》" author: @" 圣埃克苏佩里" type:@"童话" country:@"法国" coverUrl:@"https://img1.doubanio.com/lpic/s1237549.jpg"],
                                                     [[Book alloc] initWithName:@"《老人与海》" author: @"海明威" type:@"小说" country:@"美国" coverUrl:@"https://imgsa.baidu.com/baike/c0%3Dbaike92%2C5%2C5%2C92%2C30/sign=299442b3800a19d8df0e8c575293e9ee/2f738bd4b31c870144a0a9e4277f9e2f0708ff9a.jpg"],
                                                     [[Book alloc] initWithName:@"《罗密欧与朱丽叶》" author: @"莎士比亚" type:@"戏剧" country:@"英国" coverUrl:@"https://imgsa.baidu.com/baike/c0%3Dbaike220%2C5%2C5%2C220%2C73/sign=61527d10b751f819e5280b18bbdd2188/8b13632762d0f703c9cf6ee70ffa513d2697c588.jpg"],
                                                     [[Book alloc] initWithName:@"《围城》" author: @"钱钟书" type:@"小说" country:@"中国" coverUrl:@"https://imgsa.baidu.com/baike/c0%3Dbaike72%2C5%2C5%2C72%2C24/sign=48f873fc0f2442a7ba03f5f7b02ac62e/d62a6059252dd42afe9d48d4033b5bb5c9eab83d.jpg"],
                                                     [[Book alloc] initWithName:@"《三体》" author: @"刘慈欣" type:@"科幻小说" country:@"中国" coverUrl:@"https://img1.doubanio.com/lpic/s2768378.jpg"]
                                                     ]];
        }
    }
    return self;
}

- (NSArray *)getBooks{
    return books;
}

- (void)addBook:(Book *)book atIndex:(int)index{
    if (books.count >= index)
        [books insertObject:book atIndex:index];
    else
        [books addObject:book];
}
- (void)deleteBookAtIndex:(int)index{
    
    [books removeObjectAtIndex:index];
}

- (void)saveImage:(UIImage*)image filename:(NSString*)filename
{
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:filename atomically:YES];
}

- (UIImage*)getImage:(NSString*)filename
{
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    //    NSLog(@"%@",filename);
    NSData *data = [NSData dataWithContentsOfFile:filename];
    return [UIImage imageWithData:data];
}

- (void)saveBooks
{
    NSString *filename = [NSHomeDirectory() stringByAppendingString:@"/Documents/albums.bin"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:books];
    [data writeToFile:filename atomically:YES];
}


@end

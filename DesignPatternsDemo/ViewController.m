//
//  ViewController.m
//  DesignPatternsDemo
//
//  Created by lg on 16/12/26.
//  Copyright © 2016年 xiaoniu66. All rights reserved.
//

#import "ViewController.h"
#import "LibraryAPI.h"
#import "Book+TableRepresentation.h"
#import "LibraryAPI.h"
#import "HorizontalScrollerView.h"
#import "BookView.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, HorizontalScrollerViewDelegete>
@end

@implementation ViewController{
    UITableView *myTableView;
    NSArray *allBooks;
    NSDictionary *currentBookData;
    int currentBookIndex;
    HorizontalScrollerView *scroller;
    
    UIToolbar *toolbar;
    NSMutableArray *undoStack;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTitle];
    
    self.view.backgroundColor = [UIColor whiteColor];
    currentBookIndex = 0;
    allBooks = [[LibraryAPI sharedInstance] getBooks];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStyleGrouped];
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundView = nil;
    [self.view addSubview:myTableView];
    
    [self loadPreviousState];
    
    scroller = [[HorizontalScrollerView alloc] initWithFrame:CGRectMake(0, 59, self.view.frame.size.width, 240)];
    scroller.backgroundColor = [UIColor colorWithRed:0.24f green:0.35f blue:0.49f alpha:1];
    scroller.delegate = self;
    [self.view addSubview:scroller];
    
    [self showDataForBookAtIndex:currentBookIndex];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    toolbar = [[UIToolbar alloc] init];
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc] initWithTitle:@"撤回"  style: UIBarButtonItemStylePlain target:self action:@selector(undoAction)];
    undoItem.enabled = NO;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithTitle:@"删除" style: UIBarButtonItemStylePlain target:self action:@selector(deleteAlbum)];
    [toolbar setItems:@[undoItem,space,delete]];
    [self.view addSubview:toolbar];
    undoStack = [[NSMutableArray alloc] init];
    
}

-(void)setUpTitle{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.5-40, 18, 80, 35)];
    title.text = @"我的书单";
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:19];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}
- (void)viewWillLayoutSubviews
{
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
    myTableView.frame = CGRectMake(0, 290, self.view.frame.size.width, self.view.frame.size.height - 200);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)reloadScroller
{
    allBooks = [[LibraryAPI sharedInstance] getBooks];
    if (currentBookIndex < 0) currentBookIndex = 0;
    else if (currentBookIndex >= (int)allBooks.count) currentBookIndex = (int)allBooks.count-1;
    [scroller reload];
    
    [self showDataForBookAtIndex:currentBookIndex];
}

- (void)showDataForBookAtIndex:(int)bookIndex
{
    // defensive code: make sure the requested index is lower than the amount of albums
    if (currentBookIndex < allBooks.count)
    {
        // fetch the album
        Book *book = allBooks[currentBookIndex];
        // save the albums data to present it later in the tableview
        currentBookData = [book tr_tableRepresentation];
        
        
    }
    else
    {
        currentBookData = nil;
    }
    
    // we have the data we need, let's refresh our tableview
    [myTableView reloadData];
}

- (void)saveCurrentState
{
    [[NSUserDefaults standardUserDefaults] setInteger:currentBookIndex forKey:@"currentAlbumIndex"];
    [[LibraryAPI sharedInstance] saveBooks];
}

- (void)loadPreviousState
{
    currentBookIndex = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"currentAlbumIndex"];
    [self showDataForBookAtIndex:currentBookIndex];
}

#pragma mark - Album collection actions
- (void)addAlbum:(Book *)book atIndex:(int)index
{
    [[LibraryAPI sharedInstance] addBook:book atIndex:index];
    currentBookIndex = index;
    [self reloadScroller];
}

- (void)deleteAlbum
{
    if(allBooks.count >= 1){
        // 1、获取需要删除的书单
        Book *deletedBook = allBooks[currentBookIndex];
        // 2、定义了一个类型为NSMethodSignature的对象去创建NSInvocation,它将用来撤销删除操作。NSInvocation需要知道三件事情：选择器（发送什么消息），目标对象（发送消息的对象），还有就是消息所需要的参数。在上面的例子中，消息是与删除方法相反的操作，因为当你想撤销删除的时候，你需要将刚删除的数据回加回去。
        NSMethodSignature *sig = [self methodSignatureForSelector:@selector(addAlbum:atIndex:)];
        NSInvocation *undoAction = [NSInvocation invocationWithMethodSignature:sig];
        [undoAction setTarget:self];
        [undoAction setSelector:@selector(addAlbum:atIndex:)];
        [undoAction setArgument:&deletedBook atIndex:2];
        [undoAction setArgument:&currentBookIndex atIndex:3];
        [undoAction retainArguments];
        
        // 3、创建了undoAction以后，你需要将其增加到undoStack中。撤销操作将被增加在数组的末尾。
        [undoStack addObject:undoAction];
        
        // 4、使用LibraryAPI删除专辑,然后重新加载滚动视图。
        [[LibraryAPI sharedInstance] deleteBookAtIndex:currentBookIndex];
        [self reloadScroller];
        // 5、因为在撤销栈中已经有了操作，你需要使得撤销按钮可用。
        [toolbar.items[0] setEnabled:YES];
    }
    if(allBooks.count == 1){
        [toolbar.items[2] setEnabled:NO];
    }
   
}

- (void)undoAction
{
    if (undoStack.count > 0)
    {
        NSInvocation *undoAction = [undoStack lastObject];
        [undoStack removeLastObject];
        [undoAction invoke];
        [toolbar.items[2] setEnabled:YES];
    }
    
    if (undoStack.count == 0)
    {
        [toolbar.items[0] setEnabled:NO];
    }
}

#pragma mark - UITableViewDelegate 代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentBookData[@"titles"] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = currentBookData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentBookData[@"values"][indexPath.row];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - HorizontalScrollerDelegate 代理方法
- (void)horizontalScroller:(HorizontalScrollerView *)scroller clickedViewAtIndex:(int)index
{
    currentBookIndex = index;
    [self showDataForBookAtIndex:index];
}

- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScrollerView *)scroller
{
    return allBooks.count;
}

- (UIView*)horizontalScroller:(HorizontalScrollerView *)scroller viewAtIndex:(int)index
{
    
    Book *book = allBooks[index];
    return [[BookView alloc] initWithFrame:CGRectMake(0, 0, 160, 210) BookCover:book.coverUrl];
    
}

- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScrollerView *)scroller
{
    return currentBookIndex;
}


@end

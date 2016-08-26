//
//  LoopImageView.m
//  LoopImageDemo
//
//  Created by sf on 16/7/19.
//  Copyright © 2016年 Mr_Zhao. All rights reserved.
//

#import "LoopImageView.h"
static NSString *identifier = @"BSCell";
@implementation LoopImageView

- (instancetype)initWithFrame:(CGRect)frame ContentImages:(NSArray *)contentImages{
    self = [super initWithFrame:frame];
    if (self) {
        [self parseData:contentImages];
        [self createSubviews];
        UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealLongPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)parseData:(NSArray *)images{
    _isTimed = NO;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:images];
    [temp addObject:[images firstObject]];
    [temp insertObject:[images lastObject] atIndex:0];
    self.contentImages = temp;
}

- (void)createSubviews{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, height);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView.collectionViewLayout = layout;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, height) collectionViewLayout:layout];
    [self addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    [_collectionView setContentOffset:CGPointMake(width, 0)];

    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((width - 150) / 2,height - 20, 150, 20)];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.numberOfPages = self.contentImages.count - 2;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
    
}

- (void)setisTimed:(BOOL)isTimed WithTimerInterval:(CGFloat)timerInterval{

    if (isTimed == YES) {
        _isTimed = YES;
        CGFloat interval = 3.0;
        if (timerInterval > 0) {
            interval = timerInterval;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(scrollViewSetContentOffsetX) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark scrollViewDelagate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSUInteger index = scrollView.contentOffset.x / self.frame.size.width;
    _pageControl.currentPage = index - 1;
    if (self.isTimed) {
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollViewSetContentOffsetX) userInfo:nil repeats:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if (point.x == 0) {
        [scrollView setContentOffset:CGPointMake(self.frame.size.width * (self.contentImages.count - 2), 0)];
    }else if (point.x == self.frame.size.width * (self.contentImages.count - 1)){
        [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
    }
    _pageControl.currentPage = scrollView.contentOffset.x / self.frame.size.width - 1;
}

#pragma mark collectionViweDelagate&DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier  forIndexPath:indexPath];
    @autoreleasepool {
        cell.contentView.layer.contents = (id)[self imageWithFullFileName:self.contentImages[indexPath.item]].CGImage;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isTimed) {
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollViewSetContentOffsetX) userInfo:nil repeats:YES];
    }

}

#pragma mark-ScrollSetContentX
- (void)scrollViewSetContentOffsetX{
    
    [_collectionView setContentOffset:CGPointMake(_collectionView.contentOffset.x + self.frame.size.width, 0) animated:YES];
}

- (UIImage *)imageWithFullFileName:(NSString *)strFileName {
        
        NSString *strResourcesBundlePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"bundle"];
        
        NSString *strFilePath = [NSString pathWithComponents:@[strResourcesBundlePath , strFileName]];
        return [UIImage imageWithContentsOfFile:[strFilePath stringByAppendingString:@".png"]];
}

-(void)dealLongPress:(UILongPressGestureRecognizer*)longPress{
    
    if(longPress.state==UIGestureRecognizerStateEnded){
        
        _timer.fireDate=[NSDate distantPast];
        
        
    }
    if(longPress.state==UIGestureRecognizerStateBegan){
        
        _timer.fireDate=[NSDate distantFuture];
    }
  
}

@end

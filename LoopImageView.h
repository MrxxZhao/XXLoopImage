//
//  LoopImageView.h
//  LoopImageDemo
//
//  Created by sf on 16/7/19.
//  Copyright © 2016年 Mr_Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopImageView : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>{
    UICollectionView *_collectionView;
    UIPageControl *_pageControl;
}
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic,strong) NSArray *contentImages;
@property (readonly,assign) BOOL isTimed;


- (instancetype)initWithFrame:(CGRect)frame ContentImages:(NSArray *)contentImages;
- (void)setisTimed:(BOOL)isTimed WithTimerInterval:(CGFloat)timerInterval;

@end

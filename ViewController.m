//
//  ViewController.m
//  LoopImage-Demo
//
//  Created by sf on 16/8/24.
//  Copyright © 2016年 Yaphets. All rights reserved.
//

#import "ViewController.h"

#import "LoopImageView.h"

@interface ViewController ()
@property (nonatomic, strong) LoopImageView *loopImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.loopImageView];
}

-(LoopImageView *)loopImageView{
    if (!_loopImageView) {
        NSMutableArray *imgArray = [NSMutableArray array];
        for (int i = 1; i < 9; i++) {
            [imgArray addObject:[NSString stringWithFormat:@"head%zd",i]];
        }
        _loopImageView = [[LoopImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) ContentImages:imgArray];

        [_loopImageView setisTimed:YES WithTimerInterval:3.0];
    }
    return _loopImageView;
}

-(void)dealloc{
    if ([self.loopImageView.timer isValid]) {
        [self.loopImageView.timer invalidate];
        self.loopImageView.timer = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

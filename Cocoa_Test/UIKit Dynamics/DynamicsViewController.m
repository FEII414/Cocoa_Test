//
//  DynamicsViewController.m
//  Cocoa_Test
//
//  Created by feii on 17/3/10.
//  Copyright © 2017年 feii. All rights reserved.
//

#import "DynamicsViewController.h"

@interface DynamicsViewController ()

@property (nonatomic , strong) UIDynamicAnimator *animator;
@property (nonatomic , strong) UIImageView *oneStarImg;

@end

@implementation DynamicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我是Dynamics";
//    self.title = @"我是Dynamics";设置tabbaritem 和 navigationItem 的title
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self setGravityAnimator];

}

- (void)setGravityAnimator{
    
    [self.view addSubview:self.oneStarImg];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[self.oneStarImg]];
    [gravityBehavior setGravityDirection:CGVectorMake(0.1, 0.1)]; //设置重力方向
    
    [self.animator addBehavior:gravityBehavior];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark /***懒加载***/

- (UIDynamicAnimator*)animator{
    
    if (_animator == nil) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    }
    return _animator;
}

- (UIImageView*)oneStarImg{
    
    if (_oneStarImg == nil) {
        _oneStarImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tab-1"]];
        _oneStarImg.frame = CGRectMake(0, 64, 60, 60);
        _oneStarImg.backgroundColor = [UIColor clearColor];
    }
    return _oneStarImg;
}


@end

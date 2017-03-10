//
//  BaseTabBarViewController.m
//  Cocoa_Test
//
//  Created by feii on 17/3/10.
//  Copyright © 2017年 feii. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationViewController.h"
#import "DynamicsViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DynamicsViewController *dynamicsVc = [[DynamicsViewController alloc]init];
    dynamicsVc.tabBarItem.title = @"tab 1";
    dynamicsVc.tabBarItem.image = [UIImage imageNamed:@"tab-1"];
//    dynamicsVc.tabBarItem.badgeValue = @"123";
    
    BaseNavigationViewController *dynamicsNav = [[BaseNavigationViewController alloc]initWithRootViewController:dynamicsVc];
    [self addChildViewController:dynamicsNav];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end

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
#import "CollectionViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor blueColor];
    
    DynamicsViewController *dynamicsVc = [[DynamicsViewController alloc]init];
    
    [self addViewControllers:dynamicsVc withTitle:@"tab 1" withDefaultImage:[UIImage imageNamed:@"tab-1"] withSelectedImage:[UIImage imageNamed:@"tab-1"]];
    
    CollectionViewController *collectionVc = [[CollectionViewController alloc]init];
    
    [self addViewControllers:collectionVc withTitle:@"tab 2" withDefaultImage:[UIImage imageNamed:@"tab-2"] withSelectedImage:nil];

}

- (void)addViewControllers:(UIViewController*)childControllers withTitle:(NSString*)title withDefaultImage:(UIImage*)defaultImage withSelectedImage:(UIImage*)selectedImage{
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:defaultImage selectedImage:selectedImage];
    childControllers.tabBarItem = tabBarItem;
    if (selectedImage) {
        childControllers.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
//    childControllers.tabBarItem.badgeValue
    BaseNavigationViewController *dynamicsNav = [[BaseNavigationViewController alloc]initWithRootViewController:childControllers];
    [self addChildViewController:dynamicsNav];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end

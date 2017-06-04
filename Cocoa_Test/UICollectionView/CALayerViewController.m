//
//  CALayerViewController.m
//  Cocoa_Test
//
//  Created by feii on 17/6/4.
//  Copyright © 2017年 feii. All rights reserved.
//

#import "CALayerViewController.h"
#import "ShapedImageView.h"

@interface CALayerViewController ()

@property (nonatomic , strong) ShapedImageView *shapeView;
@property (nonatomic , assign) int flat;

@end

@implementation CALayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.opaque = NO;
    _flat = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.shapeView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"change layer" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 420, SCREEN_WIDTH, 30);
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(changeLayer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)changeLayer:(UIButton*)button{
    
    if (_flat==0) {
        _flat++;
        [_shapeView layerTwo];
        [_shapeView setImage:[UIImage imageNamed:@"second"]];
    }else if (_flat==1) {
        _flat++;
        [_shapeView layerThree];
        [_shapeView setImage:[UIImage imageNamed:@"third"]];
    }else if (_flat==2) {
        _flat++;
        [_shapeView layerFour];
        [_shapeView setImage:[UIImage imageNamed:@"forth"]];
    }else if (_flat==3) {
        _flat = 0;
        [_shapeView layerOne];
        [_shapeView setImage:[UIImage imageNamed:@"first"]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (ShapedImageView*)shapeView{
    
    if (_shapeView==nil) {
        _shapeView = [[ShapedImageView alloc]initWithFrame:CGRectMake(60, 100, 200 , 300)];
        [_shapeView setImage:[UIImage imageNamed:@"first"]];
    }
    return _shapeView;
    
}

@end

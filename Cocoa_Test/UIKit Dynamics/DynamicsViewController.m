//
//  DynamicsViewController.m
//  Cocoa_Test
//
//  Created by feii on 17/3/10.
//  Copyright © 2017年 feii. All rights reserved.
//

#import "DynamicsViewController.h"
#import "STCarouselScrollView.h"

@interface DynamicsViewController ()

@property (nonatomic , strong) UIDynamicAnimator *animator;
@property (nonatomic , strong) UIImageView *oneStarImg;

@property (nonatomic,strong)STCarouselScrollView *imageScrollView;
@property (nonatomic,strong)NSMutableArray *getUrlImg;
@property (nonatomic,strong)NSMutableArray *getUrlImgSize;//网络上捉取图片大小
@property (nonatomic,assign)CGFloat tempH2 ;

@end

@implementation DynamicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我是Dynamics";
//    self.title = @"我是Dynamics";设置tabbaritem 和 navigationItem 的title
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self setGravityAnimator];
    
    if (!_getUrlImg) {
        _getUrlImg = [[NSMutableArray alloc]init];
        _getUrlImgSize = [[NSMutableArray alloc]init];
    }else{
        [_getUrlImg removeAllObjects];
        [_getUrlImgSize removeAllObjects];
    }
    
    NSArray *arrayPathImage = @[@"first",@"second",@"third",@"forth",@"fifth",@"sixth"];
    NSArray *arrayHeight = @[@200,@420,@250,@220,@400,@300];
    
//    for (NSString *dicT in arrayPathImage) {
//        
//        CGSize imgSize;
//        NSString *urlImg = [NSString stringWithFormat:@"%@", dicT];
//        NSRange lastIndex = [urlImg rangeOfString:@"@" options:NSBackwardsSearch];
//        if (lastIndex.location != NSNotFound) {
//            NSString *ratioStr = [urlImg substringWithRange:NSMakeRange(lastIndex.location + 1, 4)];
//            CGFloat ratio = [ratioStr floatValue];
//            imgSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH / ratio);
//        } else {
//            imgSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
//        }
//        float height = imgSize.height/imgSize.width*SCREEN_WIDTH;
//        [_getUrlImgSize addObject:@(height)];
//        [_getUrlImg addObject:urlImg];
//    }
    
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.imageScrollView];
    [self.imageScrollView setImageArray:arrayPathImage andHeightArray:arrayHeight didScroll:^(CGRect currentFrame) {
        
        float height = currentFrame.size.height;
        weakSelf.tempH2 = height;
        
    } endScroll:^(NSUInteger currentIndex) {
        
        
    }];

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

-(STCarouselScrollView*)imageScrollView{
    if (!_imageScrollView) {
        _imageScrollView = [[STCarouselScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 123)];
    }
    return _imageScrollView;
}

@end

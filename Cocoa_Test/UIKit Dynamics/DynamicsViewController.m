//
//  DynamicsViewController.m
//  Cocoa_Test
//
//  Created by feii on 17/3/10.
//  Copyright © 2017年 feii. All rights reserved.
//

#import "DynamicsViewController.h"
#import "STCarouselScrollView.h"
#import "Masonry.h"
#import "SVProgressHUD.h"

#define FIRST_TITLE  @"本地"
#define LAST_TITLE   @"网络"

@interface DynamicsViewController ()

@property (nonatomic , strong) UIDynamicAnimator *animator;
@property (nonatomic , strong) UIImageView *oneStarImg;

@property (nonatomic,strong)STCarouselScrollView *imageScrollView;
@property (nonatomic,strong)STCarouselScrollView *imageDemandScrollView;
@property (nonatomic,strong)NSMutableArray *getUrlImg;
@property (nonatomic,strong)NSMutableArray *getUrlImgSize;//网络上捉取图片大小
@property (nonatomic,assign)CGFloat tempH2 ;
@property (nonatomic,strong)UILabel *labelFrame;

@property (nonatomic,strong)UIView *topNavigationView;
@property (nonatomic,strong)UIButton *buttonShare;
@property (nonatomic,strong)UIButton  *buttonDemand;
@property (nonatomic,strong)UIView *viewLine;

@property (nonatomic,strong)UIView *shareVc;
@property (nonatomic,strong)UIView *demandVc;
@property (nonatomic,assign)BOOL isDemand;

@end

@implementation DynamicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我是Dynamics";
    
    self.navigationItem.titleView = self.topNavigationView;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.title = @"我是Dynamics";设置tabbaritem 和 navigationItem 的title
    self.view.backgroundColor = [UIColor purpleColor];
    
    if (!_getUrlImg) {
        _getUrlImg = [[NSMutableArray alloc]init];
        _getUrlImgSize = [[NSMutableArray alloc]init];
    }else{
        [_getUrlImg removeAllObjects];
        [_getUrlImgSize removeAllObjects];
    }
    
    _labelFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 350, 300, 30)];
    _labelFrame.text = @"我来试试frame";
    ;
    
    [self.view addSubview:self.shareVc];
    [self.view addSubview:self.demandVc];
    self.demandVc.hidden = YES;
    _isDemand = NO;
    
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

-(STCarouselScrollView*)imageScrollView{
    if (!_imageScrollView) {
        _imageScrollView = [[STCarouselScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 123)];
        _imageScrollView.clickBlock = ^(int index){
            NSLog(@"11111---%u",index);
//            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"点击本地图片－－%u",index+1]];
//            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"点击本地图片－－%u",index+1]];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"点击本地图片－－%u",index+1]];
        };
    }
    return _imageScrollView;
}
-(STCarouselScrollView*)imageDemandScrollView{
    if (!_imageDemandScrollView) {
        _imageDemandScrollView = [[STCarouselScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 123)];
        _imageDemandScrollView.clickBlock = ^(int index){
            NSLog(@"22222---%u",index);
            [SVProgressHUD setMinimumDismissTimeInterval:0.2];
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"点击网络图片－－%u",index+1]];
        };
    }
    return _imageDemandScrollView;
}

-(UIView *)topNavigationView{
    
    if (_topNavigationView == nil) {
        _topNavigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        _topNavigationView.backgroundColor = [UIColor clearColor];
        
        _buttonDemand = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonDemand setTitle:@"网络" forState:UIControlStateNormal];
        [_buttonDemand setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_buttonDemand addTarget:self action:@selector(clickedDemand) forControlEvents:UIControlEventTouchUpInside];
        _buttonDemand.titleLabel.font = [UIFont systemFontOfSize:16];
        
        _buttonShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonShare setTitle:@"本地" forState:UIControlStateNormal];
        [_buttonShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buttonShare addTarget:self action:@selector(clickedShare) forControlEvents:UIControlEventTouchUpInside];
        _buttonShare.titleLabel.font = [UIFont systemFontOfSize:16];
        
        _viewLine = [[UIView alloc]initWithFrame:CGRectMake(2, 43, 33, 1)];
        _viewLine.backgroundColor = [UIColor blueColor];
        
        [_topNavigationView addSubview:_buttonShare];
        [_topNavigationView addSubview:_buttonDemand];
        [_topNavigationView addSubview:_viewLine];
        
        [_buttonShare mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(2);
            make.size.mas_equalTo(CGSizeMake(33, 18));
        }];
        [_buttonDemand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.right.mas_equalTo(-2);
            make.size.mas_equalTo(CGSizeMake(33, 18));
        }];
    }
    return _topNavigationView;
}

-(void)clickedShare{
    
    [self setLineHeaderViewAnimationX:_buttonShare.frame.origin.x andWidth:_buttonShare.frame.size.width];
    [_buttonShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonDemand setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.shareVc.hidden = NO;
    self.demandVc.hidden = YES;
    
}

-(void)clickedDemand{
    
    [self setLineHeaderViewAnimationX:_buttonDemand.frame.origin.x andWidth:_buttonDemand.frame.size.width];
    [_buttonShare setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_buttonDemand setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (!_isDemand) {
        
        [self.view addSubview:self.demandVc];
        _isDemand = YES;
    }
    self.shareVc.hidden = YES;
    self.demandVc.hidden = NO;
    
}

-(void)setLineHeaderViewAnimationX:(float)x andWidth:(float)width{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    _viewLine.frame = CGRectMake(x, 43, width, 1);
    [UIView commitAnimations];
    
}

-(UIView*)shareVc{
    if (_shareVc==nil) {
        _shareVc = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _shareVc.backgroundColor = [UIColor whiteColor];
        NSArray *arrayPathImage = @[@"first",@"second",@"third",@"forth",@"fifth",@"sixth"];
        NSArray *arrayHeight = @[@200,@420,@250,@220,@400,@300];
        __weak typeof(self) weakSelf = self;
        [_shareVc addSubview:self.imageScrollView];
        [self.imageScrollView setImageArray:arrayPathImage andHeightArray:arrayHeight didScroll:^(CGRect currentFrame) {
            
            float height = currentFrame.size.height;
            weakSelf.tempH2 = height;
            
        } endScroll:^(NSUInteger currentIndex) {
            
            
        }];

    }
    return _shareVc;
}

-(UIView*)demandVc{
    if (_demandVc==nil) {
        _demandVc = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _demandVc.backgroundColor = [UIColor whiteColor];
        NSArray *arrayPathImage = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496560383&di=502a2114db6d8b6d107bb75665cd25f8&imgtype=jpg&er=1&src=http%3A%2F%2Fmvimg2.meitudata.com%2F54df0726b204b5760.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495965668810&di=9edffbb9cd61f818618bcce6df517f7f&imgtype=0&src=http%3A%2F%2Fimage142-c.poco.cn%2Fmypoco%2Fmyphoto%2F20130713%2F21%2F659346182013071321162601.jpg%3F900x600_120",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495965668810&di=a3d581f0550602fd114dae1258e1de2a&imgtype=0&src=http%3A%2F%2Fmvimg2.meitudata.com%2F56b3fa3b235b63332.jpg"];
        NSArray *arrayHeight = @[@420,@220,@300];
        __weak typeof(self) weakSelf = self;
        [_demandVc addSubview:self.imageDemandScrollView];
        [self.imageDemandScrollView setImageArray:arrayPathImage andHeightArray:arrayHeight didScroll:^(CGRect currentFrame) {
            
            float height = currentFrame.size.height;
            weakSelf.tempH2 = height;
            
        } endScroll:^(NSUInteger currentIndex) {
            
            
        }];
        
    }
    return _demandVc;
}

@end

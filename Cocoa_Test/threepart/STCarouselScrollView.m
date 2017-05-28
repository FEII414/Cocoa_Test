//
//  STCarouselScrollView.m
//  dploffice
//
//  Created by feii on 17/1/11.
//  Copyright © 2017年 com. All rights reserved.
//

#import "STCarouselScrollView.h"
#import "UIImageView+WebCache.h"
#define SELF_WIDTH CGRectGetWidth(self.frame)
#define SELF_MINX  CGRectGetMinX(self.frame)
#define SELF_MINY  CGRectGetMinY(self.frame)

#define PAGE_WIDTH 45
#define PAGE_HEIGHT 12
#define PAGE_FONT 12
#define PAGE_PADDING_WIDTH 11.5
#define PAGE_PADDING_HEIGHT 18

@interface STCarouselScrollView()<UIScrollViewDelegate>

@property (nonatomic , copy) DidScrollBlock didScrollBlock;//滑动回调
@property (nonatomic , copy) EndScrollBlock endScrollBlock;//结束回调
//三个ImageView 左右滑动
@property (nonatomic , strong) UIImageView *middleView;
@property (nonatomic , strong) UIImageView *rightView;
@property (nonatomic , strong) UIImageView *leftView;

@property (nonatomic , strong) NSMutableArray *arrayImage;
@property (nonatomic , strong) NSMutableArray *arrayHeight;
@property (nonatomic , assign) NSUInteger arrayCount;//图片总数
@property (nonatomic , strong) UILabel *labelPage;//显示页数码
//数组的下标
@property (nonatomic , assign) int currentIndex;
@property (nonatomic , assign) int nextIndex;

@property (nonatomic , assign) bool isChange;//是否让middleView返回中间位置X
@property (nonatomic , assign) bool isNext;//是否下一张图片
@property (nonatomic , assign) bool isLocalImagesArray;

@end

@implementation STCarouselScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    [self addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.leftView];
    [self.mainScrollView addSubview:self.middleView];
    [self.mainScrollView addSubview:self.rightView];
    [self addSubview:self.labelPage];
    
    self.mainScrollView.bounces = NO;
    self.mainScrollView.delegate = self;
    _currentIndex = 0;
    
}

- (void)setImageArray:(NSMutableArray *)arrayImage andHeightArray:(NSMutableArray *)arrayHeight didScroll:(DidScrollBlock)didScrollBlock endScroll:(EndScrollBlock)endScrollBlock{
    
    self.arrayImage = arrayImage;
    self.arrayHeight = arrayHeight;
    self.arrayCount = arrayImage.count;
    self.didScrollBlock = didScrollBlock;
    self.endScrollBlock =  endScrollBlock;
    [self initializeFlyout];
    
}

- (void)initializeFlyout{
    
    self.mainScrollView.frame = CGRectMake(0, 0, SELF_WIDTH, [_arrayHeight[_currentIndex] floatValue]);
    self.frame = CGRectMake(SELF_MINX, SELF_MINY, SELF_WIDTH, [_arrayHeight[_currentIndex] floatValue]);
    self.labelPage.frame = CGRectMake(SELF_WIDTH - PAGE_PADDING_WIDTH - PAGE_WIDTH , [_arrayHeight[_currentIndex] floatValue]-PAGE_PADDING_HEIGHT-PAGE_HEIGHT, PAGE_WIDTH, PAGE_HEIGHT);
    self.labelPage.text = [NSString stringWithFormat:@"1/%ld",_arrayCount];
    self.mainScrollView.pagingEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:_arrayImage[0]];
    if (!image) {
        _isLocalImagesArray = NO;
    }else{
        _isLocalImagesArray = YES;
    }
    
    
    if (self.arrayCount == 1) {
        
        [self setImageView:self.leftView withIndex:_currentIndex];
        self.leftView.frame = CGRectMake(0, 0, SELF_WIDTH, [_arrayHeight[_currentIndex] floatValue]);
        
        self.mainScrollView.contentSize = CGSizeMake(SELF_WIDTH, 0);
        
    }else{
        
        [self setImageView:self.leftView withIndex:_currentIndex];
        self.leftView.frame = CGRectMake(0, 0, SELF_WIDTH, [_arrayHeight[_currentIndex] floatValue]);
        
        [self setImageView:self.middleView withIndex:_currentIndex+1];
        self.middleView.frame = CGRectMake(SELF_WIDTH, 0, SELF_WIDTH, [_arrayHeight[_currentIndex+1] floatValue]);
        self.mainScrollView.contentSize = CGSizeMake(SELF_WIDTH*2, 0);
        
    }
    
    self.tag = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
    [self addGestureRecognizer:tap];
}

- (void)setImageView:(UIImageView*)imageView withIndex:(int)imageIndex{
    
    if (_isLocalImagesArray) {
        //添加将要出现视图的本地图片
        imageView.image = [UIImage imageNamed:self.arrayImage[imageIndex]];
    }else{
        //添加将要出现视图的网络图片  需要 #import "UIImageView+WebCache.h"
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.arrayImage[imageIndex]]];
    }
    
}

#pragma UIScrollVIewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.mainScrollView) {
        
        float offsetX = scrollView.contentOffset.x;
        
        if (_currentIndex == 0){
            if (offsetX>0) {
                _nextIndex = _currentIndex + 1;
                if (_nextIndex == _arrayCount) {
                    _nextIndex = 0;
                }
                //            [self setImageView:_middleView withIndex:_nextIndex];
                
                float heightMiddle = [_arrayHeight[_currentIndex] floatValue];
                float heightRight = [_arrayHeight[_nextIndex] floatValue];
                float heightTempt;
                if (heightMiddle > heightRight) {
                    heightTempt = heightMiddle - (heightMiddle - heightRight) / SELF_WIDTH * offsetX;
                }else{
                    heightTempt = heightMiddle + (heightRight - heightMiddle) / SELF_WIDTH * offsetX;
                }
                
                self.leftView.frame = CGRectMake(0, 0, SELF_WIDTH, heightTempt);
                self.middleView.frame = CGRectMake(SELF_WIDTH*1, 0, SELF_WIDTH, heightTempt);
                self.mainScrollView.frame = CGRectMake(0, 0, SELF_WIDTH, heightTempt);
                self.frame = CGRectMake(SELF_MINX, SELF_MINY, SELF_WIDTH, heightTempt);
                self.labelPage.frame = CGRectMake(SELF_WIDTH - PAGE_PADDING_WIDTH - PAGE_WIDTH , heightTempt-PAGE_PADDING_HEIGHT-PAGE_HEIGHT, PAGE_WIDTH, PAGE_HEIGHT);
                NSLog(@"我是第一个开始");
            }
        }else if (_currentIndex == (_arrayCount - 1)){
            
            if (offsetX<SELF_WIDTH) {
                //图片右滑
                _nextIndex = _currentIndex - 1;
                if (_nextIndex == -1) {
                    _nextIndex = (int)_arrayCount - 1;
                }
                
                float heightMiddle = [_arrayHeight[_currentIndex] floatValue];
                float heightLeft = [_arrayHeight[_nextIndex] floatValue];
                float heightTempt;
                if(_arrayCount >2){
                    if (heightMiddle > heightLeft) {
                        heightTempt = heightMiddle - (heightMiddle - heightLeft) / SELF_WIDTH * (SELF_WIDTH - offsetX );
                    }else{
                        heightTempt = heightMiddle + (heightLeft - heightMiddle) / SELF_WIDTH * (SELF_WIDTH - offsetX);
                    }
                    self.middleView.frame = CGRectMake(SELF_WIDTH*0, 0, SELF_WIDTH, heightTempt);
                    self.rightView.frame = CGRectMake(SELF_WIDTH, 0, SELF_WIDTH, heightTempt);
                    NSLog(@"我是最后一个结束--大于2");
                }else{
                    if (heightMiddle > heightLeft) {
                        heightTempt = heightMiddle - (heightMiddle - heightLeft) / SELF_WIDTH * (SELF_WIDTH - offsetX);
                    }else{
                        heightTempt = heightMiddle + (heightLeft - heightMiddle) / SELF_WIDTH * (SELF_WIDTH - offsetX);
                    }
                    self.leftView.frame = CGRectMake(SELF_WIDTH*0, 0, SELF_WIDTH, heightTempt);
                    self.middleView.frame = CGRectMake(SELF_WIDTH, 0, SELF_WIDTH, heightTempt);
                    NSLog(@"我是最后一个结束--等于2");
                }
                self.mainScrollView.frame = CGRectMake(0, 0, SELF_WIDTH, heightTempt);
                self.frame = CGRectMake(SELF_MINX, SELF_MINY, SELF_WIDTH, heightTempt);
                self.labelPage.frame = CGRectMake(SELF_WIDTH - PAGE_PADDING_WIDTH - PAGE_WIDTH , heightTempt-PAGE_PADDING_HEIGHT-PAGE_HEIGHT, PAGE_WIDTH, PAGE_HEIGHT);
            }
        }else if ( offsetX > SELF_WIDTH) {
            //图片左滑
            _nextIndex = _currentIndex + 1;
            if (_nextIndex == _arrayCount) {
                _nextIndex = 0;
            }
            [self setImageView:_rightView withIndex:_nextIndex];
            
            float heightMiddle = [_arrayHeight[_currentIndex] floatValue];
            float heightRight = [_arrayHeight[_nextIndex] floatValue];
            float heightTempt;
            if (heightMiddle > heightRight) {
                heightTempt = heightMiddle - (heightMiddle - heightRight) / SELF_WIDTH * (offsetX - SELF_WIDTH);
            }else{
                heightTempt = heightMiddle + (heightRight - heightMiddle) / SELF_WIDTH * (offsetX - SELF_WIDTH);
            }
            self.middleView.frame = CGRectMake(SELF_WIDTH, 0, SELF_WIDTH, heightTempt);
            self.rightView.frame = CGRectMake(SELF_WIDTH*2, 0, SELF_WIDTH, heightTempt);
            self.mainScrollView.frame = CGRectMake(0, 0, SELF_WIDTH, heightTempt);
            self.frame = CGRectMake(SELF_MINX, SELF_MINY, SELF_WIDTH, heightTempt);
            self.labelPage.frame = CGRectMake(SELF_WIDTH - PAGE_PADDING_WIDTH - PAGE_WIDTH , heightTempt-PAGE_PADDING_HEIGHT-PAGE_HEIGHT, PAGE_WIDTH, PAGE_HEIGHT);
            NSLog(@"我是中间左滑");
            
        }else if ( offsetX < SELF_WIDTH){
            //图片右滑
            _nextIndex = _currentIndex - 1;
            if (_nextIndex == -1) {
                _nextIndex = (int)_arrayCount - 1;
            }
            [self setImageView:_leftView withIndex:_nextIndex];
            
            float heightMiddle = [_arrayHeight[_currentIndex] floatValue];
            float heightLeft = [_arrayHeight[_nextIndex] floatValue];
            float heightTempt;
            if (heightMiddle > heightLeft) {
                heightTempt = heightMiddle - (heightMiddle - heightLeft) / SELF_WIDTH * (SELF_WIDTH - offsetX);
            }else{
                heightTempt = heightMiddle + (heightLeft - heightMiddle) / SELF_WIDTH * (SELF_WIDTH - offsetX);
            }
            self.middleView.frame = CGRectMake(SELF_WIDTH, 0, SELF_WIDTH, heightTempt);
            self.leftView.frame = CGRectMake(SELF_WIDTH*0, 0, SELF_WIDTH, heightTempt);
            self.mainScrollView.frame = CGRectMake(0, 0, SELF_WIDTH, heightTempt);
            self.frame = CGRectMake(SELF_MINX, SELF_MINY, SELF_WIDTH, heightTempt);
            self.labelPage.frame = CGRectMake(SELF_WIDTH - PAGE_PADDING_WIDTH - PAGE_WIDTH , heightTempt-PAGE_PADDING_HEIGHT-PAGE_HEIGHT, PAGE_WIDTH, PAGE_HEIGHT);
            NSLog(@"我是中间右滑");
        }
        
        //如果滑动没有超过一半或者没有滑到左右顶点，才更换middleView位置X
        
        if (_currentIndex == 0 ) {
            _isNext = NO;
            _isChange = NO;
            if (offsetX > SELF_WIDTH/2) {
                _isNext = YES;
                if (_arrayCount!=2) {
                    _isChange = YES;
                    //                _currentIndex = _nextIndex;
                    //                    return;
                }
            }
            
        }else if(_currentIndex == _arrayCount-1){
            
            _isNext = NO;
            _isChange = NO;
            double difValue = fabs(offsetX - SELF_WIDTH);
            if (difValue > SELF_WIDTH/2) {
                _isNext = YES;
                if (_arrayCount!=2) {
                    _isChange = YES;
                    //                _currentIndex = _nextIndex;
                    //                    return;
                }
            }
            
        }
        else{
            double difValue = fabs(offsetX - SELF_WIDTH);
            NSLog(@"offseX-%f==difValue-%f==SELF_WIDTH-%f",offsetX,difValue,SELF_WIDTH);
            if(difValue < SELF_WIDTH/2 || (_nextIndex == 0 || _nextIndex == (_arrayCount - 1))){
                
                _isNext = NO;
                if (difValue >= SELF_WIDTH/2) {
                    _isNext = YES;
                }
                _isChange = NO;
                
            }else{
                _isNext = YES;
                _isChange = YES;
                //                _currentIndex = _nextIndex;
                
            }
        }
        
        if (_didScrollBlock) {
            
            self.didScrollBlock(self.frame);
            
        }
    }
}

- (void)clickTap:(UITapGestureRecognizer*)tap{
    
    if (_clickBlock) {
        _clickBlock((int)tap.view.tag);
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (_isNext == YES) {
        
        _currentIndex = _nextIndex;
        if (_isChange == YES) {
            [self setImageView:_middleView withIndex:_nextIndex];
            self.mainScrollView.contentSize = CGSizeMake(SELF_WIDTH*3, 0);
            CGRect rect = self.middleView.frame;
            rect.origin.x = SELF_WIDTH;
            self.middleView.frame = rect;
            
            rect.origin.x = SELF_WIDTH*0;
            self.leftView.frame = rect;
            
            rect.origin.x = SELF_WIDTH*2;
            self.rightView.frame = rect;
            
            self.mainScrollView.contentOffset = CGPointMake(SELF_WIDTH, 0);
            
        }
    }
    NSLog(@"我是现在的图片%u",_currentIndex);
    self.tag = _currentIndex;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
    [self addGestureRecognizer:tap];
    self.labelPage.text = [NSString stringWithFormat:@"%u/%ld",_currentIndex+1,_arrayCount];
    if (_endScrollBlock) {
        self.endScrollBlock(_currentIndex);
    }
    if(_currentIndex == 0 || _currentIndex == _arrayCount - 1){
        self.mainScrollView.contentSize = CGSizeMake(SELF_WIDTH*2, 0);
        if (_currentIndex == _arrayCount-1 && _arrayCount>2) {
            CGRect rect = self.rightView.frame;
            rect.origin.x = 0;
            self.middleView.frame = rect;
            rect.origin.x = SELF_WIDTH*1;
            self.rightView.frame = rect;
            rect.origin.x = -SELF_WIDTH;
            self.leftView.frame = rect;
        }
    }
}

-(void)setPageHidden{
    
    self.labelPage.hidden = YES;
}

#pragma 懒加载

- (UIImageView*)middleView{
    
    if (_middleView==nil) {
        _middleView = [[UIImageView alloc]init];
        _middleView.frame = self.bounds;
    }
    return _middleView;
}

- (UIImageView*)rightView{
    
    if (_rightView==nil) {
        _rightView = [[UIImageView alloc]init];
        _rightView.frame = self.bounds;
    }
    return _rightView;
}

- (UIImageView*)leftView{
    
    if (_leftView==nil) {
        _leftView = [[UIImageView alloc]init];
        _leftView.frame = self.bounds;
    }
    return _leftView;
}
- (UILabel*)labelPage{
    
    if (_labelPage==nil) {
        _labelPage = [[UILabel alloc]init];
        //        _labelPage.text = @"1/1";
        _labelPage.font = [UIFont systemFontOfSize:PAGE_FONT];
        _labelPage.textAlignment = NSTextAlignmentRight;
        _labelPage.textColor = [UIColor whiteColor];
        //        _labelPage.backgroundColor = [UIColor blackColor];
    }
    return _labelPage;
}
- (UIScrollView*)mainScrollView{
    if (_mainScrollView==nil) {
        _mainScrollView = [[UIScrollView alloc]init];
        _mainScrollView.showsVerticalScrollIndicator = NO;//垂直线不显示
        _mainScrollView.showsHorizontalScrollIndicator = NO;//水平线不显示
    }
    return _mainScrollView;
}

@end

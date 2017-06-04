//
//  ShapedImageView.m
//  Cocoa_Test
//
//  Created by feii on 17/6/4.
//  Copyright © 2017年 feii. All rights reserved.
//

#import "ShapedImageView.h"

@interface ShapedImageView()
{
    CALayer      *_contentLayer;
    CAShapeLayer *_maskLayer;
}

@end

@implementation ShapedImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.frame = self.bounds;
    _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;
    
    if (_contentLayer==nil) {
        _contentLayer = [CALayer layer];
    }
    _contentLayer.mask = _maskLayer;
    _contentLayer.frame = self.bounds;
    [self.layer addSublayer:_contentLayer];
    
    
}

- (void)layerOne{
    
    _maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.frame = self.bounds;
    _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;
    
//    if (_contentLayer==nil) {
//        _contentLayer = [CALayer layer];
//    }
//    _contentLayer.mask = _maskLayer;
//    _contentLayer.frame = self.bounds;
//    [self.layer addSublayer:_contentLayer];
    
}

- (void)layerTwo{
    
    _maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:20].CGPath;
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.frame = self.bounds;
    _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;                 //非常关键设置自动拉伸的效果且不变形
    
//    if (_contentLayer==nil) {
//        _contentLayer = [CALayer layer];
//    }
//    _contentLayer.mask = _maskLayer;
//    _contentLayer.frame = self.bounds;
//    [self.layer addSublayer:_contentLayer];
}

- (void)layerThree{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint origin = self.bounds.origin;
    CGFloat radius = CGRectGetWidth(self.bounds) / 2;
    CGPathMoveToPoint(path, NULL, origin.x, origin.y + 2 *radius);
    CGPathMoveToPoint(path, NULL, origin.x, origin.y + radius);
    
    CGPathAddArcToPoint(path, NULL, origin.x, origin.y, origin.x + radius, origin.y, radius);
    CGPathAddArcToPoint(path, NULL, origin.x + 2 * radius, origin.y, origin.x + 2 * radius, origin.y + radius, radius);
    CGPathAddArcToPoint(path, NULL, origin.x + 2 * radius, origin.y + 2 * radius, origin.x + radius, origin.y + 2  * radius, radius);
    CGPathAddLineToPoint(path, NULL, origin.x, origin.y + 2 * radius);
    
    _maskLayer.path = path;
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor clearColor].CGColor;
    _maskLayer.frame = self.bounds;
    _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;                 //非常关键设置自动拉伸的效果且不变形
    
//    if (_contentLayer==nil) {
//        _contentLayer = [CALayer layer];
//    }
//    _contentLayer.mask = _maskLayer;
//    _contentLayer.frame = self.bounds;
//    [self.layer addSublayer:_contentLayer];
}

- (void)layerFour{
    
    _maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0].CGPath;
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.frame = self.bounds;
    _maskLayer.contentsCenter = CGRectMake(1, 1, 1, 1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;                 //非常关键设置自动拉伸的效果且不变形
    
//    if (_contentLayer==nil) {
//        _contentLayer = [CALayer layer];
//    }
//
//    _contentLayer.mask = _maskLayer;
//    _contentLayer.frame = self.bounds;
//    [self.layer addSublayer:_contentLayer];
    
}

- (void)setImage:(UIImage *)image
{
    _contentLayer.contents = nil;
    _contentLayer.contents = (id)image.CGImage;
}

@end

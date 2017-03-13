//
//  CustomCollectionViewFlowLayout.m
//  Cocoa_Test
//
//  Created by feii on 17/3/13.
//  Copyright © 2017年 feii. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"

@implementation CustomCollectionViewFlowLayout

static float const MinValue = 50.0f;

// 对layoutAttrute根据需要做调整，也许是frame,alpha,transform等
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 获取父类原先的(未放大形变的)attrsArray,我们要对其attr的frame属性做下调整
    NSArray *attrsArray = [super layoutAttributesForElementsInRect:rect];
    CGFloat centerX = self.collectionView.frame.size.width*0.5 + self.collectionView.contentOffset.x;
    
    for(UICollectionViewLayoutAttributes *attr in attrsArray)
    {
        CGFloat length = 0.f;
        if(attr.center.x > centerX)
        {
            length = attr.center.x - centerX;
        }
        else
        {
            length = centerX - attr.center.x;
        }
        
        CGFloat scale = 1 - length / self.collectionView.frame.size.width;
        
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return attrsArray;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 某cell滑动停止时的最终rect
    CGRect rect;
    rect.origin.x = proposedContentOffset.x;
    
    if (rect.origin.x == 0) {
        return proposedContentOffset;
    }
    
    rect.origin.y = 0.f;
    rect.size = self.collectionView.frame.size;
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 获得super已经计算好的布局属性
    CGFloat offset = 0.0f;
    NSArray *attrsArray = [super layoutAttributesForElementsInRect:rect];
    for(UICollectionViewLayoutAttributes *attr in attrsArray)
    {
//        if(0 <attr.center.x - centerX < MinValue || 0 < centerX - attr.center.x < MinValue)
//        {
//            offset = attr.center.x - centerX; // 此刻，cell的center的x和此刻CollectionView的中心点的距离
//            break;
//        }
        offset = attr.frame.origin.x;
        break;
    }
    
    proposedContentOffset.x = offset;
    
    return proposedContentOffset;
}

// 初始状态  添加没有结束状态
- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
    
    return attr;
}


// 终结状态  删除没有开始状态
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attr.alpha = 0.0f;
    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(2.0, 2.0), M_PI);
    
    return attr;
}

// 当布局属性改变时重新加载layout  当当前layout的布局发生变动时，是否重写加载该layout。默认返回NO，若返回YES，则重新执行这俩方法：
//- (void)prepareLayout;
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect;
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end

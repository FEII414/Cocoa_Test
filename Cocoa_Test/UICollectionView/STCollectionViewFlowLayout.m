//
//  STCollectionViewFlowLayout.m
//  dploffice
//
//  Created by shine-team2 on 16/9/14.
//  Copyright © 2016年 com. All rights reserved.
//

#import "STCollectionViewFlowLayout.h"

#define kSpace 5.0f
#define kItemWidth 100.0f
#define kHeightSpace 0.0f

#define kScale 0.3

#define Scale [UIScreen mainScreen].bounds.size.width / 320

@implementation STCollectionViewFlowLayout

- (void)prepareLayout {
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = kSpace;
    self.sectionInset = UIEdgeInsetsMake(0, kSpace, 0, 0);
    self.itemSize = CGSizeMake(kItemWidth, self.collectionView.frame.size.height - kHeightSpace * 2);
    [super prepareLayout];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];

    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    if (rowCount >= 3) {
    
        NSArray *attributes = [[NSArray alloc] initWithArray:superAttributes copyItems:YES];
        
        CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,
                                        0,
                                        SCREEN_WIDTH,
                                        140);
        CGFloat centerX = CGRectGetMidX(visibleRect);
        
        [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat distance = centerX - attribute.center.x;
            // 越靠近中心，值越小，缩放系数越小，显示越大
            // 越远离中心，值越大，缩放就越大，显示就越小
            CGFloat scaleHeight = distance / self.itemSize.height;
            
            CGFloat scale = (1 - kScale) + kScale * (1 - fabs(scaleHeight));
            attribute.transform3D = CATransform3DMakeScale(scale, scale, 1);
            attribute.zIndex = 0;
        }];
        
        return attributes;
    
    } else {
        for (UICollectionViewLayoutAttributes* attributes in superAttributes) {
            if (nil == attributes.representedElementKind) {
                NSIndexPath* indexPath = attributes.indexPath;
                attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
            }
        }
        
        return superAttributes;
    }
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity {
    // 确定停止时显示区域
    CGRect visibleRect;
    visibleRect.origin  = proposedContentOffset;
    visibleRect.size    = CGSizeMake(kItemWidth, 140);
    // 获取这个区域中心
    CGFloat centerX = CGRectGetMidX(visibleRect);
    // 获得这个区域内Item
    NSArray *arr = [super layoutAttributesForElementsInRect:visibleRect];
    
    CGFloat distance = MAXFLOAT;
    
    // 遍历寻找距离中心点最近的Item
    for (UICollectionViewLayoutAttributes *atts in arr) {
        
        
        if (fabs(centerX - atts.center.x) < distance) {
            
            distance = centerX - atts.center.x;
        }
    }
    // 补偿差值
    proposedContentOffset.x -= distance;
    
    //防止在第一个和最后一个  卡住
    if (proposedContentOffset.x < 0) {
        proposedContentOffset.x = 0;
    }
    if (proposedContentOffset.x > (self.collectionView.contentSize.width - self.sectionInset.left - self.sectionInset.right - self.itemSize.width)) {
        
        proposedContentOffset.x = floor(proposedContentOffset.x);
    }
    return proposedContentOffset;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    if (rowCount > 0 && rowCount < 3) {
        if (rowCount == 1) {
            CGPoint currentItemCenter = [currentItemAttributes center];
            currentItemCenter.x = SCREEN_WIDTH / 2;
            currentItemAttributes.center = currentItemCenter;
        } else if (rowCount == 2) {
            CGRect currentItemFrame = [currentItemAttributes frame];
            if (indexPath.row == 0) {
                // 最后一行第一个
                // (屏幕宽度 －（两个itemsize的宽度 ＋ 中间间隔）) / 2
                currentItemFrame.origin.x = SCREEN_WIDTH / 2 - 15 * Scale / 2 - kItemWidth * Scale;
            } else if (indexPath.row == 1) {
                // (屏幕宽度 － （两个itemsize的宽度 ＋ 中间间隔）) / 2 + 中间间隔 ＋ itemsize宽度
                currentItemFrame.origin.x = SCREEN_WIDTH / 2 + 15 * Scale / 2;
            }
            currentItemAttributes.frame = currentItemFrame;
        }
    }
    
    return currentItemAttributes;
}

//滚动的时会调用
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

@end

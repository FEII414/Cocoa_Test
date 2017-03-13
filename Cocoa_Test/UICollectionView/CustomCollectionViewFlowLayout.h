//
//  CustomCollectionViewFlowLayout.h
//  Cocoa_Test
//
//  Created by feii on 17/3/13.
//  Copyright © 2017年 feii. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CustomFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>
@end

@interface CustomCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id<CustomFlowLayoutDelegate> delegate;

@end

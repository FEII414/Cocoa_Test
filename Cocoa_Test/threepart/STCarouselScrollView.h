//
//  STCarouselScrollView.h
//  dploffice
//
//  Created by feii on 17/1/11.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DidScrollBlock)(CGRect currentFrame);
typedef void (^EndScrollBlock)(NSUInteger currentIndex);

@interface STCarouselScrollView : UIView

@property (nonatomic , strong) UIScrollView *mainScrollView;

@property (nonatomic , copy) void(^clickBlock)(int index);

/**
 * 用initWithFrame来初始化
 * - (instancetype)initWithFrame:(CGRect)frame;
 */

/**
 * 设置数据和回调函数
 *
 * @param arrayImage 传入图片数组
 * @param arrayHeight 传入图片高度数组
 * @param didScrollBlock 正在滑动时的回调
 * @param endScrollBlock 结束滑动后的回调
 *
 */
- (void)setImageArray:(NSMutableArray*)arrayImage andHeightArray:(NSMutableArray*)arrayHeight  didScroll:(DidScrollBlock)didScrollBlock endScroll:(EndScrollBlock)endScrollBlock;

/**
 *
 * 隐藏页数码
 */
- (void)setPageHidden;//

@end

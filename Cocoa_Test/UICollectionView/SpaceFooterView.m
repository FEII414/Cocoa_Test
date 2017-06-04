//
//  SpaceFooterView.m
//  dploffice
//
//  Created by shine-team2 on 16/9/14.
//  Copyright © 2016年 com. All rights reserved.
//

#import "SpaceFooterView.h"
#import "UIColor+Util.h"

@implementation SpaceFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews {
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45.0f)];
    _headerView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 15.0f, SCREEN_WIDTH - 30, 15.0f)];
    titleLabel.text = @"团队风采";
    titleLabel.textColor = [UIColor colorWithHex:0x999999];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_headerView addSubview:titleLabel];
    
    [self addSubview:_headerView];
}
@end

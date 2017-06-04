//
//  SpaceTeamCell.m
//  dploffice
//
//  Created by shine-team2 on 16/9/14.
//  Copyright © 2016年 com. All rights reserved.
//

#import "SpaceTeamCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"

@implementation SpaceTeamCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setSubviews];
        [self setLayout];
    }
    return self;
}

- (void)setSubviews {
    
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 60, 60)];
    _headImgView.layer.cornerRadius = 30.0f;
    _headImgView.layer.masksToBounds = YES;
    _headImgView.image = [UIImage imageNamed:@"loading"];
    [self.contentView addSubview:_headImgView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor colorWithHex:0x353536   ];
    _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:_nameLabel];
    
    _jobLabel = [[UILabel alloc]init];
    _jobLabel.textAlignment = NSTextAlignmentCenter;
    _jobLabel.textColor = [UIColor colorWithHex:0x999999];
    _jobLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_jobLabel];
}

- (void)setLayout {
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.right.mas_equalTo(-5.0f);
        make.top.mas_equalTo(_headImgView.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(18.0f);
        make.centerX.mas_equalTo(_headImgView.mas_centerX);
    }];
    
    [_jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.right.mas_equalTo(-5.0f);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(8.0f);
        make.height.mas_equalTo(10.0f);
        make.centerX.mas_equalTo(_headImgView.mas_centerX);
    }];
}
@end

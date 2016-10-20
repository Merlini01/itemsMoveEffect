//
//  HeadView.m
//  ItemsMove
//
//  Created by 王家亮 on 2016/10/18.
//  Copyright © 2016年 王家亮. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView{
    UILabel * _titleLabel;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addLabel];
    }
    return self;
}
- (void)addLabel{
    self.backgroundColor = [UIColor grayColor];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:_titleLabel];
}
- (void)setTitleLabelWithText:(NSString *)text{
    _titleLabel.text = text;
}
@end

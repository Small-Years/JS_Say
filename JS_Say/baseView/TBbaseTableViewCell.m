//
//  BaseTableViewCell.m
//  通知+单例+持久化 = 夜间模式
//
//  Created by 殷殷明静 on 16/10/29.
//  Copyright © 2016年 YMJ. All rights reserved.
//

#import "TBbaseTableViewCell.h"
@implementation TBbaseTableViewCell
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kChangeThemeNotification object:nil];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kChangeThemeNotification object:nil];
    }
    return self;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kChangeThemeNotification object:nil];
    }
    return self;
}
- (void)applyTheme {
    if ([ThemeManagement shareManagement].isDarkTheme) {
        self.backgroundColor = darkTableViewBgColor;
    
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end

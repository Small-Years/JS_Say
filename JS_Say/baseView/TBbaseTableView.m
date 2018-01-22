//
//  BaseTableView.m
//  通知+单例+持久化 = 夜间模式
//
//  Created by 殷殷明静 on 16/10/29.
//  Copyright © 2016年 YMJ. All rights reserved.
//

#import "TBbaseTableView.h"
@implementation TBbaseTableView
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
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyTheme) name:kChangeThemeNotification object:nil];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyTheme) name:kChangeThemeNotification object:nil];
    }
    return self;
}


- (void)applyTheme {
    if ([ThemeManagement shareManagement].isDarkTheme) {//夜间
        self.backgroundColor = darkTableViewBgColor;
        self.separatorColor = darkTableViewLineColor;
//        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;    //设置tablview滑动线条颜色
        
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.separatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.91 alpha:1];
//        self.indicatorStyle = UIScrollViewIndicatorStyleDefault;  //设置tablview滑动线条颜色
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

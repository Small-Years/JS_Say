//
//  BaseTableHeaderView.m
//  JS_Say
//
//  Created by yangjian on 2017/9/27.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "BaseTableHeaderView.h"

@implementation BaseTableHeaderView
-(instancetype)init{
    self = [super init];
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
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kChangeThemeNotification object:nil];
    }
    return self;
}

- (void)applyTheme {
    if ([ThemeManagement shareManagement].isDarkTheme) {
        self.backgroundColor = RGB(155, 155, 155);
    } else {
        self.backgroundColor = RGB(247, 247, 245);
    }
}

@end

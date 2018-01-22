//
//  ThemeManagement.m
//  JS_Say
//
//  Created by yangjian on 2017/9/25.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "ThemeManagement.h"
// 单例
static ThemeManagement *themeManagement;

@implementation ThemeManagement

+ (instancetype)shareManagement{
    if (themeManagement == nil) {
        themeManagement = [[ThemeManagement alloc]init];
        
        // 判断是否是夜间模式
        if ([[USER_DEFAULT objectForKey:@"isDark"]isEqualToString:@"YES"]) {
            themeManagement.isDarkTheme = YES;
        }else{
            themeManagement.isDarkTheme = NO;
        }
    }
    return themeManagement;
}


@end

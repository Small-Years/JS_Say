//
//  ThemeManagement.h
//  JS_Say
//
//  Created by yangjian on 2017/9/25.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManagement : NSObject

/** 是否是夜间模式 */
@property (nonatomic,assign) BOOL isDarkTheme;

+ (instancetype)shareManagement;

@end

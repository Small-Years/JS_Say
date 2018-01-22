//
//  TBNavigationController.m
//  TabbarBeyondClick
//
//  Created by 卢家浩 on 2017/4/17.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import "TBNavigationController.h"

@interface TBNavigationController ()<UINavigationBarDelegate>{
    
}

@end

@implementation TBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        
        if (iOS7) {
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"默认导航栏"] forBarMetrics:UIBarMetricsDefault];
        } else {
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"默认导航栏"] forBarMetrics:UIBarMetricsDefault];
        }
    }
    //导航栏
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //判断是不是黑夜模式
    [self applyTheme];
    // 添加接收改变主题的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyTheme) name:kChangeThemeNotification object:nil];
}

- (void)applyTheme {
    if ([ThemeManagement shareManagement].isDarkTheme) {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:RGB(155, 155, 155) forKey:NSForegroundColorAttributeName];
        self.navigationBar.titleTextAttributes = dict;
        
    } else {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        self.navigationBar.titleTextAttributes = dict;
    }
}

- (void)popToBack{
    [self popViewControllerAnimated:YES];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}


@end

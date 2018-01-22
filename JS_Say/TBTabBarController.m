//
//  TBTabBarController.m
//  TabbarBeyondClick
//
//  Created by 卢家浩 on 2017/4/17.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import "TBTabBarController.h"
#import "TBNavigationController.h"

#import "TBVideoViewController.h"
#import "TBChatViewController.h"

#import "PhotoViewController.h"
#import "recommendViewController.h"

#import "EDEmptyDataSetPlaceholderView.h"
#import "AppDelegate.h"
#import "ItemViewController.h"
#import "VideoViewController.h"

#import "mainWaterFlowViewController.h"

@interface TBTabBarController ()


@end


@implementation TBTabBarController
#pragma mark - 侧滑
- (void)openLeftViewController {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.leftSlideVC.closed) {
        [tempAppDelegate.leftSlideVC openLeftView];
    }else {
        [tempAppDelegate.leftSlideVC closeLeftView];
    }
}

#pragma mark - view methods
//在页面即将出现的时候开启侧滑，在即将消失的时候关闭侧滑
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:NO];
}


-(void)addLunch{
    EDEmptyDataSetPlaceholderView *placeholderView = [EDEmptyDataSetPlaceholderView placeholder];
    
    [placeholderView appendImage:[UIImage imageNamed:@"qi"] completion:^(UIImageView *imageView, CGFloat *offset, CGFloat *height) {
        *offset = 0;
    }];
    
    placeholderView.frame = [[self view] bounds];
    
    self.view.backgroundColor = [UIColor blackColor];
    [[self view] addSubview:placeholderView];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    double delay = 2; // 延迟多少秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), queue, ^{
        // 3秒后需要执行的任务
        [placeholderView removeFromSuperview];
        
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addLunch];
    // 初始化所有控制器
    recommendViewController *soldierVC = [[recommendViewController alloc] init];

    [self setChildVC:soldierVC title:@"推荐" image:@"tabbar_info_nor" selectedImage:@"tabbar_info_sel"];
    
//    TBVideoViewController *homeVC = [[TBVideoViewController alloc] init];
//    [self setChildVC:homeVC title:@"短视频" image:@"tabbar_video_nor" selectedImage:@"tabbar_video_sel"];
    
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    [self setChildVC:videoVC title:@"短视频" image:@"tabbar_video_nor" selectedImage:@"tabbar_video_sel"];
    
    
//    TBFindViewController *findVC = [[TBFindViewController alloc] init];
//    [self setChildVC:findVC title:@"广场" image:@"tabbar_find_nor" selectedImage:@"tabbar_find_sel"];
    
//    TBChatViewController *chatVC = [[TBChatViewController alloc] init];
//    [self setChildVC:chatVC title:@"广场" image:@"tabbar_find_nor" selectedImage:@"tabbar_find_sel"];

    
//    WeaponsViewController *myVC = [[WeaponsViewController alloc] init];
//    [self setChildVC:myVC title:@"武器库" image:@"tabbar_weapon_nor" selectedImage:@"tabbar_weapon_sel"];
    //图库
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    [self setChildVC:photoVC title:@"图库" image:@"tabbar_weapon_nor" selectedImage:@"tabbar_weapon_sel"];
    
    //壁纸
    mainWaterFlowViewController *myVC = [[mainWaterFlowViewController alloc] init];
    [self setChildVC:myVC title:@"壁纸" image:@"tabbar_image_nor" selectedImage:@"tabbar_image_sel"];
    
    // 进来的时候根据单例的主题，显示相应的主题
    [self changeTheme];
    // 添加接收改变主题的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTheme) name:kChangeThemeNotification object:nil];
}

#pragma mark - changeThemeMethod
-(void)changeTheme{
    if ([ThemeManagement shareManagement].isDarkTheme) {
        [[UITabBar appearance] setBarTintColor:darkTableViewBgColor];
    }else{
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    }
}


- (void) setChildVC:(UIViewController *)childVC title:(NSString *) title image:(NSString *) image selectedImage:(NSString *) selectedImage {
    
    childVC.tabBarItem.title = title;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    TBNavigationController *nav = [[TBNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"item name = %@", item.title);
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index == 0) {
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.leftSlideVC setPanEnabled:YES];
    }else{
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.leftSlideVC setPanEnabled:NO];
    }
    [self animationWithIndex:index];
    if([item.title isEqualToString:@"发现"]){
        // 也可以判断标题,然后做自己想做的事<img alt="得意" src="http://static.blog.csdn.net/xheditor/xheditor_emot/default/proud.gif" />
    }
}
- (void)animationWithIndex:(NSInteger) index {
    
    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount = 1;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:0.7];
    pulse.toValue = [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
}


@end

//
//  twoVideoViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/17.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "VideoViewController.h"
#import "DCNavTabBarController.h"

#import "TBVideoViewController.h"
#import "oneViewController.h"
#import "twoViewController.h"
#import "threeViewController.h"



@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"短视频";
    self.navigationController.navigationBar.translucent = NO;
    
    TBVideoViewController *main = [[TBVideoViewController alloc]init];
    main.title = @"经典";
    oneViewController *one = [[oneViewController alloc]init];
    one.title = @"推荐";
    twoViewController *two = [[twoViewController alloc]init];
    two.title = @"热门";
    
    NSArray *subViewControllers = @[one,main,two];
    DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
    tabBarVC.topBarColor = RGB(227, 227, 227);
    tabBarVC.view.frame = self.view.frame;
//    tabBarVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64-44-40);
    
    [self.view addSubview:tabBarVC.view];
    [self addChildViewController:tabBarVC];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}






@end

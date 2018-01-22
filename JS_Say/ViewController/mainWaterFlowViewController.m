//
//  mainWaterFlowViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/9/11.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "mainWaterFlowViewController.h"
#import "DCNavTabBarController.h"

#import "War_WaterFlow_ViewController.h"
#import "Technology_WaterFlowViewController.h"
#import "Other_WaterFlow_ViewController.h"

@interface mainWaterFlowViewController ()

@end

@implementation mainWaterFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精美壁纸";
    self.navigationController.navigationBar.translucent = NO;
    
    War_WaterFlow_ViewController *one = [[War_WaterFlow_ViewController alloc]init];
    one.title = @"军事";
    
    Technology_WaterFlowViewController *two = [[Technology_WaterFlowViewController alloc]init];
    two.title = @"科技";
    
    Other_WaterFlow_ViewController *three = [[Other_WaterFlow_ViewController alloc]init];
    three.title = @"创意";
    
    NSArray *subViewControllers = @[one,two,three];
    DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
//    tabBarVC.topBarColor = RGB(227, 227, 227);
    tabBarVC.view.frame = self.view.frame;
    
    [self.view addSubview:tabBarVC.view];
    [self addChildViewController:tabBarVC];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

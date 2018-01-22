//
//  AppDelegate.h
//  JS_Say
//
//  Created by yangjian on 2017/7/31.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
#import "TBNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TBNavigationController *mainNavigationController;
@property (nonatomic, strong) LeftSlideViewController *leftSlideVC;
@end


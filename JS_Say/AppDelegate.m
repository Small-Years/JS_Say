//
//  AppDelegate.m
//  JS_Say
//
//  Created by yangjian on 2017/7/31.
//  Copyright © 2017年 yangjian. All rights reserved.
//




#import "AppDelegate.h"
#import "TBTabBarController.h"
#import "LeftSortsViewController.h"
#import "showAlertViewController.h"
#import "GDTSplashAd.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,GDTSplashAdDelegate>

@property (strong, nonatomic) GDTSplashAd *splash;
@property (retain, nonatomic) UIView *bottomView;


@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self.window makeKeyAndVisible];
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
    
//    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    

    
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppKey];
    
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
        [NSThread sleepForTimeInterval:0.5]; // 设置启动页面停留时间
    
    TBTabBarController *mainVC = [[TBTabBarController alloc]init];
    self.mainNavigationController = [[TBNavigationController alloc]initWithRootViewController:mainVC];
    [self.mainNavigationController setNavigationBarHidden:YES];
//    self.window.rootViewController = mainVC;

    LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
    self.leftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    self.window.rootViewController = self.leftSlideVC;
    
    
//    [MobClick setLogEnabled:YES];
    
//    友盟统计设置
    UMConfigInstance.appKey = @"59a7d1e69f06fd7d13000c4b";
    UMConfigInstance.channelId = @"";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //友盟推送
    [UMessage startWithAppkey:@"59a7d1e69f06fd7d13000c4b" launchOptions:launchOptions httpsEnable:YES];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
            NSLog(@"点击允许");
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
            NSLog(@"点击不允许");
        }
    }];
    
    [UMessage setLogEnabled:YES];
    

//    //广点通广告拉取
//    //开屏广告初始化并展示代码
//    GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppkey:@"1105344611" placementId:@"9040714184494018"];
//    
//    splash.delegate = self; //设置代理 //根据iPhone设备不同设置不同背景图
//    if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
//        splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage-568h"]];
//    } else {
//        splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage
//                  imageNamed:@"LaunchImage"]]; }
//    splash.fetchDelay = 4; //开发者可以设置开屏拉取时间，超时则放弃展示 //[可选]拉取并展示全屏开屏广告
//    [splash loadAdAndShowInWindow:self.window];
//    //设置开屏底部自定义LogoView，展示半屏开屏广告
////    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
////    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashBottomLogo"]];
////    [_bottomView addSubview:logo];
////    logo.center = _bottomView.center; _bottomView.backgroundColor = [UIColor whiteColor];
////    
////    [splash loadAdAndShowInWindow:self.window withBottomView:_bottomView];
//    self.splash = splash;
    
    [AVOSCloud setApplicationId:@"N5VczpbzAAnsPzuav8gTLdo5-gzGzoHsz" clientKey:@"njIyOIz1KHug6tFbHd49qw7o"];
    
    return YES;
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

//友盟分享
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx15fe483db47981ad" appSecret:@"857a0c4e6da522a776e5c0ec9d93e9a4" redirectURL:nil];
    
    /* 设置QQ的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106365032"/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"477692920"  appSecret:@"563824367bc2534fd073a75376e6893b" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    /* 设置支付宝 */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:nil];
    
}

#pragma mark -GDTSplashAdDelegate

//开屏广告成功展示
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd{
    NSLog(@"开屏广告成功展示");
}
//开屏广告展示失败
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error{
    NSLog(@"开屏广告展示失败----%@",error);
}
//应用进入后台时回调
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd{
    NSLog(@"应用进入后台时回调");
}
//开屏广告点击回调
- (void)splashAdClicked:(GDTSplashAd *)splashAd{
    NSLog(@"开屏广告点击回调");
}
//开屏广告关闭回调
- (void)splashAdClosed:(GDTSplashAd *)splashAd{
    NSLog(@"开屏广告关闭回调");
}




//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        NSLog(@"++应用处于前台时的远程推送接受++++",userInfo);
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
//        应用在打开的时候，创建一个提示框就好了……
        
        
    }else{
        //应用处于前台时的本地推送接受
        NSLog(@"++应用处于前台时的本地推送接受++++++++%@",userInfo);
        
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
        NSLog(@"++应用处于后台时的远程推送接受+++%@",userInfo);
        NSDictionary *dd = [userInfo objectForKey:@"aps"];
        NSString *str = [dd objectForKey:@"url"];
        showAlertViewController *vc = [[showAlertViewController alloc]init];
        vc.urlStr = str;
        //获取到最上面的一层navigation，然后跳转
        [self.mainNavigationController pushViewController:vc animated:YES];
    }else{
        //应用处于后台时的本地推送接受
        NSLog(@"++应用处于后台时的本地推送接受+++%@",userInfo);
    }
}







-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

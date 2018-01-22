//
//  Header.h
//  JS_Say
//
//  Created by yangjian on 2017/8/1.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#ifndef Header_h
#define Header_h

/** 视频框的高度*/
#define VideoHeight 180

#define kTabbarHeight 49
#define kNavHeight 64

// 屏幕宽度
#define kScreenRect   [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 颜色的定义
#define RGB(r, g, b)  [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#define kMainPageDistance   100   //打开左侧窗时，中视图(右视图)露出的宽度
#define kMainPageScale   1.0  //打开左侧窗时，中视图(右视图）缩放比例
#define kMainPageCenter  CGPointMake(kScreenWidth + kScreenWidth * kMainPageScale / 2.0 - kMainPageDistance, kScreenHeight / 2)  //打开左侧窗时，中视图中心点

#define vCouldChangeDeckStateDistance  (kScreenWidth - kMainPageDistance) / 2.0 - 40 //滑动距离大于此数时，状态改变（关--》开，或者开--》关）
#define vSpeedFloat   0.7    //滑动速度

#define kLeftAlpha 0.9  //左侧蒙版的最大值
#define kLeftCenterX -50 //左侧初始偏移量
#define kLeftScale 1.0 //左侧初始缩放比例
//#define kLeftSwitchViewCenterX 0
#define vDeckCanNotPanViewTag    987654   // 不响应此侧滑的View的tag



#define kColorWithRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
//项目整体背景色
#define MCBaseColor kColorWithRGB(0xf6f6f6)
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define FONT(fontSize)                      [UIFont systemFontOfSize:fontSize]

#define Animation_ImageArray [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"Animation_1"], [UIImage imageNamed:@"Animation_2"],[UIImage imageNamed:@"Animation_3"] , [UIImage imageNamed:@"Animation_2"], nil]

//  iOS8打印不全的问题
#define CLog(format, ...)  NSLog(format, ## __VA_ARGS__)
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


//#define NSLog(format, ...) NSLog((@"[类名:%s]" "[行号:%d]  " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#define NSLog(format, ...);





//、、、、、、、、、、、、、、、、、、、、、、、数据问题、、、、、、、、、、、、、、、、、、、、、、、、

#define UMAppKey @"59a7d1e69f06fd7d13000c4b"

#define kMainUrl @"https://app.kanjunshi.net"//看军事APP网址

#define kPicUrl @"http://mobile.chinaiiss.com"//图库网址、短视频two





//夜间模式通知
#define kChangeThemeNotification @"ChangeTheme"

//tableView的夜间模式颜色
#define darkTableViewBgColor [UIColor colorWithRed:40/255.f green:40/255.f blue:51/255.f alpha:1.f] //[UIColor colorWithRed:0.15 green:0.15 blue:0.2 alpha:1]
/** 黑夜模式line颜色*/
#define darkTableViewLineColor [UIColor colorWithRed:155/255.f green:155/255.f blue:155/255.f alpha:1.f] //[UIColor colorWithRed:0.11 green:0.11 blue:0.16 alpha:1]







#endif

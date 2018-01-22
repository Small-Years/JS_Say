//
//  YJWebViewController.h
//  JS_Say
//
//  Created by yangjian on 2017/8/10.
//  Copyright © 2017年 yangjian. All rights reserved.
//




/** 这是创建webView，返回如果有上层界面，就一级级返回，入股是最上层界面，直接pop*/

#import <UIKit/UIKit.h>

@interface YJWebViewController : UIViewController<UIWebViewDelegate, NSURLConnectionDelegate>

//定义一个属性，方便外接调用
@property (nonatomic, strong) UIWebView *webView;

//声明一个方法，外接调用时，只需要传递一个URL即可
- (void)loadHTML:(NSString *)htmlString;


@end

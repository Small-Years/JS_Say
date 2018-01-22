//
//  WeaponsInfosViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/10.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "WeaponsInfoViewController.h"

@interface WeaponsInfoViewController ()

@end

@implementation WeaponsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    
    
    NSString *str = [self.infoDict objectForKey:@"name"];
    self.title = str;
    NSString *urlStr = [NSString stringWithFormat:@"https://baike.baidu.com/item/%@?fromtitle=%@&fromid=1838467",[AllMethod encodeString:str],[AllMethod encodeString:str]];
    
    [self loadHTML:urlStr];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIWebViewDelegate 
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('adpic')[0].style.display = 'none'"];
}


@end

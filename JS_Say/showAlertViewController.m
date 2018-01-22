//
//  showAlertViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/11.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "showAlertViewController.h"

@interface showAlertViewController ()<UIWebViewDelegate>{
    UIWebView *mainWebView;
}

@end

@implementation showAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推送";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [AllMethod getLeftButtonBarItemSelect:@selector(popView) andTarget:self];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    mainWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    mainWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainWebView];
    mainWebView.delegate = self;
    mainWebView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    NSURL* url = [NSURL URLWithString:self.urlStr];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [mainWebView loadRequest:request];//加载
    
    //不能只是加载url这么简单，需要获取到数据，然后去掉多余的部分
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *headerStr = @"document.getElementsByTagName('h1')[0].innerText = '测试文字';";
    [webView stringByEvaluatingJavaScriptFromString:headerStr];
    
    NSString *downLoadStr = @"document.getElementById('xiazaiapp').getElementsByTagName('a')[0].innerText = '下个鸡蛋';";
    [webView stringByEvaluatingJavaScriptFromString:downLoadStr];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

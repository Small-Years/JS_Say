//
//  WeaponsNewsInfoViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/12.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "WeaponsNewsInfoViewController.h"
#import "YJ_WebView.h"

@interface WeaponsNewsInfoViewController ()<shareBtnClickDelegate>{
    YJ_WebView *mainWebView;
}

@end

@implementation WeaponsNewsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [AllMethod getLeftButtonBarItemSelect:@selector(popView) andTarget:self];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
//    [mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.top.equalTo(self.view.mas_top).offset(0);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];

    
    NSString *urlStr = [self.infoDict objectForKey:@"url"];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *dict = responseObject;
        NSDictionary *contentDict = [dict objectForKey:@"post"];
        NSString *htmlString = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx;height:auto !important;width:auto !important;};</style></head>%@",SCREEN_WIDTH - 15,[contentDict objectForKey:@"content"]];//这是html格式的代码段
        NSDictionary *obj = [dict objectForKey:@"post"];
        NSString *titleStr = [obj objectForKey:@"title"];
        NSString *timeStr = [obj objectForKey:@"modified"];
        
        mainWebView = [[YJ_WebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) WithTitleText:titleStr WithTimeStr:timeStr];
        mainWebView.backgroundColor = [UIColor whiteColor];
        mainWebView.canShare = NO;
        [self.view addSubview:mainWebView];
        [mainWebView loadHTMLString:htmlString baseURL:nil];
        
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        
    } progress:^(float progress) {
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

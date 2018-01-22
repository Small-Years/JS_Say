//
//  TBFindInfoViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/24.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "TBFindInfoViewController.h"
#import "YJ_WebView.h"
@interface TBFindInfoViewController ()<shareBtnClickDelegate>{
    YJ_WebView *mainWebView;
    
    NSString *htmlString;
}


@end

@implementation TBFindInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = [AllMethod getLeftButtonBarItemSelect:@selector(popView) andTarget:self];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    mainWebView = [[YJ_WebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) WithTitleText:@"" WithTimeStr:@""];
    mainWebView.shareDelegate = self;
    mainWebView.canShare = NO;
    [self.view addSubview:mainWebView];
    
    
    
    NSString *url = [NSString stringWithFormat:@"http://mobile.chinaiiss.com/strategy/v3/news/get_newsinfo?newsid=%@&version=4.0.7&platform=ios",[self.infoDict objectForKey:@"newsid"]];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"-----%@",responseObject);
        
        NSDictionary *dict = [responseObject objectForKey:@"data"];
        
        NSString *h5url = [dict objectForKey:@"h5url"];
        [mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:h5url]]];
        
    } withFailureBlock:^(NSError *error){
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        
    } progress:^(float progress){
    }];
    
    
}







#pragma -mark shareDelegate
-(void)webShareBtnClicked{
    NSLog(@"分享");
    
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];//
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  NewHistoryViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/9/30.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "NewHistoryInfoViewController.h"

@interface NewHistoryInfoViewController (){
    XMGPhotoBrowerWebView *mainWebView;
    NSString *htmlString;
    
    
    NSDictionary *resultData;
}

@end

@implementation NewHistoryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = [AllMethod getButtonBarItemWithImageName:@"detail_more" andSelect:@selector(webShareBtnClicked) andTarget:self];
    
//    NSLog(@"%@",self.infoDict);
    
    mainWebView = [[XMGPhotoBrowerWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) WithTitleText:[self.infoDict objectForKey:@"title"] WithTimeStr:[self.infoDict objectForKey:@"publishTime"]];
    mainWebView.backgroundColor = [UIColor whiteColor];
//    mainWebView.shareDelegate = self;
//    mainWebView.canShare = YES;
    [self.view addSubview:mainWebView];
    
    NSString *url = [NSString stringWithFormat:@"http://api.wap.miercn.com/api/2.0.3/article_json.php?plat=ios&proct=mierapp&versioncode=20150610&apiCode=5&id=%@",[self.infoDict objectForKey:@"id"]];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        resultData = (NSDictionary *)responseObject;
        //        NSDictionary *dict = [responseObject objectForKey:@"post"];
        NSString *HTMLStr = [responseObject objectForKey:@"webContent"];
        
        htmlString = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx;height:auto !important;width:auto !important;};</style></head>%@",SCREEN_WIDTH - 15,HTMLStr];//这是html格式的代码段
        [mainWebView loadHTMLString:htmlString baseURL:nil];
        
    } withFailureBlock:^(NSError *error){
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        
    } progress:^(float progress){
        
    }];
    
}



@end

//
//  newItemInfoViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/12.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "ItemInfoViewController.h"
#import "YJ_WebView.h"

@interface ItemInfoViewController ()<shareBtnClickDelegate>{
    YJ_WebView *mainWebView;
    
    NSString *htmlString;
}

@end

@implementation ItemInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor= [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [AllMethod getLeftButtonBarItemSelect:@selector(popView) andTarget:self];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    mainWebView = [[YJ_WebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) WithTitleText:[self.infoDict objectForKey:@"title"] WithTimeStr:[self.infoDict objectForKey:@"date"]];
    mainWebView.shareDelegate = self;
    mainWebView.canShare = NO;
    [self.view addSubview:mainWebView];
    
    
    NSString *url = [self.infoDict objectForKey:@"url"];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        
        NSDictionary *dict = [responseObject objectForKey:@"post"];
        NSString *HTMLStr = [dict objectForKey:@"content"];
        
        htmlString = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx;height:auto !important;width:auto !important;};</style></head>%@",SCREEN_WIDTH - 15,HTMLStr];//这是html格式的代码段
        [mainWebView loadHTMLString:htmlString baseURL:nil];
        
    } withFailureBlock:^(NSError *error){
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        
    } progress:^(float progress){
    }];
    
    
}

#pragma mark -shareBtnClickDelegate
-(void)webShareBtnClicked{
    NSLog(@"分享按钮");
    //显示分享面板
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        [self shareTextToPlatformType:platformType];
//    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{
    NSLog(@"%@",self.infoDict);
    NSString *titleStr = [self.infoDict objectForKey:@"title"];
    NSString *timeStr = [self.infoDict objectForKey:@"date"];
    NSString *urlStr = [self.infoDict objectForKey:@"url"];
    
//    NSLog(@"%@----%@",self.titleText,self.timeStr);
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleStr descr:timeStr thumImage:[UIImage imageNamed:@"video_Default"]];
    //设置网页地址
    shareObject.webpageUrl = urlStr;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
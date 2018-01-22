//
//  oneShowViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/17.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "oneShowViewController.h"

#import "YJ_WebView.h"

@interface oneShowViewController ()<shareBtnClickDelegate>{
    YJ_WebView *mainWebView;
}

@property (nonatomic,strong)NSDictionary * dataDict;
@end

@implementation oneShowViewController


-(NSDictionary *)dataDict{
    if (_dataDict == nil) {
        _dataDict = [[NSDictionary alloc]init];
    }
    return _dataDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
//    http://api.wap.miercn.com/api/2.0.3/article_json.php?plat=ios&proct=mierapp&versioncode=20150610&apiCode=5&id=10636239

    NSString *url = [NSString stringWithFormat:@"http://api.wap.miercn.com/api/2.0.3/article_json.php?plat=ios&proct=mierapp&versioncode=20150610&apiCode=5&id=%@",[self.infoDict objectForKey:@"id"]];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        self.dataDict = responseObject;
        
        mainWebView = [[YJ_WebView alloc]initWithFrame:self.view.frame WithTitleText:[self.dataDict objectForKey:@"title"] WithTimeStr:@""];
        mainWebView.canShare = YES;
        mainWebView.y = 0;
        mainWebView.shareDelegate = self;
        [self.view addSubview:mainWebView];
        NSString *str = [self.dataDict objectForKey:@"webContent"];
        [mainWebView loadHTMLString:str baseURL:nil];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
    } progress:^(float progress){
//        NSLog(@"progress：%f",progress);
    }];
    
    
}

#pragma mark - shareBtnDelegate
-(void)webShareBtnClicked{
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareVideoToPlatformType:platformType];
    }];
}

- (void)shareVideoToPlatformType:(UMSocialPlatformType)platformType{
    
    NSString *titleStr = [self.dataDict objectForKey:@"title"];
    NSString *timeStr = [self.dataDict objectForKey:@"shareAbstract"];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:titleStr descr:timeStr thumImage:[UIImage imageNamed:@"share_Default"]];
    shareObject.videoUrl = [self.dataDict objectForKey:@"videoUrl"];
//    shareObject.videoStreamUrl = [self.infoDict objectForKey:@"videoSource"];
    
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
-(void)popTView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

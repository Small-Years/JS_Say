//
//  twoShowViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/17.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "twoShowViewController.h"

@interface twoShowViewController ()<UIWebViewDelegate>{
    UIWebView *mainWebView;
}
@property (nonatomic,strong)NSDictionary * dataDict;
@end

@implementation twoShowViewController
-(NSDictionary *)dataDict{
    if (_dataDict == nil) {
        _dataDict = [NSDictionary dictionary];
    }
    return _dataDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
     self.navigationItem.rightBarButtonItem = [AllMethod getButtonBarItemWithImageName:@"detail_more" andSelect:@selector(ShareBtnClicked) andTarget:self];
    
    mainWebView = [[UIWebView alloc]init];
    mainWebView.delegate = self;
    [self.view addSubview:mainWebView];
    [mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
//    http://mobile.chinaiiss.com/strategy/v3/news/get_newsinfo?newsid=95726&version=4.0.7&platform=ios
    
    NSLog(@"-------%@",self.infoDict);
    NSString *urlStr = [NSString stringWithFormat:@"%@/strategy/v3/news/get_newsinfo?newsid=%@&version=4.0.7&platform=ios",kPicUrl,[self.infoDict objectForKey:@"newsid"]];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            self.dataDict = dict;
            NSString *urlStr = [dict objectForKey:@"h5url"];
//            [mainWebView loadHTMLString:urlStr baseURL:nil];
            [mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        }
//        NSLog(@"----:%@",responseObject);
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
    } progress:^(float progress){
        //        NSLog(@"progress：%f",progress);
    }];
    
}

-(void)ShareBtnClicked{
    
    NSLog(@"---点击分享%@",self.dataDict);
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareVideoToPlatformType2:platformType];
    }];
}

- (void)shareVideoToPlatformType2:(UMSocialPlatformType)platformType{
    
    NSString *titleStr = [self.dataDict objectForKey:@"title"];
    NSString *timeStr = [self.dataDict objectForKey:@"pubdate"];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:titleStr descr:timeStr thumImage:[UIImage imageNamed:@"share_Default"]];
    shareObject.videoUrl = [self.dataDict objectForKey:@"flash_url"];
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

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *allHtml = @"document.documentElement.innerHTML";
    NSString *allHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:allHtml];
    
//    NSLog(@"--%@",allHtmlInfo);
//    就不要加载原来的H5啦，在这里发现新大陆😂，解析html网页，获取到 .mp4 地址
    
    NSData *htmlData = [allHtmlInfo dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//iframe"];  //这个数组中就有需要的值
    TFHppleElement *href = elements.firstObject;
    NSString * titleHrefStr = [href objectForKey:@"src"];
    NSLog(@"elements:%@",titleHrefStr);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

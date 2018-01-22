//
//  NewShowWebVideoViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/9/29.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "NewShowWebVideoViewController.h"
#import "ShareBtnTableViewCell.h"

@interface NewShowWebVideoViewController ()<UITableViewDelegate,UITableViewDataSource,shareBtnDelegate,UIWebViewDelegate>{
    TBbaseTableView *mainTable;
    NSString *videoURL;
    UIView *headView;
    UIWebView *videoWebView;
    UILabel *titleLable;//标题
    UILabel *timeLable;//发布时间
}
@property (nonatomic,strong)UIWebView * loadWebView;
@end

@implementation NewShowWebVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
//    NSLog(@"self.infoDict:%@",self.infoDict);
    
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    mainTable = [[TBbaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    mainTable.estimatedRowHeight = 350;  //  随便设个不那么离谱的值
    mainTable.rowHeight = UITableViewAutomaticDimension;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    headView.backgroundColor = [UIColor whiteColor];
    mainTable.tableHeaderView = headView;
    
    //标题
    titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10,25,SCREEN_WIDTH-20,60)];
    titleLable.textColor = [UIColor blackColor];
    titleLable.font = [UIFont boldSystemFontOfSize:25];
    titleLable.numberOfLines = 3;
    titleLable.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:titleLable];
//
    
//    发布时间
    timeLable = [[UILabel alloc]initWithFrame:CGRectMake(titleLable.x,titleLable.max_Y+15,titleLable.width,30)];
    timeLable.textColor = RGB(155, 155, 155);
    timeLable.font = [UIFont systemFontOfSize:12];
    timeLable.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:timeLable];
    
    videoWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, timeLable.max_Y+10, headView.width, 200)];
    [headView addSubview:videoWebView];
    headView.height = videoWebView.max_Y + 10;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/strategy/v3/news/get_newsinfo?newsid=%@&version=4.0.7&platform=ios",kPicUrl,[self.infoDict objectForKey:@"newsid"]];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
//            self.dataDict = dict;
            NSString *urlStr = [dict objectForKey:@"h5url"];
            self.loadWebView = [[UIWebView alloc]init];
            self.loadWebView.delegate = self;
            
            [self.loadWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        }
//          NSLog(@"----:%@",responseObject);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
    } progress:^(float progress){
        //        NSLog(@"progress：%f",progress);
    }];
    
    
    
//    加载评论
//    http://mobile.chinaiiss.com/strategy/v3/news/get_commentlist?newsid=101225&lasttime=0
}


#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    ShareBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        ShareBtnTableViewCell *cell = [ShareBtnTableViewCell cellWithTableView:tableView withIdentifier:cellID WithIndex:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return cell;
    
}



#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *allHtml = @"document.documentElement.innerHTML";
    NSString *allHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:allHtml];
    //    就不要加载原来的H5啦，在这里发现新大陆啦😂，解析html网页，获取到 .mp4 地址
    NSData *htmlData = [allHtmlInfo dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//iframe"];  //这个数组中就有需要的值
    TFHppleElement *href = elements.firstObject;
    videoURL = [href objectForKey:@"src"];
    [videoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:videoURL]]];
    
    //设置标题和发布时间
    href = [[xpathParser searchWithXPathQuery:@"//title"] firstObject];
    titleLable.text = href.text;
    [titleLable sizeToFit];
    href = [[xpathParser searchWithXPathQuery:@"//h3"] firstObject];
    NSMutableString *timeStr = [NSMutableString string];
    [timeStr appendString:href.text];
    
    NSArray *timeElements = [xpathParser searchWithXPathQuery:@"//h3"];
    
    for (TFHppleElement *element in timeElements) {
        NSArray *spanElementsArr = [element searchWithXPathQuery:@"//span"];
        for (TFHppleElement *tempAElement in spanElementsArr) {
            NSString *imgStr = tempAElement.text;
            [timeStr appendString:imgStr];
        }
    }
    
    timeLable.text = timeStr;
    [self updateFrame];
    [WSProgressHUD dismiss];
}
-(void)updateFrame{
    timeLable.y = titleLable.max_Y + 15;
    videoWebView.y = timeLable.max_Y + 10;
    headView.height = videoWebView.max_Y + 10;
}


#pragma mark - shareBtnClicked
-(void)ShareBtnClicked{
    NSLog(@"-----点击分享视频");
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareVideoToPlatformType2:platformType];
    }];
}

- (void)shareVideoToPlatformType2:(UMSocialPlatformType)platformType{
    
    NSString *titleStr = titleLable.text;
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:titleStr descr:@"来自于一线军情：最全、最前沿的军情播报" thumImage:[UIImage imageNamed:@"share_Default"]];
    shareObject.videoUrl = videoURL;
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

@end

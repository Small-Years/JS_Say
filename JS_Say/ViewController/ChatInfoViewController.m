//
//  ChatInfoViewController.m
//  Charles_learn
//
//  Created by yangjian on 2017/7/25.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "ChatInfoViewController.h"
#import "ShareBtnTableViewCell.h"
#import "talkTableViewCell.h"
@interface ChatInfoViewController ()<XMGPhotoBrowerWebViewDelegate,UITableViewDelegate,UITableViewDataSource,talkBackBtnDelegate,shareBtnDelegate>{
    XMGPhotoBrowerWebView *WebView;
    
    NSString *URLStr;
    
    UITableView *mainTableView;
    
    UIView *headView;
    UILabel *titleLable;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation ChatInfoViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [AllMethod getLeftButtonBarItemSelect:@selector(popView) andTarget:self];
    self.navigationItem.rightBarButtonItem = [AllMethod getButtonBarItemWithImageName:@"detail_more" andSelect:@selector(webShareBtnClicked) andTarget:self];
    
    
    
//    NSLog(@"------%@",self.infoDict);
    NSString *titleStr = [self.infoDict objectForKey:@"title"];
    NSString *timeStr = [AllMethod changeMethodFromSQL:[self.infoDict objectForKey:@"createDate"] With:@"MM-dd HH:MM"];
    
    //    tableViewHeadView
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    headView.backgroundColor = [UIColor whiteColor];
    
    //    标题
    titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10,10,SCREEN_WIDTH-20,40)];
    titleLable.textColor = [UIColor blackColor];
    titleLable.backgroundColor = [UIColor whiteColor];
    titleLable.font = [UIFont boldSystemFontOfSize:19];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.numberOfLines = 0;
    [headView addSubview:titleLable];
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleStr length])];
    titleLable.attributedText = attributedString;
    [titleLable sizeToFit];
    titleLable.centerX = headView.centerX;
    
    //发布时间
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(titleLable.x, titleLable.max_Y+10,SCREEN_WIDTH, 10)];
    timeLable.text = [NSString stringWithFormat:@"发布 %@",timeStr];
    timeLable.textColor = RGB(155, 155, 155);
    timeLable.font = [UIFont systemFontOfSize:13];
    timeLable.textAlignment = NSTextAlignmentLeft;
    timeLable.backgroundColor = [UIColor whiteColor];
    [headView addSubview:timeLable];
    
    
    
    WebView = [[XMGPhotoBrowerWebView alloc]initWithFrame:CGRectMake(0,timeLable.max_Y+5, SCREEN_WIDTH, 10)];
    WebView.webViewDelegate = self;
    WebView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:WebView];
    
    URLStr = [NSString stringWithFormat:@"https://h5.kanjunshi.net/content/camp/view.h5?contentType=3&id=%@",self.newsID];
    
    [WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLStr]]];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    mainTableView.tableHeaderView = headView;
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//    mainTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"footView_Default2"]];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    mainTableView.estimatedRowHeight = 50;  //  随便设个不那么离谱的值
    mainTableView.rowHeight = UITableViewAutomaticDimension;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.tableHeaderView = headView;
    
    [self getCommentData];//获取评论
}
-(void)createView{
    
}

-(void)getCommentData{
    //在此处加载评论https:
    
    //app.kanjunshi.net/comments/camp/comments?contentId=f9026761da434f9486885639b2a7b265&pageInvertedIndex=0&pageSize=10&repeatSubmit=73656621&signature=0C8AF81773594BC9532F5450295789F3
    
    NSString *comment_Url = [NSString stringWithFormat:@"%@/comments/content/comments?contentId=%@&pageInvertedIndex=0&pageSize=10&repeatSubmit=73656621&signature=0C8AF81773594BC9532F5450295789F3",kMainUrl,self.newsID];

    
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:comment_Url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"----------评论结果：%@",responseObject);
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"000000"] || [[responseObject objectForKey:@"desc"] isEqualToString:@"成功"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            self.dataArray = [dict objectForKey:@"list"];
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
    } progress:^(float progress){
        NSLog(@"progress：%f",progress);
    }];
}


#pragma mark - TableViewDelegate & TableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *cellID = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        ShareBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            ShareBtnTableViewCell *cell = [ShareBtnTableViewCell cellWithTableView:tableView withIdentifier:cellID WithIndex:indexPath];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        return cell;
    }else{
        NSDictionary *dict = self.dataArray[indexPath.row-1];
        NSString *cellID = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            talkTableViewCell *cell = [talkTableViewCell cellWithTableView:tableView withIdentifier:cellID WithInfoDict:dict];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return cell;
        }
        return cell;
    }
}
#pragma mark - talkBackDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"点击回复：%@",dict);
    
}
-(void)talkBtnClick:(int)number WithInfoDict:(NSDictionary *)dict{
    NSLog(@"点击回复：%@",dict);
}

#pragma mark - UIWebView Delegate Methods
//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    //获取到webview的高度
//    CGFloat height = [[WebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    WebView.frame = CGRectMake(WebView.x,WebView.y, SCREEN_WIDTH, height);
//    headView.height = height+titleLable.height+10;
//    mainTableView.tableHeaderView = headView;
//    [mainTableView reloadData];
//    [WSProgressHUD dismiss];
//}
-(void)xmgWebViewDidFinishLoad:(UIWebView *)webView{
    //获取到webview的高度
    CGFloat height = [[WebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    WebView.frame = CGRectMake(WebView.x,WebView.y, SCREEN_WIDTH, height);
    headView.height = height+titleLable.height+10;
    mainTableView.tableHeaderView = headView;
    [mainTableView reloadData];
    [WSProgressHUD dismiss];
}


#pragma mark - shareBtnDelegate
-(void)ShareBtnClicked{
    [self webShareBtnClicked];
}

-(void)webShareBtnClicked{
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{
    NSString *titleStr = [self.infoDict objectForKey:@"title"];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleStr descr:titleStr thumImage:[UIImage imageNamed:@"share_Default"]];
    //设置网页地址
    shareObject.webpageUrl = URLStr;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@***********",error);
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

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

@end

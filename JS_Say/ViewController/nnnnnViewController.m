//
//  nnnnnViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/9/12.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "nnnnnViewController.h"
#import "talkTableViewCell.h"
#import "ShareBtnTableViewCell.h"


@interface nnnnnViewController ()<XMGPhotoBrowerWebViewDelegate,UITableViewDataSource,UITableViewDelegate,talkBackBtnDelegate,shareBtnDelegate>{
    UIView *headView;//tableView的顶部视图
    UILabel *titleLable;
    
    XMGPhotoBrowerWebView *WebView;
    TBbaseTableView *mainTableView;
    
    NSString *newUrlStr;//分享的连接
    
    int indexPage;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation nnnnnViewController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"详情";
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

    self.navigationItem.rightBarButtonItem = [AllMethod getButtonBarItemWithImageName:@"detail_more" andSelect:@selector(ShareBtnClicked) andTarget:self];
    
//    tableViewHeadView
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    headView.backgroundColor = [UIColor whiteColor];
//    标题
    titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10,10,SCREEN_WIDTH,40)];
    titleLable.textColor = [UIColor blackColor];
    titleLable.font = [UIFont boldSystemFontOfSize:19];
    titleLable.backgroundColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.numberOfLines = 0;
    [headView addSubview:titleLable];
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.titleText length])];
    titleLable.attributedText = attributedString;
    [titleLable sizeToFit];
    titleLable.centerX = headView.centerX;
    
    //发布时间
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(titleLable.x, titleLable.max_Y+10,SCREEN_WIDTH, 10)];
    timeLable.text = [NSString stringWithFormat:@"发布 %@",self.timeStr];
    timeLable.textColor = RGB(155, 155, 155);
    timeLable.font = [UIFont systemFontOfSize:13];
    timeLable.textAlignment = NSTextAlignmentLeft;
    timeLable.backgroundColor = [UIColor whiteColor];
    [headView addSubview:timeLable];
    
    
    WebView = [[XMGPhotoBrowerWebView alloc]initWithFrame:CGRectMake(0, titleLable.max_Y+5, SCREEN_WIDTH, SCREEN_HEIGHT)];
    WebView.webViewDelegate = self;
    WebView.scrollView.scrollEnabled = NO;
    WebView.backgroundColor = [UIColor redColor];
    
    [WSProgressHUD show];
    newUrlStr = [NSString stringWithFormat:@"https://h5.kanjunshi.net/content/view.h5?contentType=3&id=%@",self.newsID];
    [WebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:newUrlStr]]];
    [headView addSubview:WebView];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
//设置tablview的底视图
    BaseLabel *footLable = [[BaseLabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footLable.text = @"∽ END ∽";
//    footLable.textColor = RGB(155, 155, 155);
    footLable.font = [UIFont systemFontOfSize:13];
    footLable.textAlignment = NSTextAlignmentCenter;
    footLable.backgroundColor = [UIColor clearColor];
    
    mainTableView = [[TBbaseTableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    mainTableView.estimatedRowHeight = 50;  //  随便设个不那么离谱的值
    mainTableView.rowHeight = UITableViewAutomaticDimension;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.tableHeaderView = headView;
    mainTableView.tableFooterView = footLable;
    
    mainTableView.mj_header = [AllMethod createTableViewHeader:self andSelect:@selector(getCommentData)];
//    mainTableView.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(getMoreData)];
    
    
    [self getCommentData];//获取评论
}


#pragma mark -getData
-(void)getCommentData{
    //在此处加载评论https:
    [self.dataArray removeAllObjects];
    indexPage = 0;
    NSString *comment_Url = [NSString stringWithFormat:@"%@/comments/content/comments?contentId=%@&pageInvertedIndex=%d&pageSize=200&repeatSubmit=39817740&signature=A928A5EF401368521EBD67684C11045A&type=1",kMainUrl,self.newsID,indexPage];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:comment_Url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"000000"] || [[responseObject objectForKey:@"desc"] isEqualToString:@"成功"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *arr = [dict objectForKey:@"list"];
            for (NSDictionary *obj in arr) {
                [self.dataArray addObject:obj];
            }
        }
//        indexPage = indexPage+10;
        [mainTableView.mj_header endRefreshing];
        if (self.dataArray.count == 0) {
            mainTableView.tableFooterView = nil;
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [mainTableView.mj_header endRefreshing];
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
    } progress:^(float progress){
        NSLog(@"progress：%f",progress);
    }];
}

-(void)getMoreData{
    NSString *comment_Url = [NSString stringWithFormat:@"%@/comments/content/comments?contentId=%@&pageInvertedIndex=%d&pageSize=10&repeatSubmit=39817740&signature=A928A5EF401368521EBD67684C11045A&type=1",kMainUrl,self.newsID,indexPage];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:comment_Url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"000000"] || [[responseObject objectForKey:@"desc"] isEqualToString:@"成功"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *arr = [dict objectForKey:@"list"];
            
            if (arr.count == 0) {
                [mainTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (NSDictionary *obj in arr) {
//                    判断obj在self.dataArray里面是否存在
                    if (![self.dataArray containsObject: obj]) {
                        [self.dataArray addObject:obj];
                    }
                }
                
                
                [mainTableView reloadData];
                [mainTableView.mj_footer endRefreshing];
            }
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [mainTableView.mj_footer endRefreshing];
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
            return cell;
        }
        return cell;
    }
}

#pragma mark - UIWebView Delegate Methods
//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    //获取到webview的高度
//    CGFloat height = [[WebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    WebView.frame = CGRectMake(WebView.x,WebView.y, SCREEN_WIDTH, height);
//    headView.height = height+titleLable.height+10;
//    [mainTableView reloadData];
//    [WSProgressHUD dismiss];
//}

- (void)xmgWebViewDidFinishLoad:(UIWebView *)webView{
    //获取到webview的高度
    CGFloat height = [[WebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    WebView.frame = CGRectMake(WebView.x,WebView.y, SCREEN_WIDTH, height);
    headView.height = height+titleLable.height+10;
    [mainTableView reloadData];
    [WSProgressHUD dismiss];
}


#pragma mark -shareMethod--------
-(void)webShareBtnClicked{
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
    }];
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //    NSLog(@"%@----%@",self.titleText,self.timeStr);
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleText descr:self.titleText thumImage:[UIImage imageNamed:@"share_Default"]];
    //设置网页地址
    shareObject.webpageUrl = newUrlStr;
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


#pragma mark -btnClickedDelegate--------
-(void)ShareBtnClicked{
    //    点击分享
    [self webShareBtnClicked];
}


-(void)talkBtnClick:(int)number WithInfoDict:(NSDictionary *)dict{
    
}

-(void)viewWillAppear:(BOOL)animated{
    //设置这个页面可以右滑弹出左菜单
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:YES];
}

@end

//
//  ShowVideoViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/7/31.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "ShowVideoViewController.h"
#import "JDVideoModel.h"
#import "JDPlayerView.h"
#import "JDPlayer.h"
#import "talkTableViewCell.h"

@interface ShowVideoViewController ()<JDPlayerDelegate,UITableViewDelegate,UITableViewDataSource,talkBackBtnDelegate>{
    UITableView *mainTable;
}
@property(nonatomic,assign) BOOL applicationIdleTimerDisabled;
@property(nonatomic,strong) JDPlayer* player;
@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,assign) BOOL shouldRotate;

@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation ShowVideoViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (JDPlayer *)player{
    if(!_player){
        
        _player = [[JDPlayer alloc] init];
        _player.delegate = self;
        [self.view addSubview:_player.jdView];
        _player.jdView.frame = CGRectMake(0, 0, SCREEN_WIDTH, VideoHeight);
    }
    return _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self playVideo];//播放视频
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, _player.jdView.max_Y, SCREEN_WIDTH, SCREEN_HEIGHT -  _player.jdView.max_Y)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    [self.view sendSubviewToBack:mainTable];
    mainTable.estimatedRowHeight = 350;  //  随便设个不那么离谱的值
    mainTable.rowHeight = UITableViewAutomaticDimension;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self buildHeadView];
    [self loadComments];
    
}

-(void)loadComments{
    NSLog(@"加载评论数据");
    
    NSString *url = [NSString stringWithFormat:@"%@/comments/camp/comments?contentId=%@&pageInvertedIndex=0&pageSize=10&repeatSubmit=93511375&signature=C07DB87706FF3091D8022D3A48CB0499&token=3b080579e745458aa9633337b505a82c",kMainUrl,[self.infoDict objectForKey:@"id"]];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"desc"] isEqualToString:@"成功"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *arr = [dict objectForKey:@"list"];
            for (NSDictionary *obj in arr) {
                [self.dataArray addObject:obj];
            }
        }
        [mainTable reloadData];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
    } progress:^(float progress) {
        //        NSLog(@"progress：%f",progress);
    }];

}


-(void)buildHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    headView.backgroundColor = [UIColor whiteColor];
    mainTable.tableHeaderView = headView;
    NSLog(@"---%@",self.infoDict);
    
    //    头像
    UIImageView *sendImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
    sendImageView.backgroundColor = [UIColor redColor];
    sendImageView.layer.cornerRadius = sendImageView.width *0.5;
    sendImageView.layer.masksToBounds = YES;
    NSString *str = [self.infoDict objectForKey:@"issuerFaceSrc"];
    [sendImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImage_Default"]];
    [headView addSubview:sendImageView];
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(sendImageView.max_X+13,sendImageView.y,SCREEN_WIDTH-sendImageView.max_X-10,20)];
    nameLable.text = [NSString stringWithFormat:@"%@",[self.infoDict objectForKey:@"issuerName"]];
    nameLable.textColor = RGB(76, 76, 76);
    nameLable.font = [UIFont boldSystemFontOfSize:15];
    nameLable.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:nameLable];
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(nameLable.x,nameLable.max_Y+5,nameLable.width,nameLable.height)];
    
    timeLable.text = [NSString stringWithFormat:@"发表于 %@",[AllMethod changeMethodFromSQL:[self.infoDict objectForKey:@"createDate"] With:@"MM-dd HH:MM"]];
    timeLable.textColor = RGB(155, 155, 155);
    timeLable.font = [UIFont systemFontOfSize:13];
    timeLable.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:timeLable];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15,sendImageView.max_Y+10,SCREEN_WIDTH - 30,50)];
    titleLable.textColor = RGB(74, 74, 74);
    titleLable.font = [UIFont systemFontOfSize:16];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.numberOfLines = 0;
    titleLable.attributedText = [NSAttributedString_Encapsulation string:[self.infoDict objectForKey:@"title"] withHotLogo:[self.infoDict objectForKey:@"isPop"] withJingLogo:[self.infoDict objectForKey:@"isHot"] withDingLogo:[self.infoDict objectForKey:@"isTop"]];
    [headView addSubview:titleLable];
    
//    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, titleLable.max_Y+5, 40, 40)];
//    shareBtn.backgroundColor = [UIColor redColor];
    UIImageView *shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, titleLable.max_Y+5, 40, 40)];
    shareImage.centerX = headView.centerX;
    shareImage.backgroundColor = [UIColor redColor];
    shareImage.image = [UIImage imageNamed:@"share"];
    shareImage.layer.cornerRadius = shareImage.width*0.5;
    
    shareImage.layer.shadowColor = RGB(249, 60, 56).CGColor;
    shareImage.layer.shadowOffset = CGSizeMake(0,0);
    shareImage.layer.shadowOpacity = 0.7;

    [headView addSubview:shareImage];
    shareImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnTap)];
    [shareImage addGestureRecognizer:tap];
    
}
#pragma mark -分享
-(void)shareBtnTap{
//    NSLog(@"---点击分享视频%@",self.infoDict);
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareVideoToPlatformType:platformType];
    }];
}
- (void)shareVideoToPlatformType:(UMSocialPlatformType)platformType{
    [self.player pauseContent];//暂停播放
    NSString *titleStr = [self.infoDict objectForKey:@"title"];
    NSString *timeStr = [self.infoDict objectForKey:@"playTime"];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:titleStr descr:timeStr thumImage:[UIImage imageNamed:@"share_Default"]];
    shareObject.videoUrl = [self.infoDict objectForKey:@"videoSource"];
    shareObject.videoStreamUrl = [self.infoDict objectForKey:@"videoSource"];

    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        [self.player playContent];//自动播放
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


#pragma mark -talkBackBtnDelegate


-(void)talkBtnClick:(int)number WithInfoDict:(NSDictionary *)dict{
    NSLog(@"需要回复的信息是：%@",dict);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击tablview需要回复的信息:%@",self.dataArray[indexPath.row]);
}
#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"全部评论";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
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




- (void)playVideo{
    JDVideoModel* videoModel = [[JDVideoModel alloc]init];
    NSString *str = [self.infoDict objectForKey:@"videoSource"];
//    NSString *str = @"https://v.qq.com/iframe/player.html?vid=g0531vwbzyy&tiny=0&auto=0";
    videoModel.streamURL = [NSURL URLWithString:str];
    videoModel.title = [self.infoDict objectForKey:@"title"];
    [self.player loadVideoModel:videoModel];
    [self shouldShowTitleHidden];
}

- (void)addObserver{
    NSNotificationCenter* defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - App States

- (void)applicationWillResignActive
{
    self.player.jdView.countdownToHide = -1;
    
    if (self.player.state == JDPlayerStatePlaying)
    {
        [self.player pauseContent:NO recordCurrentTime:YES completionHandler:nil];
    }
}

- (void)applicationDidBecomeActive
{
    self.player.jdView.countdownToHide = -1;
}
#pragma mark -JDPlayerDelegate
- (void)handleErrorCode:(JDPlayerErrorCode)errorCode track:(JDVideoModel *)track customMessage:(NSString*)customMessage{
    NSLog(@"errorCode : %ld,message : %@ , url : %@",(long)errorCode,customMessage,track.streamURL);
}
-(void)videoPlayer:(JDPlayer *)videoPlayer didPlayToEnd:(JDVideoModel *)videoModel{
    if (_player.jdView.isFullScreen) {
        [_player.jdView setIsFullScreen:NO];
    }
}
-(void)didDoneBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)didFullScreenButtonClicked{
    [self shouldShowTitleHidden];
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate{
    return self.shouldRotate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return self.shouldRotate;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.applicationIdleTimerDisabled = [UIApplication sharedApplication].isIdleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];//照顾iOS9之前的版本。还是需要加的
    self.navigationController.navigationBarHidden = YES;

    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:NO];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = self.applicationIdleTimerDisabled;
    self.navigationController.navigationBarHidden = NO;
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/** 隐藏电池栏*/
- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)shouldShowTitleHidden{
    if (self.player.jdView.isFullScreen) {
        self.player.jdView.titleLabel.hidden = NO;
    }else{
        self.player.jdView.titleLabel.hidden = YES;
    }
}

@end

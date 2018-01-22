//
//  JDViewController.m
//  JDPlayerPro
//
//  Created by depa on 2017/3/23.
//  Copyright © 2017年 depa. All rights reserved.
//

#import "JDViewController.h"
#import "JDVideoModel.h"
#import "JDPlayerView.h"
#import "JDPlayer.h"

@interface JDViewController ()<JDPlayerDelegate>
@property(nonatomic,assign) BOOL applicationIdleTimerDisabled;

@property(nonatomic,strong) NSArray* testUrls;
@property(nonatomic,assign) NSInteger currentIndex;

@property(nonatomic,strong) JDPlayer* player;
@property(nonatomic,assign) BOOL shouldRotate;
@end

@implementation JDViewController

- (JDPlayer *)player
{
    if(!_player)
    {
//        JDPlayerView *videoView = [[JDPlayerView alloc]init];
//        _player = [[JDPlayer alloc] initWithVideoPlayerView:videoView];
        _player = [[JDPlayer alloc] init];
        _player.delegate = self;
        [self.view addSubview:_player.jdView];
//        _player.jdView.frame = self.view.bounds;
        _player.jdView.frame = CGRectMake(0, 80, SCREEN_WIDTH, 150);
    }
    
    return _player;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.currentIndex = 0;
    
    self.shouldRotate = YES;
    [self addObserver];
    [self playVideo];
    NSLog(@"----%@",self.infoDict);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.applicationIdleTimerDisabled = [UIApplication sharedApplication].isIdleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];//照顾iOS9之前的版本。还是需要加的
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = self.applicationIdleTimerDisabled;
    self.navigationController.navigationBarHidden = NO;
}

- (void)addObserver
{
    NSNotificationCenter* defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/** 隐藏电池栏*/
- (BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)playVideo
{
    JDVideoModel* videoModel = [[JDVideoModel alloc]init];
    
    NSString *str = [self.infoDict objectForKey:@"videoSource"];
    videoModel.streamURL = [NSURL URLWithString:str];
    videoModel.title = [self.infoDict objectForKey:@"title"];
    [self.player loadVideoModel:videoModel];
    
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

- (void)videoPlayer:(JDPlayer*)videoPlayer didPlayToEnd:(JDVideoModel *)videoModel
{
    if(self.currentIndex < self.testUrls.count)
    {
        JDVideoModel* nextTrack = [[JDVideoModel alloc]init];
        nextTrack.streamURL = [NSURL URLWithString:self.testUrls[self.currentIndex++]];

        if(self.currentIndex == self.testUrls.count - 1)
        {
            nextTrack.hasNext = NO;
        }
        else
        {
            nextTrack.hasNext = YES;
        }

        [self.player loadVideoModel:nextTrack];
    }
}

- (void) videoPlayer:(JDPlayer *)videoPlayer didNextVideoButtonPressed:(JDVideoModel *)videoModel
{
    
}

- (void)handleErrorCode:(JDPlayerErrorCode)errorCode track:(JDVideoModel *)track customMessage:(NSString*)customMessage
{
    NSLog(@"errorCode : %ld,message : %@ , url : %@",(long)errorCode,customMessage,track.streamURL);
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate
{
    return self.shouldRotate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return self.shouldRotate;
}



-(void)didDoneBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

@end

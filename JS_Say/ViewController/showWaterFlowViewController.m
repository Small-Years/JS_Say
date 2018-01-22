//
//  showImageViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/9/6.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "showWaterFlowViewController.h"

@interface showWaterFlowViewController (){
    UIView *showMainView;
    UIView *toolView;
    UIImage *mainImage;//点击的图片
    
    UIView *showTimeView;
    
}

@end

@implementation showWaterFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"++++%@",self.imgURL);
    //    1、创建一个view,显示image用的，
    showMainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    showMainView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:showMainView];
    
    //图像
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, showMainView.width, showMainView.height)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    [imgView addGestureRecognizer:tap];
    imgView.userInteractionEnabled = YES;
    
//    [self.infoDict objectForKey:@"WallPaperDownloadPath"]
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        mainImage = image;
    }];
    [showMainView addSubview:imgView];
    //
    toolView = [[UIView alloc]initWithFrame:CGRectMake(0, showMainView.height - 70, showMainView.width, 50)];
    toolView.backgroundColor = [UIColor blackColor];
    [showMainView addSubview:toolView];
    
//  返回按钮
    UIImage *backImg = [UIImage imageNamed:@"wallpaper_back"];
    SQCustomButton *backBtn = [[SQCustomButton alloc]initWithFrame:CGRectMake(0, 0, toolView.width/4, toolView.height) type:SQCustomButtonTopImageType imageSize:backImg.size midmargin:6];
    backBtn.imageView.image = backImg;
    backBtn.titleLabel.text = @"返回";
    backBtn.titleLabel.textColor = [UIColor whiteColor];
    backBtn.isShowSelectBackgroudColor = YES;
    [backBtn touchAction:^(SQCustomButton * _Nonnull button) {
        [self backClicked];
    }];
    [toolView addSubview:backBtn];
    
    
//  预览按钮
    UIImage *seeImg = [UIImage imageNamed:@"wallpaper_see"];
    SQCustomButton *seeBtn = [[SQCustomButton alloc]initWithFrame:CGRectMake(backBtn.max_X, 0, backBtn.width, backBtn.height) type:SQCustomButtonTopImageType imageSize:seeImg.size midmargin:7];
    seeBtn.imageView.image = seeImg;
    seeBtn.titleLabel.text = @"预览";
    seeBtn.titleLabel.textColor = [UIColor whiteColor];
    seeBtn.isShowSelectBackgroudColor = YES;
    [seeBtn touchAction:^(SQCustomButton * _Nonnull button) {
        [self seeBtnClicked];
    }];
    [toolView addSubview:seeBtn];
    
    
    //预览按钮
    UIImage *downLoadImg = [UIImage imageNamed:@"wallpaper_download"];
    SQCustomButton *downLoadBtn = [[SQCustomButton alloc]initWithFrame:CGRectMake(seeBtn.max_X, 0, backBtn.width, backBtn.height) type:SQCustomButtonTopImageType imageSize:downLoadImg.size midmargin:7];
    downLoadBtn.imageView.image = downLoadImg;
    downLoadBtn.titleLabel.text = @"下载";
    downLoadBtn.titleLabel.textColor = [UIColor whiteColor];
    downLoadBtn.isShowSelectBackgroudColor = YES;
    [downLoadBtn touchAction:^(SQCustomButton * _Nonnull button) {
        [self downLoadBtnClicked];
    }];
    [toolView addSubview:downLoadBtn];
    
    
    //分享按钮
    UIImage *shareImg = [UIImage imageNamed:@"wallpaper_share"];
    SQCustomButton *shareBtn = [[SQCustomButton alloc]initWithFrame:CGRectMake(downLoadBtn.max_X, 0, backBtn.width, backBtn.height) type:SQCustomButtonTopImageType imageSize:shareImg.size midmargin:7];
    shareBtn.imageView.image = shareImg;
    shareBtn.titleLabel.text = @"分享";
    shareBtn.titleLabel.textColor = [UIColor whiteColor];
    shareBtn.isShowSelectBackgroudColor = YES;
    [shareBtn touchAction:^(SQCustomButton * _Nonnull button) {
        [self shareBtnClicked];
    }];
    [toolView addSubview:shareBtn];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.view addGestureRecognizer:swipe];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
}


- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [self backClicked];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        [self backClicked];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self backClicked];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self backClicked];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -ToolBtnClicked
-(void)backClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)seeBtnClicked{
    //1、预览的时候创建一个lable，获取本地时间按照屏幕大小显示出来即可
    if (showTimeView == nil) {
        toolView.hidden = YES;
        NSDate *nowDate = [NSDate date];
        NSString *timeStr = [AllMethod changeDateWay:nowDate To:@"HH:mm"];
        NSString *dateStr = [AllMethod changeDateWay:nowDate To:@"MM月dd日"];
        
        showTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, showMainView.width, showMainView.height)];
        showTimeView.backgroundColor = [UIColor clearColor];
        [showMainView addSubview:showTimeView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShowTimeView)];
        [showTimeView addGestureRecognizer:tap];
        
        [showMainView bringSubviewToFront:toolView];
        //时间
        UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(0,70,showTimeView.width,90)];
        timeLable.text = timeStr;
        timeLable.textColor = [UIColor whiteColor];
        timeLable.font = [UIFont systemFontOfSize:70 weight:UIFontWeightThin];
        timeLable.textAlignment = NSTextAlignmentCenter;
        [showTimeView addSubview:timeLable];
        
        //月份 周几
        UILabel *dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0,timeLable.max_Y,timeLable.width,40)];
        dateLable.text = [NSString stringWithFormat:@"%@ %@",dateStr,[self WeekFromDate:[AllMethod changeDateWay:nowDate To:@"yyyy-MM-dd"]]];
        dateLable.textColor = [UIColor whiteColor];
        dateLable.font = [UIFont systemFontOfSize:25];
        dateLable.textAlignment = NSTextAlignmentCenter;
        [showTimeView addSubview:dateLable];
        
        //滑动解锁
        UILabel *lockLable = [[UILabel alloc]initWithFrame:CGRectMake(0,showTimeView.height - 100,showTimeView.width,40)];
        lockLable.text = @"按下主屏幕按钮以解锁";
        lockLable.textColor = [UIColor whiteColor];
        lockLable.font = [UIFont systemFontOfSize:19];
        lockLable.textAlignment = NSTextAlignmentCenter;
        [showTimeView addSubview:lockLable];
        
    }else{
        if (showTimeView.x == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                showTimeView.x = showMainView.width;
                toolView.hidden = NO;
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                showTimeView.x = 0;
                toolView.hidden = YES;
            }];
        }
    }
}

-(void)hideShowTimeView{
    if (toolView.hidden == YES) {
        toolView.hidden = NO;
    }else{
        toolView.hidden = YES;
    }
}

-(void)shareBtnClicked{//分享
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareImageToPlatformType:platformType];
    }];
}

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"share_Default"];
    
    [shareObject setShareImage:mainImage];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}


-(void)downLoadBtnClicked{
//    [self.infoDict objectForKey:@"WallPaperDownloadPath"]
    NSString *downLoadPath = self.imgURL;
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:downLoadPath] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        NSLog(@"++++++====:%@",image);
        //        这里进行图片保存操作
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo{
    if (error) {
        [WSProgressHUD dismiss];
        [WSProgressHUD showErrorWithStatus:@"下载失败！"];
    }else{
        [WSProgressHUD dismiss];
        [WSProgressHUD showSuccessWithStatus:@"下载成功！"];
    }
}


-(void)tapClicked{
    if (toolView.alpha == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            toolView.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            toolView.alpha = 1;
        }];
    }
}


-(NSString *)WeekFromDate:(NSString *)date {
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    NSArray *array = [date componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    NSString *yearS = array[0];
    int year = yearS.intValue;
    NSString *mouthS = array[1];
    int mouth = mouthS.intValue;
    NSString * dayS = array[2];
    int day = dayS.intValue;
    [_comps setDay:day];
    [_comps setMonth:mouth];
    [_comps setYear:year];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    NSInteger weekday = [weekdayComponents weekday]-1;
    NSString * weekDay;
    switch (weekday) {
        case 1:
            weekDay = @"星期一";
            break;
        case 2:
            weekDay = @"星期二";
            break;
        case 3:
            weekDay = @"星期三";
            break;
        case 4:
            weekDay = @"星期四";
            break;
        case 5:
            weekDay = @"星期五";
            break;
        case 6:
            weekDay = @"星期六";
            break;
        case 7:
            weekDay = @"星期天";
            break;
            
        default:
            break;
    }
    return weekDay;
}

#pragma mark - hide
- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end

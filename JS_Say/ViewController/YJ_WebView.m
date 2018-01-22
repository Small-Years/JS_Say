//
//  YJ_WebView.m
//  JS_Say
//
//  Created by yangjian on 2017/8/12.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "YJ_WebView.h"

@interface YJ_WebView()<UIScrollViewDelegate,UIWebViewDelegate,XMGPhotoBrowerWebViewDelegate>{
    UILabel *titleLable;
    UILabel *timeLable;
    UIButton *shareBtn;
    UIView *footView;//尾视图
    CGFloat foot_Height;
    CGFloat img_Height;
    
    UILabel *numLable;
}

@end

@implementation YJ_WebView

-(void)setTitleText:(NSString *)titleText{
    NSLog(@"=======:%@",titleText);
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleText length])];
    titleLable.attributedText = attributedString;
    titleLable.centerX = self.centerX;
    titleLable.y = - titleLable.height -20-14;
    
    CGFloat headHeight = titleLable.height + 14 +timeLable.height+7;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(headHeight, 0, 0, 0);
    
}

-(instancetype)initWithFrame:(CGRect)frame WithTitleText:(NSString *)titleStr WithTimeStr:(NSString *)timeStr{
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        
        if (titleStr) {
            titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10,-50,frame.size.width-20,50)];
            titleLable.textColor = [UIColor blackColor];
            titleLable.font = [UIFont boldSystemFontOfSize:19];
            titleLable.textAlignment = NSTextAlignmentLeft;
            titleLable.numberOfLines = 0;
            // 调整行间距
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:6];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleStr length])];
            titleLable.attributedText = attributedString;
            titleLable.centerX = self.centerX;
            [titleLable sizeToFit];
            titleLable.y = - titleLable.height -20-14;
            [self.scrollView addSubview:titleLable];
        }
        
        if (timeStr) {
            //        发布时间
            timeLable = [[UILabel alloc]initWithFrame:CGRectMake(titleLable.x,titleLable.max_Y+5,frame.size.width-20,20)];
            timeLable.text = [NSString stringWithFormat:@"发布 %@",timeStr];
            timeLable.textColor = RGB(155, 155, 155);
            timeLable.font = [UIFont systemFontOfSize:13];
            timeLable.textAlignment = NSTextAlignmentLeft;
            [self.scrollView addSubview:timeLable];
        }else{
            titleLable.y = - titleLable.height-7;
        }
        
        CGFloat headHeight = titleLable.height + 14 +timeLable.height+7;
        
        self.scrollView.contentInset = UIEdgeInsetsMake(headHeight, 0, 0, 0);
//  文章结束后加上分享功能
        
        CGSize size = self.scrollView.contentSize;
        foot_Height = 130;
        
        footView = [[UIView alloc]initWithFrame:CGRectMake(0,size.height, frame.size.width, foot_Height)];
        footView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:footView];
        
        UIImage *smallImage = [UIImage imageNamed:@"footView_Default"];
        img_Height = (SCREEN_WIDTH * smallImage.size.height)/smallImage.size.width;
        
        UIImage *bigImage = [UIImage imageNamed:@"footView_Default"];
        CGFloat img_H = (SCREEN_WIDTH * bigImage.size.height)/bigImage.size.width;
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, footView.width,img_H)];
        bgImageView.image = bigImage;
        [footView addSubview:bgImageView];
        footView.height = img_H;
        
         //加个阅读规范：
        UILabel *warnLable = [[UILabel alloc]initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,30)];
        
//        warnLable.text = @"------ 直抒胸臆 理性爱国 ------";
        warnLable.textColor = RGB(120, 120, 120);
        warnLable.font = [UIFont boldSystemFontOfSize:15];
        warnLable.textAlignment = NSTextAlignmentCenter;
        [footView addSubview:warnLable];
        warnLable.attributedText = [NSAttributedString_Encapsulation  string:@"直抒胸臆 理性爱国" withLineImage:@"no_content_arrow_image" withLableHeight:30];
        
        
        [self createShareBtnWithFrame:CGRectMake(0, 100, 70, 70)];
    
        
        [self addObserverForWebViewContentSize];
        
    }
    return self;
}
-(void)shareBtnClicked{
    if ([self.shareDelegate respondsToSelector:@selector(webShareBtnClicked)]) {
        [self.shareDelegate webShareBtnClicked];
    }
}

-(void)createShareBtnWithFrame:(CGRect)rect{
    
    CGFloat btnY = rect.origin.y;
    CGFloat btnW = rect.size.width;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake((SCREEN_WIDTH - btnW)*0.5,btnY, btnW, btnW);
    layer.backgroundColor = RGB(249, 60, 56).CGColor;
    layer.shadowColor = RGB(249, 60, 56).CGColor;
    layer.shadowOffset = CGSizeMake(0,0);
    layer.shadowOpacity = 0.7;
    layer.cornerRadius = btnW *0.5;
    [footView.layer addSublayer:layer];
    
    shareBtn = [[UIButton alloc]initWithFrame:rect];
    shareBtn.centerX = footView.centerX;
    shareBtn.backgroundColor = RGB(249, 60, 56);
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.layer.cornerRadius = btnW*0.5;
    shareBtn.layer.masksToBounds = YES;
    [footView addSubview:shareBtn];
    
    numLable = [[UILabel alloc]initWithFrame:CGRectMake(0,shareBtn.max_Y+10,SCREEN_WIDTH,20)];
    numLable.textColor = RGB(100, 100, 100);
    numLable.font = [UIFont systemFontOfSize:13];
    numLable.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:numLable];
    
}



- (void)addObserverForWebViewContentSize{
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
}
- (void)removeObserverForWebViewContentSize{
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //取消监听，因为这里会调整contentSize，避免无限递归
    [self removeObserverForWebViewContentSize];
    CGSize contentSize = self.scrollView.contentSize;
    footView.y = contentSize.height;
   
    self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + img_Height);
    
    //重新监听
    [self addObserverForWebViewContentSize];
}

-(void)setLikeCount:(NSString *)likeCount{
    numLable.text = [NSString stringWithFormat:@"%@人已分享",likeCount];
}

-(void)setCanShare:(BOOL)canShare{
    if (canShare) {
//        可以分享
        shareBtn.backgroundColor = RGB(249, 60, 56);
        shareBtn.enabled = YES;
    }else{
//        不可以分享
        shareBtn.backgroundColor = RGB(227, 227, 227);
        shareBtn.enabled = NO;
        
        numLable.text = @"此文章暂不支持分享";
    }
}



-(void)dealloc{
    [self removeObserverForWebViewContentSize];
}




#pragma -mark UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeClear];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [WSProgressHUD dismiss];
}



@end

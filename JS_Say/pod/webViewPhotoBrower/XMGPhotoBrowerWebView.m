//
//  XMGPhotoBrowerWebView.m
//  XMGBPhotoBrower
//
//  Created by machao on 2017/6/7.
//  Copyright © 2017年 machao. All rights reserved.
//

#import "XMGPhotoBrowerWebView.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"


//#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface XMGPhotoBrowerWebView ()<UIWebViewDelegate,SDPhotoBrowserDelegate>
{
    NSMutableArray *_imageArray;
    NSMutableArray *_imageUrlArray;
    UILabel *titleLable;
    UILabel *timeLable;
    UIButton *shareBtn;
    UIView *footView;//尾视图
    CGFloat foot_Height;
    CGFloat img_Height;
    
    UILabel *numLable;
}

@property (nonatomic, assign) NSInteger index;
/// 容器视图
@property (nonatomic, strong) UIView *contenterView;


@end

@implementation XMGPhotoBrowerWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contenterView = [[UIView alloc] init];
        _contenterView.center = self.center;
        self.delegate = self;
        [self addSubview:_contenterView];
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame WithTitleText:(NSString *)titleStr WithTimeStr:(NSString *)timeStr{
    self = [super initWithFrame:frame];
    if (self) {
        _contenterView = [[UIView alloc] init];
        _contenterView.center = self.center;
        self.delegate = self;
        [self addSubview:_contenterView];
        
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
    if ([self.webViewDelegate respondsToSelector:@selector(webShareBtnClicked)]) {
        [self.webViewDelegate webShareBtnClicked];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    [self removeObserverForWebViewContentSize];
}

#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSString *imageName = _imageUrlArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imageView = _imageArray[index];
    return imageView.image;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        for (NSInteger i = 0; i<_imageUrlArray.count; i++) {
            if ([path isEqualToString:_imageUrlArray[i]]) {
                _index = i;
            }
        }
        
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.currentImageIndex = _index;
        browser.sourceImagesContainerView = _contenterView;
        browser.imageCount = _imageUrlArray.count;
        browser.delegate = self;
        [browser show];
        
        return NO;
    }
    if ([self.webViewDelegate respondsToSelector:@selector(xmgWebView:shouldStartLoadWithRequest:navigationType:)]) {
        [self.webViewDelegate xmgWebView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self stringByEvaluatingJavaScriptFromString:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}"];
    
    [self stringByEvaluatingJavaScriptFromString:@"assignImageClickAction();"];
    //
    [ webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout=‘none‘;"];//禁止长按
    
    _imageUrlArray= [self getImgs];//获取所有图片链接
    NSMutableArray *array=[[ NSMutableArray alloc] init];
    for (NSString *string in _imageUrlArray) //剔除没有规则的图集
    {
        
        //        if ([string hasSuffix:@".png"]||[string hasSuffix:@".jpg"]||[string hasSuffix:@".jpeg"])
        //        {
        [array addObject:string];
        //        }
    }
    _imageUrlArray=array;
    _imageArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _imageUrlArray.count; i++) {
        UIImageView *view = [[UIImageView alloc] init];
        [_imageArray addObject:view];
        [view sd_setImageWithURL:_imageUrlArray[i] placeholderImage:[UIImage imageNamed:@""]];
        [_contenterView addSubview:view];
    }
    if ([self.webViewDelegate respondsToSelector:@selector(xmgWebViewDidFinishLoad:)]) {
        [self.webViewDelegate xmgWebViewDidFinishLoad:webView];
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    if ([self.webViewDelegate respondsToSelector:@selector(xmgWebViewDidStartLoad:)]) {
        [self.webViewDelegate xmgWebViewDidStartLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if ([self.webViewDelegate respondsToSelector:@selector(xmgWebView:didFailLoadWithError:)]) {
        [self.webViewDelegate xmgWebView:webView didFailLoadWithError:error];
    }
}
//获取某个标签的结点个数
- (int)nodeCountOfTag:(NSString *)tag {
    
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('%@').length", tag];
    int len = [[self stringByEvaluatingJavaScriptFromString:jsString] intValue]; return len;
}
//获取所有图片链接
- (NSMutableArray *)getImgs
{
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    int node = [self nodeCountOfTag:@"img"];
    for (int i = 0; i < node; i++)
    {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
        NSString *img = [self stringByEvaluatingJavaScriptFromString:jsString];
        [arrImgURL addObject:img];
    }
    return arrImgURL;
}


@end

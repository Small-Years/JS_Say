//
//  ViewController.m
//  父子控制器
//
//  Created by 戴川 on 16/6/3.
//  Copyright © 2016年 戴川. All rights reserved.
//

#import "DCNavTabBarController.h"

#define DCScreenW    [UIScreen mainScreen].bounds.size.width
#define DCScreenH    [UIScreen mainScreen].bounds.size.height

#define S_height 30

@interface DCNavTabBarController ()<UIScrollViewDelegate>{
    UIScrollView *scrollView;
}
@property (nonatomic, weak) UIButton *oldBtn;
@property(nonatomic,strong)NSArray *VCArr;
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) UIScrollView *topBar;
@property(nonatomic,assign) CGFloat btnW ;

@property (nonatomic, weak) UIView *slider;

@end

@implementation DCNavTabBarController
-(UIColor *)sliderColor
{
    if(_sliderColor == nil)
    {
        _sliderColor = [UIColor purpleColor];
    }
    return  _sliderColor;
}
-(UIColor *)btnTextNomalColor
{
    if(_btnTextNomalColor == nil)
    {
        _btnTextNomalColor = [UIColor blackColor];
    }
    return _btnTextNomalColor;
}
-(UIColor *)btnTextSeletedColor
{
    if(_btnTextSeletedColor == nil)
    {
        _btnTextSeletedColor = [UIColor redColor];
    }
    return _btnTextSeletedColor;
}
-(UIColor *)topBarColor
{
    if(_topBarColor == nil)
    {
        _topBarColor = [UIColor whiteColor];
    }
    return _topBarColor;
}
-(instancetype)initWithSubViewControllers:(NSArray *)subViewControllers
{
    self = [super init];
    if(self){
        _VCArr = subViewControllers;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //添加上面的导航条
    [self addTopBar];
    //添加子控制器
    [self addVCView];
    //添加滑块
    [self addSliderView];
    
    [self applyTheme];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kChangeThemeNotification object:nil];
}
- (void)applyTheme {
    if ([ThemeManagement shareManagement].isDarkTheme) {
        //背景颜色
        scrollView.backgroundColor = [UIColor colorWithRed:40/255.f green:40/255.f blue:51/255.f alpha:1.f];
        //        遍历设置文字颜色
        for (id obj in self.topBar.subviews)  {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton* theButton = (UIButton*)obj;
                [theButton setTitleColor:[UIColor colorWithRed:0.74 green:0.77 blue:0.82 alpha:1] forState:UIControlStateNormal];
                [theButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            }
        }
    } else {
        scrollView.backgroundColor = RGB(227, 227, 227);
        for (id obj in self.topBar.subviews)  {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton* theButton = (UIButton*)obj;
                [theButton setTitleColor:RGB(74, 74, 74) forState:UIControlStateNormal];
                [theButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            }
        }
    }
}
-(void)addSliderView
{
    if(self.VCArr.count == 0) return;
    UIView *slider = [[UIView alloc]initWithFrame:CGRectMake(0,S_height-2,self.btnW, 2)];
    slider.backgroundColor = [UIColor clearColor];
    [self.topBar addSubview:slider];
    
    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.btnW*0.5, slider.height)];
    colorView.backgroundColor = self.sliderColor;
    colorView.centerX = slider.centerX;
    [slider addSubview:colorView];
    
    self.slider = slider;
}
-(void)addTopBar
{
    if(self.VCArr.count == 0) return;
    NSUInteger count = self.VCArr.count;
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DCScreenW, S_height)];
    scrollView.backgroundColor = self.topBarColor;
    self.topBar = scrollView;
//    self.topBar.bounces = NO;
    [self.view addSubview:self.topBar];
    
    if(count <= 5)
    {
         self.btnW = DCScreenW / count;
    }else
    {
         self.btnW = DCScreenW / 5.0;
    }
    //添加button
    for (int i=0; i<count; i++)
    {
        UIViewController *vc = self.VCArr[i];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*self.btnW, 0, self.btnW, S_height)];
        btn.tag = 10000+i;
        [btn setTitleColor:self.btnTextNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.btnTextSeletedColor forState:UIControlStateSelected];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.topBar addSubview:btn];
        if(i == 0){
            btn.selected = YES;
            //默认one文字放大
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.oldBtn = btn;
        }
    }
    self.topBar.contentSize = CGSizeMake(self.btnW *count, 0);
}
-(void)addVCView
{
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0+S_height, DCScreenW, DCScreenH -S_height)];
    self.contentView = contentView;
    self.contentView.bounces = NO;
    contentView.delegate = self;
    contentView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:contentView];
    
    NSUInteger count = self.VCArr.count;
    for (int i=0; i<count; i++) {
        UIViewController *vc = self.VCArr[i];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(i*DCScreenW, 0, DCScreenW, DCScreenH -S_height);
        [contentView addSubview:vc.view];
    }
    contentView.contentSize = CGSizeMake(count*DCScreenW, DCScreenH-S_height);
    contentView.pagingEnabled = YES;
}
-(void)click:(UIButton *)sender
{
    if(sender.selected) return;
    self.oldBtn.selected = NO;
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.contentOffset = CGPointMake((sender.tag - 10000)*DCScreenW, 0);
        sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
    self.oldBtn.transform = CGAffineTransformIdentity;
    self.oldBtn = sender;
    
    //判断导航条是否需要移动
    CGFloat maxX = CGRectGetMaxX(self.slider.frame);
    if(maxX >=DCScreenW  && sender.tag != self.VCArr.count + 10000 - 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.topBar.contentOffset = CGPointMake(maxX - DCScreenW + self.btnW, 0);
        }];
    }else if(maxX < DCScreenW)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.topBar.contentOffset = CGPointMake(0, 0);
        }];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滑动导航条
    self.slider.frame = CGRectMake(scrollView.contentOffset.x / DCScreenW *self.btnW , S_height-2, self.btnW, 2);
}
//判断是否切换导航条按钮的状态
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offX =  scrollView.contentOffset.x;
    int tag = (int)(offX /DCScreenW + 0.5) + 10000;
    UIButton *btn = [self.view viewWithTag:tag];
    if(tag != self.oldBtn.tag)
    {
        [self click:btn];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

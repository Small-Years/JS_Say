//
//  RometeView.m
//  RomateDemo
//
//  Created by tianlei on 16/6/30.
//  Copyright © 2016年 tianlei. All rights reserved.
//

#import "RometeView.h"
#import "KTOneFingerRotationGestureRecognizer.h"

@interface RometeView ()


@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, assign) CGFloat rotationAngleInRadians;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) BOOL isShow;

@end


@implementation RometeView

//static RometeView *shareInstance;

//+ (instancetype)sharedRometeView{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        shareInstance = [[RometeView alloc] init];
//    });
//    return shareInstance;
//}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 200, 200);
        self.backgroundColor = [UIColor blueColor];
        [self initData];
       // [self addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(changeRomate:)]];
        [self addGestureRecognizer:[[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(changeRomate:)]];
        _isShow = NO;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)rect{
    self = [super initWithFrame:rect];
    if (self) {
        self.frame = rect;
        self.backgroundColor = [UIColor blueColor];
        [self initData];
        [self addGestureRecognizer:[[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(changeRomate:)]];
        _isShow = NO;
    }
    return self;
}

- (void)initData{
    _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    _button.backgroundColor = [UIColor yellowColor];
    _button.layer.cornerRadius = 27.5;
    [_button addTarget:self action:@selector(showItems:) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:_button];
    _button.center = CGPointMake(415/2.0, 415/2.0);
    _btnArray = [NSMutableArray array];
}

- (void)setMenuCount:(NSInteger)menuCount{
    _menuCount = menuCount;
    for (int i = 0; i < self.menuCount; i ++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x, self.center.y, 55, 55)];
        [btn setTitle:[NSString stringWithFormat:@"%zd", i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 27.5;
        btn.center = self.center;
        btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.alpha = 0;
        [self addSubview:btn];
        [_btnArray addObject:btn];
    }
//    if(self.menuCount > 5){
//        int index = 0;
//        for (int i = (int)_btnArray.count; i < 13; i ++) {
//            NSInteger titleCount = _btnArray.count - index-1;
//            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x, self.center.y, 55, 55)];
//            [btn setTitle:[NSString stringWithFormat:@"%zd", titleCount] forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            btn.layer.cornerRadius = 27.5;
//            btn.center = self.center;
//            btn.backgroundColor = [UIColor redColor];
//            [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
//            btn.alpha = 0;
//             [self addSubview:btn];
//            [_btnArray addObject:btn];
//            index ++;
//        }
//    }
}


- (void)showItems:(UIButton *)sender{
    
    NSLog( @"show" );
    
    if (!_isShow) {
        [UIView animateWithDuration:0.2 animations:^{
            CGFloat corner = -M_PI * 2.0 / 13.0;
            CGFloat r = 180;
            CGFloat x = 415/2.0;
            CGFloat y = 415/2.0;
            
            for (int i = 0; i < _btnArray.count; i ++) {
                UIButton *btn = _btnArray[i];
                CGFloat ti = i * 1.0;
                btn.center = CGPointMake(x + r * cos(corner * ti), y + r *sin(corner * ti));
                btn.alpha = 1;
            }
        }];
    }else{
        [UIView animateWithDuration:2 animations:^{
//            CGFloat corner = -M_PI * 2.0 / 13.0;
//            CGFloat r = 180;
//            CGFloat x = 415/2.0;
//            CGFloat y = 415/2.0;
            
            for (int i = 0; i < _btnArray.count; i ++) {
                UIButton *btn = _btnArray[i];
                //CGFloat ti = i * 1.0;
                btn.center = CGPointMake(415/2.0, 415/2.0);
                btn.alpha = 0;
            }
        }];
    }
    _isShow = !_isShow;
}


- (void)show{
    
    NSLog( @"show" );
    
    if (!_isShow) {
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat corner = -M_PI * 2.0 / 13.0;
            CGFloat r = 180;
            CGFloat x = 415/2.0;
            CGFloat y = 415/2.0;
            
            for (int i = 0; i < _btnArray.count; i ++) {
                UIButton *btn = _btnArray[i];
                CGFloat ti = (i+3-0.1) * 1.0;
                btn.center = CGPointMake(x + r * cos(corner * ti), y + r *sin(corner * ti));
                btn.alpha = 1;
            }
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            //            CGFloat corner = -M_PI * 2.0 / 13.0;
            //            CGFloat r = 180;
            //            CGFloat x = 415/2.0;
            //            CGFloat y = 415/2.0;
            
            for (int i = 0; i < _btnArray.count; i ++) {
                UIButton *btn = _btnArray[i];
                //CGFloat ti = i * 1.0;
                btn.center = CGPointMake(415/2.0, 415/2.0);
                btn.alpha = 0;
            }
        }];
    }
    _isShow = !_isShow;

  
}

- (void)clickButton:(UIButton *)sender{
    
    _isShow = YES;
    [self show];
    
    if ([self.delegate respondsToSelector:@selector(itemsButtonClicked:)]) {
        [self.delegate itemsButtonClicked:sender];
    }
}

- (void)changeRomate:(KTOneFingerRotationGestureRecognizer *)rotation{
    
    if (self.menuCount <= 5 ) {
        return;
    }
    
    if (self.menuCount < 13) {
        if (self.rotationAngleInRadians == 0 && rotation.rotation > 0) {
            return;
        }
    }
    
    
    self.transform = CGAffineTransformMakeRotation(self.rotationAngleInRadians
                                                                   +rotation.rotation);
    _button.transform = CGAffineTransformMakeRotation(-(self.rotationAngleInRadians
                                                        +rotation.rotation));
    for (UIButton *btn in _btnArray) {
        btn.transform = CGAffineTransformMakeRotation(-(self.rotationAngleInRadians+rotation.rotation));
    }
    self.rotationAngleInRadians += rotation.rotation;
}
@end

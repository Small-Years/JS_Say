//
//  MMZCViewController.m
//  MMR
//
//  Created by qianfeng on 15/6/30.
//  Copyright © 2015年 MaskMan. All rights reserved.
//

#import "MMZCViewController.h"
#import "forgetPassWardViewController.h"
#import "AppDelegate.h"
#import "MMZCHMViewController.h"
#import "UIView+Extension.h"
#import "settingPassWardViewController.h"

@interface MMZCViewController ()
{
    UIImageView *View;
    UIView *logBgView;
    UITextField *pwd;
    UITextField *user;
}
@property(copy,nonatomic) NSString * accountNumber;
@property(copy,nonatomic) NSString * mmmm;
//@property(copy,nonatomic) NSString * user;


@end

@implementation MMZCViewController

-(void)viewWillAppear:(BOOL)animated{
   //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:216/255.0f green:209/255.0f blue:192/255.0f alpha:1]];
    self.navigationController.navigationBarHidden = YES;
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad{
    [super viewDidLoad];

    View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //View.backgroundColor=[UIColor redColor];
    View.image=[UIImage imageNamed:@"bg4"];
    [self.view addSubview:View];
    
    //为了显示背景图片自定义navgationbar上面的三个按钮
    UIButton *but =[[UIButton alloc]initWithFrame:CGRectMake(5, 27, 35, 35)];
    [but setImage:[UIImage imageNamed:@"goback_back_orange_on"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UIButton *zhuce =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 30, 50, 30)];
    [zhuce setTitle:@"注册" forState:UIControlStateNormal];
    [zhuce setTitleColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1] forState:UIControlStateNormal];
//    zhuce.font=[UIFont systemFontOfSize:17];
    zhuce.titleLabel.font = [UIFont systemFontOfSize:17];
    [zhuce addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhuce];
    
    
    UILabel *lanel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-30)/2, 30, 50, 30)];
    lanel.text=@"登录";
    lanel.textColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.view addSubview:lanel];

    
    [self createTextFields];
    [self createButtons];
}

-(void)clickaddBtn:(UIButton *)button{
    self.view.backgroundColor=[UIColor whiteColor];
    exit(0);
}


-(void)createTextFields{
    CGRect frame=[UIScreen mainScreen].bounds;
    logBgView=[[UIView alloc]initWithFrame:CGRectMake(10, 75, frame.size.width-20, 100)];
    logBgView.layer.cornerRadius=3.0;
    logBgView.alpha=0.7;
    logBgView.backgroundColor=[UIColor whiteColor];
    logBgView.centerY = self.view.centerY-80;
    [self.view addSubview:logBgView];
    
    user=[self createTextFielfFrame:CGRectMake(60, 10, 271, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入您的账号"];
    user.keyboardType=UIKeyboardTypeNumberPad;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
   
    pwd=[self createTextFielfFrame:CGRectMake(60, 60, 271, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"密码" ];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    pwd.secureTextEntry=YES;
    //pwd.keyboardType=UIKeyboardTypeNumberPad;

    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(20, 10, 25, 25) imageName:@"ic_landing_nickname" color:nil];
    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(20, 60, 25, 25) imageName:@"mm_normal" color:nil];
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, logBgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    [logBgView addSubview:user];
    [logBgView addSubview:pwd];
    
    [logBgView addSubview:userImageView];
    [logBgView addSubview:pwdImageView];
    [logBgView addSubview:line1];
}
-(void)createButtons{
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, logBgView.max_Y+25 , self.view.frame.size.width-20, 40) backImageName:nil title:@"登录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:19] target:self action:@selector(logBtnClicked)];
    landBtn.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    landBtn.layer.cornerRadius=5.0f;
    
    UIButton *newUserBtn=[self createButtonFrame:CGRectMake(0, landBtn.max_Y+20, 90, 30) backImageName:nil title:@"快速注册" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(registration:)];

    
    UIButton *forgotPwdBtn=[self createButtonFrame:CGRectMake(self.view.frame.size.width-newUserBtn.width, newUserBtn.y, newUserBtn.width, newUserBtn.height) backImageName:nil title:@"找回密码" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(fogetPwd:)];
    
    
    [self.view addSubview:landBtn];
    [self.view addSubview:newUserBtn];
    [self.view addSubview:forgotPwdBtn];
}

-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}






                     
-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

//用户名密码登陆
-(void)logBtnClicked{
    if ([user.text isEqualToString:@""] || [pwd.text isEqualToString:@""]){
        [WSProgressHUD showErrorWithStatus:@"信息不完整"];
        return;
    }
    [AVUser logInWithUsernameInBackground:user.text password:pwd.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            NSLog(@"账号密码登陆成功：---%@",user);
            //登陆成功之后，跳到首页，如果注册完成之后再点击的登陆，就没法跳回去了
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
//            NSLog(@"账号密码登陆失败：---%d",error.code);
            NSInteger errorCode = error.code;
            NSString *errorDescription = error.localizedDescription;
            switch (errorCode) {
                case 210:
                    errorDescription = @"用户名和密码不匹配";
                    break;
                default:
                    break;
            }
            [WSProgressHUD showErrorWithStatus:errorDescription];
        }
    }];
    
}
//登录
-(void)landClick
{
    if ([user.text isEqualToString:@""])
    {
        [WSProgressHUD showWithStatus:@"亲,请输入用户名"];
        return;
    }
    else if (user.text.length <11)
    {
        [WSProgressHUD showWithStatus:@"您输入的手机号码格式不正确"];
        return;
    }
    else if ([pwd.text isEqualToString:@""])
    {
        [WSProgressHUD showWithStatus:@"亲,请输入密码"];
        return;
    }
    else if (pwd.text.length <6)
    {
        [WSProgressHUD showWithStatus:@"亲,密码长度至少六位"];
        return;
    }
    //登录
    [AVUser logInWithMobilePhoneNumberInBackground:user.text password:pwd.text block:^(AVUser *user, NSError *error) {
        if (error) {
            [WSProgressHUD showErrorWithStatus:@"登陆失败"];
        }else{
            [WSProgressHUD showSuccessWithStatus:@"登录成功"];
            NSLog(@"登录成功：%@",user);
        }
    }];
    
    
    
}

//注册
-(void)zhuce
{
    [self.navigationController pushViewController:[[settingPassWardViewController alloc]init] animated:YES];
}

-(void)registration:(UIButton *)button
{
   [self.navigationController pushViewController:[[MMZCHMViewController alloc]init] animated:YES];
}

-(void)fogetPwd:(UIButton *)button
{
   [self.navigationController pushViewController:[[forgetPassWardViewController alloc]init] animated:YES];
}

#pragma mark - 工具
//手机号格式化
-(NSString*)getHiddenStringWithPhoneNumber:(NSString*)number middle:(NSInteger)countHiiden{
    // if (number.length>6) {
    
    if (number.length<countHiiden) {
        return number;
    }
    NSInteger count=countHiiden;
    NSInteger leftCount=number.length/2-count/2;
    NSString *xings=@"";
    for (int i=0; i<count; i++) {
        xings=[NSString stringWithFormat:@"%@%@",xings,@"*"];
    }
    
    NSString *chuLi=[number stringByReplacingCharactersInRange:NSMakeRange(leftCount, count) withString:xings];
    // chuLi=[chuLi stringByReplacingCharactersInRange:NSMakeRange(number.length-count, count-leftCount) withString:xings];
    
    return chuLi;
}

//手机号格式化后还原
-(NSString*)getHiddenStringWithPhoneNumber1:(NSString*)number middle:(NSInteger)countHiiden{
    // if (number.length>6) {
    if (number.length<countHiiden) {
        return number;
    }
//    NSString *xings = @"";
    for (int i=0; i<1; i++) {
//        xings=[NSString stringWithFormat:@"%@",[CheckTools getUser]];
    }
    
    NSString *chuLi=[number stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:@""];
    
    return chuLi;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



@end

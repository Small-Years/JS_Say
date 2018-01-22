//
//  settingPassWardViewController.m
//  chuanke
//
//  Created by mj on 15/11/30.
//  Copyright © 2015年 jinzelu. All rights reserved.
//

#import "settingPassWardViewController.h"
#import "settinhHeaderViewController.h"
#import "MMZCViewController.h"


@interface settingPassWardViewController ()
{
    UIView *bgView;
    UITextField *passward;
    UITextField *userName;
}

@end

@implementation settingPassWardViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"账号密码注册";
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@"leftImage"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    addBtn.tintColor = [UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    [self createTextFields];
}

-(void)createTextFields{
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 75, self.view.frame.size.width-90, 30)];
    label.text=@"请填写账号密码";
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13];
    
    [self.view addSubview:label];
    
    
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 110, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    userName=[self createTextFielfFrame:CGRectMake(100, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"用户名"];
    userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    userName.keyboardType=UIKeyboardTypeNumberPad;
    
    passward=[self createTextFielfFrame:CGRectMake(100, 60, 90, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"输入密码" ];
    passward.clearButtonMode = UITextFieldViewModeWhileEditing;
    //code.text=@"mojun1992225";
    //密文样式
    passward.secureTextEntry = NO;
    passward.keyboardType=UIKeyboardTypeNumberPad;
    
    
    UILabel *phonelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 25)];
    phonelabel.text=@"用户名";
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment=NSTextAlignmentLeft;
    phonelabel.font=[UIFont systemFontOfSize:14];
    
    UILabel *passWordLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 62, 50, 25)];
    passWordLabel.text=@"密码";
    passWordLabel.textColor=[UIColor blackColor];
    passWordLabel.textAlignment=NSTextAlignmentLeft;
    passWordLabel.font=[UIFont systemFontOfSize:14];
    
    
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    //    直接注册
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"注册" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(zhuceBtnClicked)];
    landBtn.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    landBtn.layer.cornerRadius=5.0f;
    
    //    下一步
    //    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"下一步" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(next)];
    //    landBtn.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    //    landBtn.layer.cornerRadius=5.0f;
    
    
    [bgView addSubview:userName];
    [bgView addSubview:passward];
    
    [bgView addSubview:phonelabel];
    [bgView addSubview:passWordLabel];
    [bgView addSubview:line1];
    [self.view addSubview:landBtn];
}


-(void)zhuceBtnClicked{
    if([passward.text isEqualToString:@""] || [userName.text isEqualToString:@""])
    {
        [WSProgressHUD showErrorWithStatus:@"信息不完整"];
        return;
    }
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = userName.text;// 设置用户名
    user.password = passward.text;// 设置密码
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 注册成功,跳转到登陆界面，自动填充用户名
            [WSProgressHUD showSuccessWithStatus:@"注册成功！"];
//            MMZCViewController *logVC = [[MMZCViewController alloc]init];
//            [self.navigationController pushViewController:logVC animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            // 失败的原因可能有多种，常见的是用户名已经存在。
            [WSProgressHUD showErrorWithStatus:@"注册失败！"];
            NSLog(@"账号密码注册失败：----%@",error);
        }
    }];
    
    [[AVUser currentUser] setObject:[NSNumber numberWithInt:25] forKey:@"headImage"];
    [[AVUser currentUser] saveInBackground];
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

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

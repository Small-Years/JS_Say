//
//  SetViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/9/25.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>{
    TBbaseTableView *mainTable;
}
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation SetViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
        NSArray *arr1 = @[@{@"name":@"消息",@"iconName":@"消息",@"code":@"1"}];
        NSArray *arr2 = @[@{@"name":@"夜间模式",@"iconName":@"夜间模式",@"code":@"2"},@{@"name":@"去除广告",@"iconName":@"去除广告",@"code":@"3"}];
        NSArray *arr3 = @[@{@"name":@"推荐给朋友",@"iconName":@"推荐给朋友",@"code":@"4"},@{@"name":@"收藏时分享",@"iconName":@"收藏时分享",@"code":@"5"}];
        NSArray *arr4 = @[@{@"name":@"给一线军情提意见",@"iconName":@"给一线军情提意见",@"code":@"6"},@{@"name":@"为一线军情评分",@"iconName":@"为一线军情评分",@"code":@"7"},@{@"name":@"关于",@"iconName":@"关于",@"code":@"8"}];
        [self.dataArray addObject:arr1];
        [self.dataArray addObject:arr2];
        [self.dataArray addObject:arr3];
        [self.dataArray addObject:arr4];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    mainTable = [[TBbaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    mainTable.dataSource = self;
    mainTable.delegate = self;
//    mainTable.tableFooterView = [[UIView alloc]init];
//    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    mainTable.estimatedSectionHeaderHeight = 0;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainTable.width, 80)];
    footView.backgroundColor = [UIColor whiteColor];
    mainTable.tableFooterView = footView;
    
    UIButton *logOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,20, mainTable.width - 60, 40)];
    logOutBtn.centerX = footView.centerX;
    
    [logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    logOutBtn.layer.cornerRadius = 7;
    logOutBtn.layer.masksToBounds = YES;
    [logOutBtn addTarget:self action:@selector(logOutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:logOutBtn];
    if ([AVUser currentUser] == nil) {
        logOutBtn.userInteractionEnabled = NO;
        [logOutBtn setBackgroundColor:RGB(155, 155, 155)];
    }else{
        logOutBtn.userInteractionEnabled = YES;
        [logOutBtn setBackgroundColor:[UIColor redColor]];
    }
    
}

-(void)logOutBtnClicked:(UIButton *)btn{
    [AVUser logOut];  //清除缓存用户对象
    if ([AVUser currentUser] == nil) {
        btn.userInteractionEnabled = NO;
        [btn setBackgroundColor:RGB(155, 155, 155)];
    }else{
        
    }
}

#pragma mark -UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArray[section];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    TBbaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSArray *arr = self.dataArray[indexPath.section];
    NSDictionary *dict = arr[indexPath.row];
    if (cell == nil) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell = [[TBbaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 50)];
                [cell.contentView addSubview:backView];
                
                UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 26, 26)];
                iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dict objectForKey:@"iconName"]]];
                [backView addSubview:iconImageView];
                
                BaseLabel*titleLable = [[BaseLabel alloc]initWithFrame:CGRectMake(iconImageView.max_X+10,0,SCREEN_WIDTH - iconImageView.max_X-10-30,backView.height)];
                titleLable.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                titleLable.font = [UIFont systemFontOfSize:16];
                titleLable.textAlignment = NSTextAlignmentLeft;
                [backView addSubview:titleLable];
                
                UISwitch *mSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 0, 10, 10)];
                mSwitch.centerY = backView.centerY;
                if ([ThemeManagement shareManagement].isDarkTheme) {
                    mSwitch.on = YES;
                }else{
                    mSwitch.on = NO;
                }
                [mSwitch addTarget:self action:@selector(SwitchAction:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:mSwitch];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        cell = [[TBbaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 50)];
        [cell.contentView addSubview:backView];
        
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 26, 26)];
        iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dict objectForKey:@"iconName"]]];
        [backView addSubview:iconImageView];
        
        BaseLabel *titleLable = [[BaseLabel alloc]initWithFrame:CGRectMake(iconImageView.max_X+10,0,SCREEN_WIDTH - iconImageView.max_X-10-30,backView.height)];
        titleLable.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        titleLable.font = [UIFont systemFontOfSize:16];
        titleLable.textAlignment = NSTextAlignmentLeft;
        [backView addSubview:titleLable];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BaseTableHeaderView *headView = [[BaseTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *arr = self.dataArray[indexPath.section];
    NSDictionary *dict = arr[indexPath.row];
    NSString *codeStr = [dict objectForKey:@"code"];
    int code = codeStr.intValue;
    switch (code) {
        case 1:
            NSLog(@"点击的是1");
            break;
        case 2:
            //            NSLog(@"内购模式");
            break;
        default:
            break;
    }
    
}

#pragma mark - btnClicked
-(void)SwitchAction:(UISwitch *)sender{
    if (sender.on == YES) {
//        NSLog(@"---夜间模式");
        //刷新界面，设置文字和背景颜色
        [ThemeManagement shareManagement].isDarkTheme = YES;
        [USER_DEFAULT setObject:@"YES" forKey:@"isDark"];
    }else{
//        NSLog(@"---白天模式");
        [ThemeManagement shareManagement].isDarkTheme = NO;
        [USER_DEFAULT setObject:@"NO" forKey:@"isDark"];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kChangeThemeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

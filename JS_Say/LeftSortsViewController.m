//
//  LeftSortsViewController.m
//  FQQCeHuaDemo
//
//  Created by Meng Fan on 16/6/2.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "ItemViewController.h"
#import "TBSearchViewController.h"
#import "PYSearchViewController.h"
#import "WeaponsViewController.h"
#import "historyViewController.h"
#import "SetViewController.h"
#import "LoveListViewController.h"
#import "MMZCViewController.h"
//#import "settingPassWardViewController.h"
#import "settinhHeaderViewController.h"

@interface LeftSortsViewController ()<UITableViewDelegate, UITableViewDataSource,PYSearchViewControllerDelegate>
{
    NSArray *titleArray;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LeftSortsViewController

-(void)viewWillAppear:(BOOL)animated{
    _tableView.tableHeaderView = [self creatHeadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArray = @[@"搜索", @"中国情报", @"国际情报",@"军情解密", @"军事秘闻",@"历史闲谈",@"武器"];
    
    //初始化背景图片
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [UIImage imageNamed:@"leftBackImage.png"];
    [self.view addSubview:bgImgView];
    
    //初始化表视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-180) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor blueColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    _tableView.tableHeaderView = [self creatHeadView];
    _tableView.tableFooterView = [self createFootView];
}

-(UIView *)creatHeadView{//创建tableView的headView
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,_tableView.width,140)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,70, 70)];
    headImageView.centerY = headView.centerY - 10;
    headImageView.centerX = headView.centerX * 0.5;
    if ([AVUser currentUser] == nil) {
        headImageView.image = [UIImage imageWithIcon:@"headImage_Default" border:4 color:[UIColor whiteColor]];
    }else{
        headImageView.image = [UIImage imageWithIcon:@"share_Default"border:4 color:[UIColor whiteColor]];
    }
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 35;

    YQMotionShadowView *showView = [YQMotionShadowView fromView:headImageView];
    [headView addSubview:showView];
    
    UIButton *headBtn = [[UIButton alloc]initWithFrame:headView.frame];
    [headBtn addTarget:self action:@selector(lognBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [headBtn setBackgroundColor:[UIColor clearColor]];
    [headView addSubview:headBtn];
    
    return headView;
}
-(void)lognBtnClicked{
    NSLog(@"点击头像登录");
    if ([AVUser currentUser] == nil) {
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.leftSlideVC closeLeftView];
        MMZCViewController *vc = [[MMZCViewController alloc]init];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
        [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
        
//        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [tempAppDelegate.leftSlideVC closeLeftView];
//        settingPassWardViewController *vc = [[settingPassWardViewController alloc]init];
//        [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
//        [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
    }else{
        //切换用户属性
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.leftSlideVC closeLeftView];
        settinhHeaderViewController *vc = [[settinhHeaderViewController alloc]init];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
        [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
    }
}

-(UIView *)createFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0,0, _tableView.width *0.5, 80)];
//    footView.backgroundColor = RGBA(247, 247, 245, 0.6);
    UIButton *loveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, footView.width/2,80)];
    [loveBtn setImage:[UIImage imageNamed:@"收藏2"] forState:UIControlStateNormal];
    [loveBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [loveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [loveBtn addTarget:self action:@selector(loveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:loveBtn];
    [loveBtn setImagePositionWithType:(SSImagePositionTypeTop) spacing:10];
    
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(loveBtn.max_X, loveBtn.y, loveBtn.width, loveBtn.height)];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [setBtn setImage:[UIImage imageNamed:@"设置2"] forState:UIControlStateNormal];
    [setBtn setImagePositionWithType:(SSImagePositionTypeTop) spacing:10];
    setBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [setBtn addTarget:self action:@selector(setBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:setBtn];
    
    return footView;
}

#pragma mark - BtnClicked
-(void)loveBtnClicked{
//    收藏列表
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC closeLeftView];
    LoveListViewController *vc = [[LoveListViewController alloc]init];
    [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
    [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
}
-(void)setBtnClicked{
    //设置界面
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC closeLeftView];
    SetViewController *vc = [[SetViewController alloc]init];
    [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
    [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_id = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.text = titleArray[indexPath.row];
    
    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"leftViewClicked"];
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC closeLeftView];
    
    if (indexPath.row == 0) {
        NSArray *hotSearchArray = @[@"朝鲜",@"导弹",@"叙利亚",@"航母",@"阅兵",@"歼20"];
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSearchArray searchBarPlaceholder:@"文章 视频 装备" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            
            TBSearchViewController *vc = [TBSearchViewController alloc];
            vc.searchText = searchText;
            [searchViewController.navigationController pushViewController:vc animated:YES];
        }];
        searchViewController.delegate = self;
        [tempAppDelegate.mainNavigationController pushViewController:searchViewController animated:YES];
        [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
        return;
    }
    NSString *titleStr = titleArray[indexPath.row];
    if ([titleStr isEqualToString:@"武器"]) {
        WeaponsViewController *vc = [[WeaponsViewController alloc]init];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
        [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
        return;
    }
    if ([titleStr isEqualToString:@"历史闲谈"]) {
        historyViewController *vc = [[historyViewController alloc]init];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
        [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
        return;
    }
    
    ItemViewController *otherVC = [[ItemViewController alloc] init];
    otherVC.titleStr = titleStr;

    [tempAppDelegate.mainNavigationController pushViewController:otherVC animated:YES];
    [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
}

#pragma mark - PYSearchViewControllerDelegate
-(void)didClickCancel:(PYSearchViewController *)searchViewController{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController popViewControllerAnimated:YES];
}

// 获取当前处于activity状态的view controller
- (UIViewController *)activityViewController{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}


@end

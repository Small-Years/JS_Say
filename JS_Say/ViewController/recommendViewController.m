//
//  soldierViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/3.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "recommendViewController.h"
#import "recommendTableViewCell.h"
#import "SDCycleScrollView.h"
#import "ChatInfoViewController.h"
#import "TBSearchViewController.h"
#import "nnnnnViewController.h"



@interface recommendViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UITextFieldDelegate,PYSearchViewControllerDelegate>{
    TBbaseTableView *mainTable;
    int pageIndex;
    int pageSize;
}
@property (nonatomic,strong)NSMutableArray * scrollDataArray;
@property (nonatomic,strong)NSMutableArray * tableDataArray;
@property (nonatomic,strong)NSMutableArray * hotSearchArray;

@property (strong,nonatomic) SDCycleScrollView *topPhotoBoworr;

@end

@implementation recommendViewController
-(NSMutableArray *)hotSearchArray{
    if (_hotSearchArray == nil) {
        _hotSearchArray = [NSMutableArray array];
    }
    return _hotSearchArray;
}
-(NSMutableArray *)tableDataArray{
    if (_tableDataArray == nil) {
        _tableDataArray = [NSMutableArray array];
    }
    return _tableDataArray;
}
-(NSMutableArray *)scrollDataArray{
    if (_scrollDataArray == nil) {
        _scrollDataArray = [NSMutableArray array];
    }
    return _scrollDataArray;
}
- (SDCycleScrollView *)topPhotoBoworr{
    if (_topPhotoBoworr == nil) {
        _topPhotoBoworr = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_WIDTH/2) delegate:self placeholderImage:nil];
        _topPhotoBoworr.boworrWidth = SCREEN_WIDTH ;
        _topPhotoBoworr.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _topPhotoBoworr.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _topPhotoBoworr.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _topPhotoBoworr.boworrWidth = SCREEN_WIDTH;
        _topPhotoBoworr.cellSpace = 10;
        _topPhotoBoworr.titleLabelHeight = 25;
        _topPhotoBoworr.autoScrollTimeInterval = 3;
        _topPhotoBoworr.placeholderImage = [UIImage imageNamed:@"video_Default"];
        _topPhotoBoworr.currentPageDotColor = [UIColor orangeColor];
//        _topPhotoBoworr.pageDotColor = RGBCOLOR(227, 227, 227);
//        _topPhotoBoworr.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
//        _topPhotoBoworr.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
        _topPhotoBoworr.pageControlBottomOffset = 20;
        _topPhotoBoworr.pageControlDotSize = CGSizeMake(6, 6);
        
        NSMutableArray *imageUrlAr = [NSMutableArray array];
        for (NSDictionary *dict in self.scrollDataArray) {
            NSString *url = [dict objectForKey:@"background"];
            [imageUrlAr addObject:url];
        }
        _topPhotoBoworr.imageURLStringsGroup = imageUrlAr;
        NSMutableArray *titleAr = [NSMutableArray array];
        for (NSDictionary *dict in self.scrollDataArray) {
            NSString *title = [dict objectForKey:@"title"];
            [titleAr addObject:title];
        }
        _topPhotoBoworr.titlesGroup = titleAr;
    }
    return _topPhotoBoworr;
}

#pragma mark -----BuildView
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 32);
    [btn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(menuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
//    创建tableView
    mainTable = [[TBbaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    mainTable.estimatedRowHeight = 350;  //  随便设个不那么离谱的值
    mainTable.rowHeight = UITableViewAutomaticDimension;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    创建tableview的headView；
    [mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
    }];

    mainTable.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(loadMoreData)];
    mainTable.mj_header = [AllMethod createTableViewHeader:self andSelect:@selector(loadScrollData)];
    
//    [self loadScrollData];
    
    //创建navigation的搜索框
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(-40, 0, SCREEN_WIDTH-100, 30)];
    textField.delegate = self;
    textField.placeholder = @"文章 视频 装备";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:14];
    
    self.navigationItem.titleView = textField;
    [self loadSearchData];
}
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController setNavigationBarHidden:YES];
}

//菜单显示为:
-(void)menuBtnClicked{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.leftSlideVC.closed) {
        [tempAppDelegate.leftSlideVC openLeftView];
    }else {
        [tempAppDelegate.leftSlideVC closeLeftView];
    }

}

-(void)loadSearchData{
    
    NSString *SURL = [NSString stringWithFormat:@"%@/select/types?pageInvertedIndex=0&pageSize=10&repeatSubmit=56658802&&signature=EFB7A9FA4FBDE75EAEC04F37239D0B48",kMainUrl];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:SURL withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"desc"] isEqualToString:@"成功"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *arr = [dict objectForKey:@"list"];
            for (NSDictionary *obj in arr) {
                [self.hotSearchArray addObject:[obj objectForKey:@"name"]];
            }
        }
    } withFailureBlock:^(NSError *error) {
        
    } progress:^(float progress) {
        
    }];
    
}


-(void)loadScrollData{
    pageIndex = 0;
    //获取推荐首页的轮播图地址
    
//    https://app.kanjunshi.net/common/banner/list?repeatSubmit=16274310&signature=8A0B625D51C6EC1C9979D707E29FD870
    NSString *url = [NSString stringWithFormat:@"%@/common/banner/list?repeatSubmit=16274310&signature=8A0B625D51C6EC1C9979D707E29FD870",kMainUrl];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"desc"] isEqualToString:@"成功"]) {
            self.scrollDataArray = [responseObject objectForKey:@"data"];
            //为tablview上的横向滚动视图得到数据,更新界面
            [self updateScrollView];
        }
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        
    } progress:^(float progress) {
        NSLog(@"progress：%f",progress);
    }];
    
    //获取推荐列表数据
    NSString *surl = [NSString stringWithFormat:@"%@/community/hotCampContent?pageInvertedIndex=0&pageSize=4&repeatSubmit=84332647&signature=BC25DA626C31A02D2F46A3DFBDD04BE5",kMainUrl];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:surl withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"desc"] isEqualToString:@"成功"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSString *pageNum = [dict objectForKey:@"pageInvertedIndex"];
            NSString *pageSizeStr = [dict objectForKey:@"pageInvertedIndex"];
            pageIndex = pageNum.intValue;
            pageSize = pageSizeStr.intValue;
            NSArray *arr = [dict objectForKey:@"list"];
            self.tableDataArray = [arr mutableCopy];
            [mainTable reloadData];
            [mainTable.mj_header endRefreshing];
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTable.mj_header endRefreshing];
    } progress:^(float progress){
        NSLog(@"progress：%f",progress);
    }];
}

-(void)loadMoreData{
    //////////////获取数据///////////////
    if (self.tableDataArray.count == 0) {
        [self loadScrollData];
        return;
    }

    NSString *url = [NSString stringWithFormat:@"%@/community/hotCampContent?pageInvertedIndex=%d&pageSize=%d&repeatSubmit=84332647&signature=BC25DA626C31A02D2F46A3DFBDD04BE5",kMainUrl,pageIndex,pageSize];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject){
        if ([[responseObject objectForKey:@"desc"] isEqualToString:@"成功"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *arr = [dict objectForKey:@"list"];
            for (NSDictionary *obj in arr) {
                [self.tableDataArray addObject:obj];
            }
        }
        [self updateScrollView];
        pageIndex = pageIndex - pageSize;
        if (pageIndex<pageSize) {
            [mainTable.mj_footer endRefreshingWithNoMoreData];
            return;
        }
    } withFailureBlock:^(NSError *error) {
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTable.mj_footer endRefreshing];
        
    } progress:^(float progress) {
        //        NSLog(@"progress：%f",progress);
    }];
}

-(void)updateScrollView{//更新界面
    mainTable.tableHeaderView = self.topPhotoBoworr;
    [mainTable reloadData];
    [mainTable.mj_header endRefreshing];
}

#pragma mark -UITableviewDlegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSDictionary *infoDict = self.tableDataArray[indexPath.row];
    recommendTableViewCell *cell = [recommendTableViewCell cellWithTableView:tableView withIdentifier:cellId WithDict:infoDict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *infoDict = self.tableDataArray[indexPath.row];
    
//    nnnnnViewController *vc = [[nnnnnViewController alloc]init];
//    vc.titleText = [infoDict objectForKey:@"title"];
//    vc.timeStr = [AllMethod changeMethodFromSQL:[infoDict objectForKey:@"createDate"] With:@"yyyy-MM-dd"] ;
//    vc.newsID = [infoDict objectForKey:@"id"];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    ChatInfoViewController *vc = [[ChatInfoViewController alloc]init];
    vc.infoDict = infoDict;
    vc.newsID = [infoDict objectForKey:@"id"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -SDCycleScrollViewDelegate

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSDictionary *dict = self.scrollDataArray[index];
    
//    从这里取出id来
    NSString *idURL = [dict objectForKey:@"url"];
    NSArray *array = [idURL componentsSeparatedByString:@"="]; //从字符A中分隔成2个元素的数组
    
    nnnnnViewController *vc = [[nnnnnViewController alloc]init];
    vc.newsID = [array lastObject];
    vc.titleText = [dict objectForKey:@"title"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:self.hotSearchArray searchBarPlaceholder:@"文章 视频 装备" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        TBSearchViewController *vc = [TBSearchViewController alloc];
        vc.searchText = searchText;
        [searchViewController.navigationController pushViewController:vc animated:YES];
    }];
//    searchViewController.searchBarBackgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"默认"]];
    
    searchViewController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:NO completion:nil];
}


@end

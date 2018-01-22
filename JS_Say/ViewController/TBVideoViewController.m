//
//  TBVideoViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/7/31.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "TBVideoViewController.h"
#import "videoTableViewCell.h"
#import "ShowVideoViewController.h"

@interface TBVideoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    TBbaseTableView *mainTable;
    int pageIndex;
    
}
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation TBVideoViewController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    self.edgesForExtendedLayout = UIRectEdgeNone; //navigationController的64高度问题
    //需要设置不能右滑出左菜单
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:NO];
    
    
    //无视手机的静音键，直接播放声音
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"短视频";
    
    mainTable = [[TBbaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    mainTable.estimatedRowHeight = 350;  //  随便设个不那么离谱的值
    mainTable.rowHeight = UITableViewAutomaticDimension;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    [mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-100);
    }];
    
    mainTable.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(loadMoreData)];
    mainTable.mj_header = [AllMethod createTableViewHeader:self andSelect:@selector(loadData)];
    
    [self loadData];
}


-(void)loadData{
    //////////////获取数据///////////////
    NSString *url = [NSString stringWithFormat:@"%@/community/videoContents?pageInvertedIndex=0&pageSize=10&repeatSubmit=53901081&signature=064799A912DE27BA4CC2035D73944AA2",kMainUrl];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"desc"] isEqualToString:@"成功"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSString *pageNum = [dict objectForKey:@"pageInvertedIndex"];
            pageIndex = pageNum.intValue;
            NSArray *arr = [dict objectForKey:@"list"];
            for (NSDictionary *obj in arr) {
                [self.dataArray addObject:obj];
            }
        }
        [mainTable reloadData];
        [mainTable.mj_header endRefreshing];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTable.mj_header endRefreshing];
    } progress:^(float progress) {
        //        NSLog(@"progress：%f",progress);
    }];
}

-(void)loadMoreData{
    if (self.dataArray.count == 0) {
        [self loadData];
        return;
    }
    //////////////获取数据///////////////
    NSString *url = [NSString stringWithFormat:@"%@/community/videoContents?pageInvertedIndex=%d&pageSize=10&repeatSubmit=53901081&signature=064799A912DE27BA4CC2035D73944AA2",kMainUrl,pageIndex];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject){
        //        NSLog(@"success：%@",responseObject);
        if ([[responseObject objectForKey:@"desc"] isEqualToString:@"成功"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *arr = [dict objectForKey:@"list"];
            for (NSDictionary *obj in arr) {
                [self.dataArray addObject:obj];
            }
        }
        [mainTable reloadData];
        [mainTable.mj_footer endRefreshing];
        pageIndex = pageIndex - 10;
        if (pageIndex<10) {
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



#pragma mark -UITableviewDlegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSDictionary *infoDict = self.dataArray[indexPath.row];
    videoTableViewCell *cell = [videoTableViewCell cellWithTableView:tableView withIdentifier:cellId WithDict:infoDict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    ShowVideoViewController *vc = [[ShowVideoViewController alloc]init];
    vc.infoDict = dict;
    [self.navigationController pushViewController:vc animated:YES];
    
    self.tabBarController.tabBar.hidden = YES;
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

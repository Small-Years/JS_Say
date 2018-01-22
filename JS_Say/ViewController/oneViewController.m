//
//  oneViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/17.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "oneViewController.h"
#import "oneVideoTableViewCell.h"
#import "oneShowViewController.h"


@interface oneViewController ()<UITableViewDelegate,UITableViewDataSource>{
    TBbaseTableView *mainTable;
    int pageIndex;
    
}
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation oneViewController

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
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
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
//        make.bottom.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-100);
    }];
    
    mainTable.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(loadMoreData)];
    mainTable.mj_header = [AllMethod createTableViewHeader:self andSelect:@selector(loadData)];
    
    [self loadData];
}


#pragma mark - getData
-(void)loadData{
    [self.dataArray removeAllObjects];
    pageIndex = 0;
    //////////////获取数据/////////////// 军事新闻武
    //    http://api.wap.miercn.com/api/2.0.3/newlist.php?plat=ios&proct=mierapp&versioncode=20150610&apiCode=5&list=6&page=0
    NSString *url = [NSString stringWithFormat:@"http://api.wap.miercn.com/api/2.0.3/newlist.php?plat=ios&proct=mierapp&versioncode=20150610&apiCode=5&list=6&page=%d",pageIndex];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"0"]) {
            
            NSArray *arr = [responseObject objectForKey:@"newsList"];
            for (NSDictionary *obj in arr) {
                [self.dataArray addObject:obj];
            }
        }
        [mainTable reloadData];
        [mainTable.mj_header endRefreshing];
        pageIndex = pageIndex + 1;
    } withFailureBlock:^(NSError *error) {
//        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTable.mj_header endRefreshing];
        [mainTable reloadData];
    } progress:^(float progress) {
        
    }];
}

-(void)loadMoreData{
    if (self.dataArray.count == 0) {
        [self loadData];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://api.wap.miercn.com/api/2.0.3/newlist.php?plat=ios&proct=mierapp&versioncode=20150610&apiCode=5&list=6&page=%d",pageIndex];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"0"]) {
            
            NSArray *arr = [responseObject objectForKey:@"newsList"];
            for (NSDictionary *obj in arr) {
                [self.dataArray addObject:obj];
            }
        }
        [mainTable reloadData];
        [mainTable.mj_footer endRefreshing];
        pageIndex = pageIndex + 1;
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTable.mj_footer endRefreshing];
    } progress:^(float progress) {
        
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
    oneVideoTableViewCell *cell = [oneVideoTableViewCell cellWithTableView:tableView withIdentifier:cellId WithDict:infoDict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    oneShowViewController *vc = [[oneShowViewController alloc]init];
    vc.infoDict = dict;
    [self.navigationController pushViewController:vc animated:YES];
    
    self.tabBarController.tabBar.hidden = YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

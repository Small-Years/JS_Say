//
//  TBFindViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/24.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "TBFindViewController.h"
#import "findTableViewCell.h"
#import "TBFindInfoViewController.h"

@interface TBFindViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mainTable;
    NSString *lastTime;
}
@property (nonatomic,strong)NSMutableArray * dataArray;



@end

@implementation TBFindViewController


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"广场";
    self.view.backgroundColor = [UIColor whiteColor];
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
    mainTable.backgroundColor = [UIColor whiteColor];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    mainTable.estimatedRowHeight = 50;  //  随便设个不那么离谱的值
    mainTable.rowHeight = UITableViewAutomaticDimension;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    mainTable.mj_header = [AllMethod createTableViewHeader:self andSelect:@selector(loadData)];
    mainTable.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(loadMoreData)];
    
    [self loadData];
    
}

#pragma -mark getData
-(void)loadData{
    lastTime = @"0";
    [self.dataArray removeAllObjects];
    //获取社区动态
    NSString *URLStr = [NSString stringWithFormat:@"%@/strategy/v3/news/get_newslist?type=mil&lasttime=%@",kPicUrl,lastTime];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:URLStr withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *arr = [dict objectForKey:@"lists"];
            for (NSDictionary *obj in arr) {
                [self.dataArray addObject:obj];
            }
            
            NSDictionary *lastObj = [self.dataArray lastObject];
            lastTime = [lastObj objectForKey:@"lasttime"];
        }
        
        [mainTable reloadData];
        [mainTable.mj_header endRefreshing];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTable.mj_header endRefreshing];
    } progress:^(float progress) {
        NSLog(@"progress：%f",progress);
    }];
}

-(void)loadMoreData{
    if (self.dataArray.count == 0) {
        [self loadData];
        [mainTable.mj_footer endRefreshing];
        return;
    }
    [self.dataArray removeAllObjects];
    //获取社区动态
    NSString *URLStr = [NSString stringWithFormat:@"%@/strategy/v3/news/get_newslist?type=mil&lasttime=%@",kPicUrl,lastTime];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:URLStr withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *arr = [dict objectForKey:@"lists"];
            for (NSDictionary *obj in arr) {
                [self.dataArray addObject:obj];
            }
            
            NSDictionary *lastObj = [self.dataArray lastObject];
            lastTime = [lastObj objectForKey:@"lasttime"];
        }
        
        [mainTable reloadData];
        [mainTable.mj_footer endRefreshing];
    } withFailureBlock:^(NSError *error) {
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTable.mj_footer endRefreshing];
    } progress:^(float progress) {
        
    }];
}

#pragma mark -UITablviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSDictionary *infoDict = self.dataArray[indexPath.row];
    
    findTableViewCell *cell = [findTableViewCell cellWithTableView:tableView withIdentifier:cellId WithDict:infoDict withRow:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *infoDict = self.dataArray[indexPath.row];
    
    TBFindInfoViewController *vc = [[TBFindInfoViewController alloc]init];
    vc.infoDict = infoDict;
    [self.navigationController pushViewController:vc animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

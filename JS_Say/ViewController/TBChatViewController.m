//
//  TBChatViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/7/31.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "TBChatViewController.h"
#import "newsTableViewCell.h"
#import "ChatInfoViewController.h"

@interface TBChatViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mainTable;
    int pageIndex;
}
@property (nonatomic,strong)NSMutableArray * dataArray;


@end

@implementation TBChatViewController

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
    
    mainTable.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(loadMoreData)];
    mainTable.mj_header = [AllMethod createTableViewHeader:self andSelect:@selector(loadData)];
    
    [self loadData];
}

-(void)loadData{
    [self.dataArray removeAllObjects];
    //获取社区动态
    NSString *URLStr = [NSString stringWithFormat:@"%@/community/followContentList?pageInvertedIndex=0&pageSize=10&repeatSubmit=27649501&signature=1E39F9541F9A36E43211B2AD7494EA34&token=3b080579e745458aa9633337b505a82c",kMainUrl];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:URLStr withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
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
        NSLog(@"progress：%f",progress);
    }];
}

-(void)loadMoreData{
    if (self.dataArray.count == 0) {
        [self loadData];
        return;
    }
    //////////////获取数据///////////////
//    NSLog(@"%d",pageIndex);
    NSString *url = [NSString stringWithFormat:@"%@/community/followContentList?pageInvertedIndex=%d&pageSize=10&repeatSubmit=27649501&signature=1E39F9541F9A36E43211B2AD7494EA34&token=3b080579e745458aa9633337b505a82c",kMainUrl,pageIndex];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject){
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
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试!"] WithController:self WithAction:nil];
        [mainTable.mj_footer endRefreshing];
    } progress:^(float progress) {
        NSLog(@"progress：%f",progress);
    }];
}

#pragma mark -UITablviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSDictionary *infoDict = self.dataArray[indexPath.row];
    
    newsTableViewCell *cell = [newsTableViewCell cellWithTableview:tableView withIdentifier:cellId WithDict:infoDict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *infoDict = self.dataArray[indexPath.row];
    
    ChatInfoViewController *vc = [[ChatInfoViewController alloc]init];
    vc.newsID = [infoDict objectForKey:@"id"];
    vc.infoDict = infoDict;
    [self.navigationController pushViewController:vc animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

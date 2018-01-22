//
//  WeaponsListViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/9.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "WeaponsListViewController.h"
#import "WeaponsListTableViewCell.h"
#import "WeaponsInfoViewController.h"
//#import "HTMLViewController.h"
//#import "HTMLParsingViewController.h"
@interface WeaponsListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mainTable;
    int pageIndex;
    NSString *typeStr;
}

@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation WeaponsListViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.infoDict objectForKey:@"text"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [AllMethod getLeftButtonBarItemSelect:@selector(popView) andTarget:self];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    mainTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    mainTable.height = self.view.bounds.size.height - 64;
    mainTable.backgroundColor = [UIColor whiteColor];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    mainTable.estimatedRowHeight = 80;  //  随便设个不那么离谱的值
    mainTable.rowHeight = UITableViewAutomaticDimension;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    mainTable.mj_header = [AllMethod createTableViewHeader:self andSelect:@selector(loadData)];
    mainTable.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(loadMoreData)];
    
    
    [self loadData];
    
}

-(void)loadData{
    pageIndex = 1;
    NSString *url = [NSString stringWithFormat:@"http://jw.api.justoper.com/api/weapon/weaponlist?v=111&bigtypeId=%@&typeid=0&countryid=0&periodid=0&pageindex=%d&pageSize=10",[self.infoDict objectForKey:@"url"],pageIndex];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *dict = [responseObject objectForKey:@"body"];
        NSArray *arr = [dict objectForKey:@"items"];
        for (NSDictionary *obj in arr) {
            [self.dataArray addObject:obj];
        }
        [mainTable reloadData];
        [mainTable.mj_header endRefreshing];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTable.mj_header endRefreshing];
    } progress:^(float progress) {
        
    }];
}
-(void)loadMoreData{
    if (self.dataArray.count == 0) {
        [self loadData];
        return;
    }
    pageIndex = pageIndex + 1;
    NSString *url = [NSString stringWithFormat:@"http://jw.api.justoper.com/api/weapon/weaponlist?v=111&bigtypeId=%@&typeid=0&countryid=0&periodid=0&pageindex=%d&pageSize=10",[self.infoDict objectForKey:@"url"],pageIndex];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *dict = [responseObject objectForKey:@"body"];
        NSArray *arr = [dict objectForKey:@"items"];
        if (arr.count == 0) {
            [mainTable.mj_footer endRefreshingWithNoMoreData];
        }else{
            for (NSDictionary *obj in arr) {
                [self.dataArray addObject:obj];
            }
            [mainTable.mj_footer endRefreshing];
        }
        [mainTable reloadData];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
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
    
    WeaponsListTableViewCell *cell = [WeaponsListTableViewCell cellWithTableView:tableView withIdentifier:cellId WithDict:infoDict withRow:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *objDict = self.dataArray[indexPath.row];
    WeaponsInfoViewController *vc = [[WeaponsInfoViewController alloc]init];
    vc.infoDict = objDict;
    [self.navigationController pushViewController: vc animated:YES];
    
}


-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

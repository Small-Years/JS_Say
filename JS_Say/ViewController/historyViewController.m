//
//  historyViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/24.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "historyViewController.h"
#import "historyTableViewCell.h"
//#import "historyInfoViewController.h"
#import "NewHistoryInfoViewController.h"

@interface historyViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mainTableView;
    
    NSString *mainURL;
    
    int pageIndex;
}
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation historyViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史闲谈";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [AllMethod getLeftButtonBarItemSelect:@selector(popView) andTarget:self];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    mainTableView.backgroundColor = [UIColor whiteColor];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    mainTableView.estimatedRowHeight = 150;  //  随便设个不那么离谱的值
    mainTableView.rowHeight = UITableViewAutomaticDimension;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(loadMoreData)];
    mainTableView.mj_header = [AllMethod createTableViewHeader:self andSelect:@selector(loadData)];
    [mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    [self loadData];
}

-(void)loadData{
    pageIndex = 0;
    [self.dataArray removeAllObjects];
    NSString *newURL = [NSString stringWithFormat:@"http://api.wap.miercn.com/api/2.0.3/newlist.php?plat=ios&proct=mierapp&versioncode=20150610&apiCode=5&list=4&page=%d",pageIndex];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:newURL withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *dict = responseObject;
        NSArray *arr = [dict objectForKey:@"newsList"];
        self.dataArray = [arr mutableCopy];
        [mainTableView reloadData];
        pageIndex = 1;
        [mainTableView.mj_header endRefreshing];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTableView.mj_header endRefreshing];
    } progress:^(float progress) {
    }];
}

-(void)loadMoreData{
    if (self.dataArray.count == 0) {
        [self loadData];
        return;
    }
    NSString *newURL = [NSString stringWithFormat:@"http://api.wap.miercn.com/api/2.0.3/newlist.php?plat=ios&proct=mierapp&versioncode=20150610&apiCode=5&list=4&page=%d",pageIndex];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:newURL withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *dict = responseObject;
        NSArray *arr = [dict objectForKey:@"newsList"];
        for (NSDictionary *dict in arr) {
            [self.dataArray addObject:dict];
        }
        [mainTableView reloadData];
        pageIndex = pageIndex + 1;
        [mainTableView.mj_footer endRefreshing];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTableView.mj_footer endRefreshing];
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
    historyTableViewCell *cell = [historyTableViewCell cellWithTableView:tableView withIdentifier:cellId WithDict:infoDict withRow:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    NewHistoryInfoViewController *vc = [[NewHistoryInfoViewController alloc]init];
    vc.infoDict = dict;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

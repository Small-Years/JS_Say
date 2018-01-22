//
//  ItemViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/7.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "ItemViewController.h"
#import "itemTableViewCell.h"
#import "ItemInfoViewController.h"

@interface ItemViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mainTableView;
    
    NSString *mainURL;
    
    int pageIndex;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation ItemViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    mainTableView.backgroundColor = [UIColor whiteColor];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    mainTableView.estimatedRowHeight = 350;  //  随便设个不那么离谱的值
    mainTableView.rowHeight = UITableViewAutomaticDimension;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(loadMoreData)];
    mainTableView.mj_header = [AllMethod createTableViewHeader:self andSelect:@selector(loadDataMethod)];
    [mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
}
//


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //    需要通过title来进行选择
    if ([self.titleStr isEqualToString:@"国际情报"]) {
        mainURL = [NSString stringWithFormat:@"https://api.idwoo.com/api/junqing/get_category_posts/?id=3id&page="];
    }else if ([self.titleStr isEqualToString:@"军情解密"]){
        mainURL = [NSString stringWithFormat:@"https://api.idwoo.com/api/junqing/get_category_posts/?id=8id&page="];
    }else if ([self.titleStr isEqualToString:@"军事秘闻"]){
        mainURL = [NSString stringWithFormat:@"https://api.idwoo.com/api/junqing/get_category_posts/?id=7id&page="];
    }else if ([self.titleStr isEqualToString:@"中国情报"]){
        mainURL = [NSString stringWithFormat:@"https://api.idwoo.com/api/junqing/get_category_posts/?id=2id&page="];
    }
    pageIndex = 1;
    [self loadDataMethod];
}
-(void)loadDataMethod{
    [self.dataArray removeAllObjects];
    pageIndex = 1;
    NSString *newURL = [NSString stringWithFormat:@"%@%d",mainURL,pageIndex];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:newURL withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *dict = responseObject;
        NSArray *arr = [dict objectForKey:@"posts"];
        self.dataArray = [arr mutableCopy];
        [mainTableView reloadData];
        [mainTableView.mj_header endRefreshing];
        pageIndex = pageIndex + 1;
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTableView.mj_header endRefreshing];
    } progress:^(float progress) {
    }];
}
-(void)loadMoreData{
    if (self.dataArray.count == 0) {
        [self loadDataMethod];
        return;
    }
    NSString *newURL = [NSString stringWithFormat:@"%@%d",mainURL,pageIndex];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:newURL withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *dict = responseObject;
        NSArray *arr = [dict objectForKey:@"posts"];
        if (arr.count == 0) {
            [mainTableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            for (NSDictionary *obj in arr) {
                [self.dataArray addObject:obj];
            }
            [mainTableView reloadData];
            [mainTableView.mj_footer endRefreshing];
            pageIndex = pageIndex + 1;
        }
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
    itemTableViewCell *cell = [itemTableViewCell cellWithTableView:tableView withIdentifier:cellId WithDict:infoDict withRow:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    ItemInfoViewController *vc = [[ItemInfoViewController alloc]init];
    vc.infoDict = dict;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

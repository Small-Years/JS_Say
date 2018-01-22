//
//  LoveListViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/9/25.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "LoveListViewController.h"

@interface LoveListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    TBbaseTableView *mainTable;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation LoveListViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
        NSArray *arr1 = @[@{@"name":@"消息",@"iconName":@"消息",@"code":@"1"},@{@"name":@"夜间模式",@"iconName":@"夜间模式",@"code":@"2"},@{@"name":@"去除广告",@"iconName":@"去除广告",@"code":@"3"},@{@"name":@"推荐给朋友",@"iconName":@"推荐给朋友",@"code":@"4"},@{@"name":@"收藏时分享",@"iconName":@"收藏时分享",@"code":@"5"}];
        
        for (NSDictionary *obj in arr1) {
            [_dataArray addObject:obj];
        }
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏";
    
    mainTable = [[TBbaseTableView alloc]initWithFrame:self.view.frame];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    mainTable.tableFooterView = [[UIView alloc]init];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    mainTable.estimatedSectionHeaderHeight = 0;
    
}

#pragma -mrak UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    TBbaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *dict = self.dataArray[indexPath.row] ;
    if (cell == nil) {
        cell = [[TBbaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
        BaseLabel *titleLable = [[BaseLabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-30-20, 30)];
        titleLable.centerY = cell.contentView.centerY;
        titleLable.text = [dict objectForKey:@"name"];
        [cell.contentView addSubview:titleLable];
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BaseView *headView = [[BaseView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    return headView;
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

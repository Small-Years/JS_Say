//
//  SearchViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/4.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "TBSearchViewController.h"
#import "newsTableViewCell.h"
#import "ChatInfoViewController.h"

@interface TBSearchViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mainTable;
    int pageIndex;
}

@end

@implementation TBSearchViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    self.view.backgroundColor = [UIColor whiteColor];
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    mainTable.backgroundColor = [UIColor grayColor];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    mainTable.estimatedRowHeight = 200;  //  随便设个不那么离谱的值
    mainTable.rowHeight = UITableViewAutomaticDimension;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
//    mainTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    mainTable.mj_header = [AllMethod createTableViewHeader:self andSelect:@selector(loadData)];
    mainTable.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(loadMoreData)];
    
    [self loadData];

}
-(void)loadMoreData{
    
}
-(void)loadData{
    
    
    NSString *url = [NSString stringWithFormat:@"%@/select/camps?pageInvertedIndex=0&pageSize=10&repeatSubmit=62851721&signature=8EE76EC69261A384B08A04469D88601E&title=%@",kMainUrl,[self encodeString:self.searchText]];
    NSLog(@"---%@",url);
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
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        
    } progress:^(float progress) {
        NSLog(@"progress：%f",progress);
    }];
    
}
-(NSString*)encodeString:(NSString*)unencodedString{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
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
    [self.navigationController pushViewController:vc animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}


-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}





@end
